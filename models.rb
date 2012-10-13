require 'forwardable'
require 'oauth2'
require 'faraday_middleware'
require 'octokit'

# handles OAuth process
AuthProcess = Struct.new :settings do
  extend Forwardable

  def get_token code
    token = auth_code.get_token code
    token.token
  end

  def_delegators :auth_code, :authorize_url
  def_delegators :oauth_client, :auth_code

  def oauth_client
    OAuth2::Client.new settings.github_application[:client_id],
      settings.github_application[:secret],
      site:          'https://github.com/login',
      authorize_url: 'oauth/authorize?scope=repo',
      token_url:     'oauth/access_token'
  end
end

# removes "private" bit from Cache-Control headers
PrivateCacheBuster = Struct.new :app do
  def call env
    response = app.call env
    response['cache-control'].sub!('private, ', '')
    response
  end
end

StatusBoard = Struct.new :auth_token do
  class << self
    attr_accessor :cache_prefix
  end

  extend Forwardable
  def_delegators :'self.class', :cache_prefix

      # { created_at: event.created_at,
      #   type: event.type,
      #   actor: event.actor.login,
      #   repo: {
      #     name: event.repo.name,
      #     url:  event.repo.url
      #   },
      #   payload:  payload
      # }
  def events_for_repo owner, repo
    events = api_client.repository_events(owner: owner, repo: repo)
    filter_events events
  end

  def events_for_authenticated_user
    events = api_client.user_events(api_client.user.login)
    filter_events events
  end

  def events_by_repo
    events = events_for_authenticated_user.
      each_with_object(Hash.new {|key, value| key[value] = []}) {|event, grouped|
        grouped[event.repo.name] << event
      }
  end

  def repos
    api_client.repos(nil, sort: 'pushed')
  end

  SUPPORTED_EVENTS = %w[
    CreateEvent DeleteEvent PushEvent IssuesEvent PullRequestEvent
    CommitCommentEvent IssueCommentEvent PullRequestReviewCommentEvent
  ]

  def filter_events events
    events.select { |event|
      SUPPORTED_EVENTS.include? event.type
    }
  end

  def api_client
    Octokit::Client.new oauth_token: auth_token,
      # proxy: 'http://localhost:8888',
      faraday_config_block: lambda { |conn|
        conn.use FaradayMiddleware::RackCompatible, Rack::Cache::Context,
          :metastore   => "file:#{cache_prefix}meta",
        :entitystore => "file:#{cache_prefix}body",
        :ignore_headers => %w[Set-Cookie X-Content-Digest]
        conn.use PrivateCacheBuster
      }
  end
end
