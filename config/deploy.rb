# Encoding: utf-8

set :user,    "mdd"
set :appname, "mdd"

require "capistrano/af83"

load "af83/info"
set :repository, "git@github.com:AF83/MDD.git"

# Use the capistrano rules for precompiling assets with the Rails assets
# pipeline on deploys.
set :public_children, %w(images)
# load "deploy/assets"
# OR you can choose our improved version of this task:
# load "af83/deploy/assets"

load "af83/thin"
load "af83/database"

# TODO uncomment the extensions you want to use
# load "af83/custom_maintenance_page"
# load "af83/es"
# load "af83/mongoid"
# load "af83/resque"
# load "af83/js_routes"

