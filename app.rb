# encoding: utf-8
require 'sinatra'
require 'sinatra/config_file'
require 'sinatra/cookies'
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
