require 'rubygems'
require 'bundler'

Bundler.setup

Encoding.default_external = 'utf-8'

require 'debugger' if ENV['RACK_ENV'] == 'development'

app_dir = ENV['APP_ROOT'] || File.expand_path('..', __FILE__)
require "#{app_dir}/app"
run Sinatra::Application
