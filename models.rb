require 'forwardable'
require 'oauth2'
require 'faraday_middleware'
require 'octokit'
require 'active_support/cache'

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
    response['cache-control'].sub!('private, ', '') if response['cache-control']
    response
  end
end

# removes nil request headers created by bug
# https://github.com/pengwynn/faraday_middleware/pull/35
NilHeaderExterminator = Struct.new :app do
  def call env
    env[:request_headers].reject! { |name, value| value.nil? }
    app.call env
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

  # [{ slug: 'railsrumble/r12-team-184', events: [{...}] },
  #  { slug: 'troy/txlogic', events: [{...}] }]
  def events_by_repo page = 1
    events = events_for_authenticated_user(page).
      each_with_object(Hash.new([])) {|event, grouped|
        grouped[event.repo.name] += [event]
      }.map {|slug, events|
        { slug: slug, events: events }
      }
  end

  # user.login is ripe for storing in a cookie
  def events_for_authenticated_user page
    events = api_client.received_events(api_client.user.login, page: page)
    filter_events events
  end

  def commit owner, repo, sha
    api_client.commit({ owner: owner, repo: repo }, sha)
  end

  def commit_comments owner, repo, sha
    api_client.commit_comments({ owner: owner, repo: repo }, sha)
  end

  def issue_comments owner, repo, issue
    api_client.issue_comments({ owner: owner, repo: repo }, issue)
  end

  def pull_request_comments owner, repo, pull_request
    api_client.pull_request_comments({ owner: owner, repo: repo }, pull_request)
  end

  def repos
    api_client.repos(nil, sort: 'pushed')
  end

  SUPPORTED_EVENTS = %w[
    PushEvent IssuesEvent PullRequestEvent CommitCommentEvent IssueCommentEvent
    PullRequestReviewCommentEvent
  ]

  def filter_events events
    events.select { |event|
      SUPPORTED_EVENTS.include? event.type
    }
  end

  def api_client options = {}
    options = options.merge oauth_token: auth_token,
      # proxy: 'http://localhost:8888',
      faraday_config_block: lambda { |conn|
        conn.response :caching do
          # <3 Elliott
          ActiveSupport::Cache::FileStore.new "#{cache_prefix}dumb", expires_in: 60 * 30
        end
        conn.use FaradayMiddleware::RackCompatible, Rack::Cache::Context,
          :metastore      => "file:#{cache_prefix}meta",
          :entitystore    => "file:#{cache_prefix}body",
          :ignore_headers => %w[Set-Cookie X-Content-Digest]
        conn.use PrivateCacheBuster
        conn.use NilHeaderExterminator
      }
    Octokit::Client.new options
  end
end
