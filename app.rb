# encoding: utf-8
require 'sinatra'
require 'sinatra/config_file'
require 'sinatra/namespace'

require 'json'
require 'rack/cache'

require_relative 'models'

config_file 'config.yml'

set(:js_assets)    { Dir['{public,views}/**/*.{js,coffee}'].sort }
set(:cache_folder) { "#{settings.root}/tmp/cache" }
set :sessions,     { expire_after: 60 * 60 * 24 * 7 }

use Rack::Static, :urls => %w[/favicon.ico /apple-touch-icon], :root => 'public'

StatusBoard.cache_prefix = settings.cache_folder + '/api_'

configure :production do
  use Rack::Cache,
    allow_reload: true,
    verbose:      settings.development?,
    metastore:    "file:#{settings.cache_folder}/meta",
    entitystore:  "file:#{settings.cache_folder}/body"
end

require 'rack/deflater'
use Rack::Deflater

configure :development do
  require 'terminal-notifier'

  BreakageYeller = Struct.new(:app) {
    def call env
      begin
        app.call env
      rescue
        path = env['PATH_INFO']
        if path =~ /\.(js|css)\b/
          TerminalNotifier.notify(path, title: 'Asset broken')
        end
        raise
      end
    end
  }

  use BreakageYeller
end

require 'sinatra_boilerplate'

helpers do
  def json obj
    content_type 'application/json'
    JSON.generate obj
  end

  def pretty_json obj
    content_type 'application/json'
    JSON.pretty_generate obj
  end

  def auth_process
    AuthProcess.new(settings)
  end

  def status_board
    StatusBoard.new session[:token]
  end
end

get "/" do
  if session[:token]
    erb :index
  else
    erb :login, layout: false
  end
end

get '/auth' do
  redirect auth_process.authorize_url
end

get '/callback' do
  session[:token] = auth_process.get_token params[:code]
  redirect '/'
end

# API
namespace '/api/repos' do
  get do
    pretty_json status_board.events_by_repo
  end

  get '/:owner/:repo/events' do |owner, repo|
    events = status_board.events_for_repo owner, repo
    pretty_json events
  end

  get '/:owner/:repo/commits/:sha' do |owner, repo, sha|
    commit = status_board.commit owner, repo, sha
    commit['comments'] = status_board.commit_comments owner, repo, sha
    pretty_json commit
  end

  get '/:owner/:repo/commits/:sha/comments' do |owner, repo, sha|
    comments = status_board.commit_comments owner, repo, sha
    pretty_json comments
  end

  get '/:owner/:repo/issues/:issue/comments' do |owner, repo, issue|
    comments = status_board.issue_comments owner, repo, issue
    pretty_json comments
  end

  get '/:owner/:repo/pulls/:pull_request/comments' do |owner, repo, pull_request|
    comments = status_board.pull_request_comments owner, repo, pull_request
    pretty_json comments
  end
end
