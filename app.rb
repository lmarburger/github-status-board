# encoding: utf-8
require 'sinatra'
require 'sinatra/config_file'
require 'sinatra/cookies'

require 'oauth2'
require 'octokit'

require 'json'
require "sinatra/namespace"


config_file 'config.yml'

enable :show_exceptions

set(:js_assets) { Dir['**/*.{js,coffee}'].sort }

use Rack::Static, :urls => %w[/favicon.ico /apple-touch-icon], :root => 'public'

set(:cache_folder) { "#{settings.root}/tmp/cache" }

configure do
  require 'rack/cache'
  use Rack::Cache,
    allow_reload: true,
    verbose:      settings.development?,
    metastore:    "file:#{settings.cache_folder}/meta",
    entitystore:  "file:#{settings.cache_folder}/body"
end

require 'rack/deflater'
use Rack::Deflater

require 'sinatra_boilerplate'

helpers do
  def json obj
    content_type 'application/json'
    JSON.generate obj
  end
end

get "/" do
  if cookies[:token]
    erb :index
  else
    erb :login
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
    [{name: "Elliott's Repo", slug: "elliotts-repo"},
    {name: "Hector's Repo", slug: "hectors-repo", events: [
      {type: "CommitEvent", sha: "12345", message: "abc"},
      {type: "CommitEvent", sha: "2345", message: "abc"},
      {type: "CommitEvent", sha: "3456", message: "abc"},
      {type: "CommitEvent", sha: "4567", message: "abc"},
      {type: "CommitEvent", sha: "5678", message: "abc"}
    ]}].to_json
  end

  get '/repos/:id' do
    json Hash.new
  end

  get '/repos/:id/commits' do
    json []
  end

  get '/commits/:id' do
    json Hash.new
  end

  get '/repos/:id/events' do
    json []
  end

  get '/events' do
    json []
  end

  get '/events/:id' do
    json Hash.new
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
  Octokit::Client.new oauth_token: token, auto_traversal: true
end

def repos
  octo_client(cookies[:token]).repos(nil, sort: 'pushed')
end
