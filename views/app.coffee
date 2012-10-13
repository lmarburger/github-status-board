window.GB ||= {}

class GB.Event extends Backbone.Model
  

class GB.EventsCollection extends Backbone.Collection
  model: GB.Event
  url: -> ['api', 'repos', @repo.get('slug'), 'events'].join('/')

class GB.Repo extends Backbone.Model
  @selected = false
  url: -> ['api', 'repos', @get('slug')].join('/')
  
  initialize: () ->
    @events = new GB.EventsCollection()
    @events.repo = @
    @events.fetch()
  
  toggleSelected: () ->
    @set('selected', !@get('selected'))
  
class GB.Repos extends Backbone.Collection  
  model: GB.Repo
  url: "/api/repos"

class GB.Commit extends Backbone.Model
  url: -> ["api", "commits", @get('sha')].join('/')

  
class GB.User extends Backbone.Model


class GB.PullRequest extends Backbone.Model

class GB.PullRequests extends Backbone.Collection
  model: GB.PullRequest