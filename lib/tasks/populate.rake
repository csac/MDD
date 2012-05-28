# encoding: utf-8
namespace :db do

  I18n.locale = :en

  desc "initialize"
  task :init => [:environment] do
    raise "\n Please run `rake db:seed` before" if KeywordCategory.count == 0

    require 'ffaker'
    I18n.reload!
    require 'fabrication'
    Dir[Rails.root.join("spec/fabricators/**/*.rb")].each {|f| require f}

    # dont send email
    ActionMailer::Base.delivery_method = :test

    def generate_user
      Fabricate :user
    end

    def generate_sheet
      Fabricate :sheet
    end

    def print_more
      print '.'
      STDOUT.flush
    end

    def nb
      (ENV['NB'] || 1).to_i
    end

  end

  desc "do all populate tasks"
  task :populate => [:init] do
    Rake::Task['db:populate:default'].invoke
  end

  namespace :populate do

    desc 'default: do all populate tasks'
    task :default => [
      :users,
      :sheet,
    ]

    desc "Create 10 users"
    task :users => :init do
      print "Create 10 users"
      (10 * nb).times {
        generate_user
        print_more
      }
      puts ""
    end

    desc "Create 10 sheets"
    task :sheets => :init do
      print "Create 10 sheets"
      (10 * nb).times {
        generate_sheet
        print_more
      }
      puts ""
    end

  end
end
