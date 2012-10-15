require 'forwardable'
require 'oauth2'
require 'faraday_middleware'
require 'octokit'
require 'time'

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

  def authenticated_user
    @authenticated_user ||= api_client.user.login
  end

  def events_for_repo owner, repo, page
    events = api_client.repository_events({ owner: owner,
                                            repo:  repo }, page: page)
    filter_events events
  end

  # [{ slug: 'railsrumble/r12-team-184', private: true, events: [{...}] },
  #  { slug: 'troy/txlogic', private: false, events: [{...}] }]
  def events_by_repo page = 1
    # ensure all repos are in the payload
    index = repos.each_with_object({}) { |repo, index|
      index[repo.full_name] = { slug:    repo.full_name,
                                private: repo.private,
                                events:  [] }
    }

    events_for_authenticated_user(page).each do |event|
      unless index[event.repo.name]
        index[event.repo.name] = { slug:    event.repo.name,
                                   private: true, # <- WRONG! :(
                                   events:  [] }
      end
      index[event.repo.name][:events] << event
    end

    index.map { |_, data| data }
  end

  # user.login is ripe for storing in a cookie
  def events_for_authenticated_user page
    events = api_client.received_events(authenticated_user, page: page)
    filter_events events
  end

  def commit owner, repo, sha
    api_client.commit({ owner: owner, repo: repo }, sha)
  end

  # [ repo, base, branch ]
  def_delegators :api_client, :compare

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
    (user_repos + organizations_repos).
      sort_by {|repo| repo.pushed_at.to_s }.
      reverse
  end

  def user_repos
    api_client.repos(nil, sort: 'pushed')
  end

  def organizations_repos
    api_client.organizations.map { |organization|
      api_client.organization_repositories(organization.login, type: 'member')
    }.flatten
  end

  SUPPORTED_EVENTS = %w[
    PushEvent IssuesEvent PullRequestEvent CommitCommentEvent IssueCommentEvent
    PullRequestReviewCommentEvent
  ]

  def filter_events events
    events.select { |event|
      next if own_event? event
      if create_branch_event? event
        convert_branch_event_to_push event
      end
      SUPPORTED_EVENTS.include? event.type
    }
  end

  def own_event? event
    event.actor.login == authenticated_user
  end

  def create_branch_event? event
    event.type == 'CreateEvent' and event.payload['ref_type'] == 'branch'
  end

  def convert_branch_event_to_push event
    branch = event.payload['ref']
    begin
      comparison = compare event.repo['name'], event.payload['master_branch'], branch
    rescue
      # ignore
    else
      event.type = 'PushEvent'
      created = Time.parse event.created_at
      commits = comparison.commits.map {|c|
        if Time.parse(c['commit']['committer']['date']) < created
          push_commit_from_commit(c)
        end
      }.compact.reverse

      head = commits.any? && commits.first[:sha]

      event.payload = {
        ref: "refs/heads/#{branch}",
        before: "0" * 40,
        head: head,
        commits: commits,
        size: commits.size,
        push_id: 0
      }
    end
  end

  def push_commit_from_commit commit
    { sha: commit['sha'],
      url: commit['url'],
      message: commit['commit']['message'],
      distinct: false,
      author: commit['commit']['author']
    }
  end

  def api_client options = {}
    options = options.merge oauth_token: auth_token,
      # proxy: 'http://localhost:8888',
      faraday_config_block: lambda { |conn|
        # conn.response :caching do
        #   ActiveSupport::Cache::FileStore.new "#{cache_prefix}dumb", expires_in: 60 * 30
        # end
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
