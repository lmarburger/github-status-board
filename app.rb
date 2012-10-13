# encoding: utf-8
require 'sinatra'
require 'sinatra/config_file'
require 'sinatra/cookies'
require 'sinatra/namespace'

require 'json'
require 'rack/cache'

require_relative 'models'

config_file 'config.yml'

enable :show_exceptions

set(:js_assets) { Dir['{public,views}/**/*.{js,coffee}'].sort }

use Rack::Static, :urls => %w[/favicon.ico /apple-touch-icon], :root => 'public'

set(:cache_folder) { "#{settings.root}/tmp/cache" }

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
    StatusBoard.new cookies[:token]
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
  redirect auth_process.authorize_url
end

get '/callback' do
  cookies[:token] = auth_process.get_token params[:code]
  redirect '/'
end


# API
namespace '/api/repos' do
  get do
    json status_board.repos.map {|repo|
      { name: repo.name, slug: repo.full_name }
    }
  end

  get '/:owner/:repo/events' do |owner, repo|
    events = status_board.events_for_repo owner, repo

    pretty_json events
  end

  # get '/:owner/:repo' do |owner, repo|
  #   json octo_client.repsitory(owner: owner, repo: repo)
  # end

  # get '/:owner/:repo/commits' do |owner, repo|
  #   json []
  # end

  # get '/:owner/:repo/commits/:sha' do |owner, repo, sha|
  #   json Hash.new
  # end
end
