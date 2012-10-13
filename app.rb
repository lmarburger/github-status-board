# encoding: utf-8
require 'sinatra'
require 'sinatra/config_file'
require 'sinatra_boilerplate'

require 'oauth2'
require 'octokit'

config_file 'config.yml'

enable :show_exceptions

set :js_assets, %w[zepto.js underscore.js app.coffee]

configure :development do
  set :logging, false
end

get "/" do
  erb :index
end

get '/auth' do
  client = OAuth2::Client.new settings.github_application[:client_id],
                              settings.github_application[:client_secret],
                              site:          'https://github.com/login',
                              authorize_url: 'oauth/authorize',
                              token_url:     'oauth/access_token'
  redirect client.auth_code.authorize_url
end

get '/callback' do
  raise params.inspect
end
