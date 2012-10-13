# encoding: utf-8
require 'sinatra'
require 'sinatra/config_file'
require 'sinatra_boilerplate'

require 'octokit'

config_file 'config.yml'

enable :show_exceptions

set :js_assets, %w[zepto.js underscore.js app.coffee]

configure :development do
  set :logging, false
end

get "/" do
  client = Octokit::Client.new login:    settings.github_credentials[:login],
                               password: settings.github_credentials[:password]
  repos = client.organizations.map do |organization|
    client.organization_repositories(organization.login, type: 'private').
      map(&:name)
  end.flatten

  erb :index, locals: { repos: repos }
end
