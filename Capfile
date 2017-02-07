require "capistrano/setup"
require "capistrano/deploy"
require "capistrano/rvm"
require "capistrano/bundler"
require "capistrano/rails"
require "capistrano/sidekiq"
require "whenever/capistrano"
require 'thinking_sphinx/capistrano'
require "capistrano/scm/git"
require "capistrano3/unicorn"

install_plugin Capistrano::SCM::Git

Dir.glob("lib/capistrano/tasks/*.rake").each { |r| import r }
