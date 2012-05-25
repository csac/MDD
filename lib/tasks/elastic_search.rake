# encoding: utf-8

require 'fileutils'

namespace :es do

  ES_VERSION = "0.19.2".freeze

  ES_HOME = '~/elasticsearch'.freeze

  def es_home
    File.expand_path(ES_HOME)
  end

  def executable
    File.join(es_home, 'current', 'bin', 'elasticsearch')
  end

  def pid_file
    pids_dir = Rails.root.join('tmp', 'pids')
    FileUtils.mkdir_p pids_dir
    File.join(pids_dir, 'elasticsearch.pid')
  end

  def pid
    _pid = File.read(pid_file) if File.exists?(pid_file)
    actual_pid = is_running?

    if _pid
      if actual_pid
        actual_pid
      else
        puts "No running process matches the PID listed in #{pid_file}"
      end
    else
      if actual_pid.present?
        $stderr.puts "No PID was found, but the process seems to be running.. (actual PID: #{actual_pid})"
      end

      actual_pid
    end
  end

  def is_running?(process_name=nil)
    process_name = Regexp.new(process_name || 'elasticsearch')

    match = `ps x`.split("\n").find {|l| l =~ process_name }

    if match
      match.split(/\s+/).reject {|f| f == "" }.first
    end
  end

  desc "Install latest version (#{ES_VERSION}) of ElasticSearch"
  task :install do
    package_name = "elasticsearch-#{ES_VERSION}"
    es_release = File.join(es_home, package_name)
    current_dir = File.join(es_home, 'current')
    package = "#{package_name}.tar.gz"
    github_tarball = "http://github.com/downloads/elasticsearch/elasticsearch/#{package}"
    workdir = "/tmp"
    FileUtils.mkdir_p es_home

    if !( File.exists?(es_release) && File.symlink?(current_dir) && File.readlink(current_dir) == es_release )

      puts "* Downloading ElasticSearch #{ES_VERSION} into #{workdir}..."
      if `which wget`.chomp.present?
        `wget -nc -q --no-check-certificate -P #{workdir} #{github_tarball}`
      elsif `which curl`.chomp.present?
        `curl --location -C - #{github_tarball} -o #{workdir}/#{package}`
      else
        puts "@@@ Can't find HTTP client for Downloading ElasticSearch"
        exit 1
      end

      puts "* Extracting #{workdir}/#{package} into #{es_release}"
      `cd #{es_home} && tar zxf #{workdir}/#{package}`

      puts "* Symlinking #{es_release} to #{es_home}/current"
      `ln -sf #{es_release} #{es_home}/current`

      config_files = Dir[Rails.root.join('config', 'templates', 'elasticsearch', '*')]
    end
    if config_files.present?
      puts "* Add our configuration files"
      config_files.each do |f|
        dest_file = File.join(es_release, 'config', File.basename(f))

        puts `cp -v #{dest_file} #{dest_file}.dist`  if File.exists?(dest_file)
        puts `cp -v #{f} #{dest_file}`
      end
    end

  end

  desc 'Install head plugin for elastic search (http://localhost:9200/_plugin/head/)'
  task :head => :install do
    package_name = "elasticsearch-#{ES_VERSION}"
    es_release = File.join(es_home, package_name)
    if ! File.exists?("#{es_release}/plugins/head")
      sh "#{es_release}/bin/plugin -install mobz/elasticsearch-head"
    end
  end

  desc 'Start elasticsearch'
  task :start do
    if sh "#{executable} -p #{pid_file}"
      puts "* Elastic Search started (PID: #{pid})"
    else
      puts "!!! Elastic Search could not be started"
    end
  end


  desc 'Stop elasticsearch'
  task :stop do
    process_pid = pid

    if process_pid
      if system("kill #{process_pid}")
        puts "* ElasticSearch stopped (PID #{process_pid})"
      else
        $stderr.puts "Could not stop ElasticSearch!"
        exit 1
      end

      index = 0
      while is_running? do
        if index >= 20
          $stderr.puts "!!! Could not stop Elastic Search after 5s"
          exit 1
        else
          sleep 0.5
          index += 1
        end
      end
    else
      $stderr.puts "No PID found for Elastic Search!"
      exit 1
    end
  end

  desc 'Restart ElasticSearch'
  task :restart => [:stop, :start]


  desc "Start or restart ElasticSearch"
  task :running_restart do
    if is_running?
      Rake::Task['es:stop'].invoke
    end

    Rake::Task['es:start'].invoke
  end

  desc "Start Elastic Search only if necessary"
  task :soft_start do
    unless pid
      Rake::Task['es:start'].invoke
    end
  end

  namespace :reindex do

    # Delete, create and import ES indexes
    def recreate_indexes!(klass = nil)
      Array(klass || INDEX_DEFAULT_CLASSES).each do |k|
        k = k.try(:constantize)
        k.tire.index.delete
        k.tire.create_elasticsearch_index
        k.instance_eval do
          def self.paginate(options = {})
            page(options[:page]).per(options[:per_page])
          end
        end
        k.import
      end
    end

    desc "Recreate all index and reindex last records for ES/Tire models"
    task :all => :environment do
      recreate_indexes!
    end

    ##
    #
    # The models are not loaded at this states
    #
    %w{Medium Product MediumType Company}.each do |klass|
      desc "Recreate #{klass} index and reindex last records for ES/Tire models"
      task klass.to_s.underscore => :environment do
        recreate_indexes!(klass)
      end
    end
  end



end
