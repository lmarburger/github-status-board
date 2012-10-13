# encoding: utf-8
require 'sinatra'
require 'sinatra/config_file'
require 'sinatra/cookies'
require 'sinatra/namespace'

require 'json'
require 'oauth2'
require 'octokit'


config_file 'config.yml'

enable :show_exceptions

set(:js_assets) { Dir['**/*.{js,coffee}'].sort }

use Rack::Static, :urls => %w[/favicon.ico /apple-touch-icon], :root => 'public'

set(:cache_folder) { "#{settings.root}/tmp/cache" }

configure :production do
  require 'rack/cache'
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
namespace '/api/repos' do
  get do
    json repos.map {|repo|
      { name: repo.name, slug: repo.full_name }
    }
  end

  get '/:owner/:repo/events' do |owner, repo|
    events = octo_client.repository_events(owner: owner, repo: repo).map {|event|

      # http://developer.github.com/v3/events/types
      payload = case event.type

                # ref_type, ref, master_branch, description
                when 'CreateEvent'
                  event.payload
                # ref_type, ref
                when 'DeleteEvent'
                  event.payload

                # head, ref, size, commits (sha, message,
                #                           author (name, email),
                #                           url)
                when 'PushEvent'
                  event.payload

                # action (open, closed, reopened),
                # issue (http://developer.github.com/v3/issues),
                when 'IssuesEvent'
                  event.payload
                # number, pull_request (http://developer.github.com/v3/pulls)
                when 'PullRequestEvent'
                  event.payload

                # comment (http://developer.github.com/v3/issues/comments)
                when 'CommitCommentEvent'
                  event.payload
                # action (created),
                # issue (http://developer.github.com/v3/issues),
                # comment (http://developer.github.com/v3/issues/comments)
                when 'IssueCommentEvent'
                  event.payload
                # comment (http://developer.github.com/v3/issues/comments)
                # raise 'PullRequestReviewCommentEvent'
                when 'PullRequestReviewCommentEvent'
                  event.payload

                # TODO: when 'MemberEvent'
                end

      next unless payload

      { created_at: event.created_at,
        type: event.type,
        actor: event.actor.login,
        repo: {
          name: event.repo.name,
          url:  event.repo.url
        },
        payload:  payload
      }
    }.compact

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


private

def oauth_client
  OAuth2::Client.new settings.github_application[:client_id],
                     settings.github_application[:secret],
                     site:          'https://github.com/login',
                     authorize_url: 'oauth/authorize?scope=repo',
                     token_url:     'oauth/access_token'
end

def octo_client
  Octokit::Client.new oauth_token: cookies[:token]
end

def repos
  octo_client.repos(nil, sort: 'pushed')
rescue Octokit::Unauthorized
  redirect '/'
end
