source 'https://rubygems.org'

gem 'rails', '3.2.3'
gem 'thin',  '~>1.3.1'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'pg', '~>0.13.2'

gem 'mo', '~>0.0.3'

gem 'jquery-rails', '~>2.0.2'
gem 'haml-rails', '~>0.3.4'

gem 'kaminari', '~>0.13.0'
gem 'yajl-ruby', '~>1.1.0'
gem 'inherited_resources', '~>1.3.1'
gem 'bootstrap-sass', '~>2.0.2'
gem 'bootswatch-rails', '~>0.0.11'
gem 'simple_form', '~>2.0.1'
gem 'redcarpet', '~>2.1.1'
gem 'devise', '~>2.0.4'
gem 'cancan', '~>1.6.7'
gem 'role_model', '~>0.7.0'
gem 'tire', '~> 0.3.12'
gem "gaston", "~>0.1.1"
gem "ckeditor", "~> 3.7.1"
gem "carrierwave", "~> 0.6.2"
gem "mini_magick"

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platform => :ruby

  gem 'uglifier',     '>= 1.0.3'
  gem 'therubyracer', '~>0.9.10'  # Coffescript compilation
end

group :test do
  gem 'simplecov'       , '~> 0.5.4', require: false
  gem 'rspec-rails'     , '~> 2.8.1'
  gem 'turn', '~>0.9.2', require: false # Pretty printed test output
  gem 'database_cleaner', '~>0.7.2'
  gem 'fuubar', '~>1.0.0'
end

group :development do
  gem "capistrano-af83" , '~> 0.2.1'
  gem 'shout-bot', '=0.0.4'
  gem "annotate", :git => "git://github.com/ctran/annotate_models.git"
  gem 'simplecov', '~>0.5.4', require: false # Code coverage
  gem 'letter_opener', '~>0.0.2'
  gem 'quiet_assets'
end

group :test, :development do
  gem 'ffaker', '~>1.12.1'                    # Generate fake data
  gem 'fabrication', '~>1.2.0'               # Object generator for specs
end
