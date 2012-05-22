# encoding: utf-8
Tire.configure do
  url ENV['JENKINS_ES'] || Gaston.tire.host
end

Tire::Model::Search.index_prefix "mdd-#{Rails.env}"

INDEX_DEFAULT_CLASSES = %w{Sheet}

