# encoding: utf-8
require 'sinatra'
require 'sinatra/config_file'
require 'sinatra/cookies'
require 'sinatra_boilerplate'

require 'oauth2'
require 'octokit'

require 'json'
require "sinatra/namespace"


config_file 'config.yml'

enable :show_exceptions

set :js_assets, %w[zepto.js underscore.js app.coffee]

configure :development do
  set :logging, false
end

get "/" do
  if cookies[:token]
    erb :index
  else
    redirect '/auth'
  end
end

get '/auth' do
  redirect oauth_client.auth_code.authorize_url
end

get '/callback' do
  token = oauth_client.auth_code.get_token params[:code]
  cookies[:token] = token.token
  redirect '/'
end



# API
namespace '/api' do
  get '/repos' do
    [].to_json
  end

  get '/repos/:id' do
    {}.to_json
  end

  get '/repos/:id/commits' do
    [].to_json
  end

  get '/commits/:id' do
    {}.to_json
  end

  get '/repos/:id/events' do
    [].to_json
  end

  get '/events' do
    [].to_json
  end

  get '/events/:id' do
    {}
  end
end



private

def oauth_client
  OAuth2::Client.new settings.github_application[:client_id],
                     settings.github_application[:secret],
                     site:          'https://github.com/login',
                     authorize_url: 'oauth/authorize',
                     token_url:     'oauth/access_token'
end

def octo_client(token)
  Octokit::Client.new oauth_token: token
end

def repos
  octo_client(cookies[:token]).repos
end
