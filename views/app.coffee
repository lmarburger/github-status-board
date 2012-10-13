window.GB ||= {}

class GB.Repo extends Backbone.Model
  @selected = false
  toggleSelected: () ->
    @set('selected', !@get('selected'))
  
class GB.Repos extends Backbone.Collection  
  model: GB.Repo
  url: "/api/repos"


class GB.Commit extends Backbone.Model
  url: -> ["api", "commits", @get('sha')].join('/')

class GB.Event extends Backbone.Model
  
class GB.User extends Backbone.Model


class GB.PullRequest extends Backbone.Model

class GB.PullRequests extends Backbone.Collection
  model: GB.PullRequest