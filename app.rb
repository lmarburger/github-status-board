# encoding: utf-8
require 'sinatra'
require 'sinatra/config_file'
require 'sinatra_boilerplate'

config_file 'config.yml'

set :js_assets, %w[zepto.js underscore.js app.coffee]

configure :development do
  set :logging, false
end

get "/" do
  erb :index
end
