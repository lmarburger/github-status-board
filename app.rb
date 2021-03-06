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
  require 'airbrake'
  Airbrake.configure do |config|
    config.api_key = settings.airbrake_api_key
  end
  use Airbrake::Rack

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

require_relative 'lib/sinatra_boilerplate'

helpers do
  def repo_seed_data
    data = status_board.events_by_repo
    if settings.development?
      JSON.pretty_generate data
    else
      JSON.generate data
    end
  end

  def json obj
    unless request.xhr?
      # pretty output for browser and curl
      content_type curl? ? 'application/json' : 'text/javascript'
      JSON.pretty_generate obj
    else
      # compact output for Ajax
      content_type 'application/json'
      JSON.generate obj
    end
  end

  def curl?
    request.user_agent.to_s.start_with? 'curl/'
  end

  def auth_process
    AuthProcess.new(settings)
  end

  def status_board
    StatusBoard.new session[:token]
  end

  JS_ESCAPE_MAP = {
    '\\'    => '\\\\',
    '</'    => '<\/',
    "\r\n"  => '\n',
    "\n"    => '\n',
    "\r"    => '\n',
    '"'     => '\\"',
    "'"     => "\\'"
  }

  def escape_javascript string
    string.gsub(/(\\|<\/|\r\n|\342\200\250|[\n\r"'])/u) {|match| JS_ESCAPE_MAP[match] }
  end
end

get "/" do
  if session[:token]
    erb :index
  else
    erb :login
  end
end

get '/auth' do
  redirect auth_process.authorize_url
end

get '/callback' do
  session[:token] = auth_process.get_token params[:code]
  redirect '/'
end

get '/logout' do
  session.delete :token
  redirect '/'
end

get '/templates.js' do
  templates = Dir['views/**/*.handlebars.html']
  last_modified templates.map {|f| File.mtime f }.max

  content_type 'application/javascript'

  templates.map do |file|
    name = File.basename file, '.handlebars.html'
    name.sub!(/^[a-z]/) { $&.upcase }
    name << 'Template' unless name.end_with? 'Template'
    source = File.read file
    "GB.#{name} = '#{escape_javascript source}'"
  end.join("\n\n")
end

# API
namespace '/api/repos' do
  error Octokit::Unauthorized do
    status 401
    'Unauthorized'
  end

  error [ Octokit::BadRequest,
          Octokit::Forbidden,
          Octokit::NotFound,
          Octokit::NotAcceptable,
          Octokit::UnprocessableEntity,
          Octokit::InternalServerError,
          Octokit::NotImplemented,
          Octokit::BadGateway,
          Octokit::ServiceUnavailable ] do
   status 500
   'OctoError'
  end

  get do
    page = params.fetch('page', 1).to_i
    json status_board.events_by_repo(page)
  end

  get '/:owner/:repo/events' do |owner, repo|
    page = params.fetch('page', 1).to_i
    events = status_board.events_for_repo owner, repo, page
    json events
  end

  get '/:owner/:repo/commits/:sha' do |owner, repo, sha|
    commit = status_board.commit owner, repo, sha
    commit['comments'] = status_board.commit_comments owner, repo, sha
    json commit
  end

  get '/:owner/:repo/commits/:sha/comments' do |owner, repo, sha|
    comments = status_board.commit_comments owner, repo, sha
    json comments
  end

  get '/:owner/:repo/issues/:issue/comments' do |owner, repo, issue|
    comments = status_board.issue_comments owner, repo, issue
    json comments
  end

  get '/:owner/:repo/pulls/:pull_request/comments' do |owner, repo, pull_request|
    comments = status_board.pull_request_comments owner, repo, pull_request
    json comments
  end
end
