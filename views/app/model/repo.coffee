class GB.Repo extends Backbone.Model
  
  @selected = false
  
  idAttribute: 'slug'
  url: -> ['api', 'repos', @get('slug')].join('/')
  
  lastActivity: () ->
    if @events.length > 0
      new Date(_.sortBy(@events.models, (e) -> - (new Date(e.get('created_at'))))[0].get('created_at'))
    else
      null
  
  initialize: () ->
    @events = new GB.EventsCollection(this.get('events'))
    @events.repo = @
    @on('change:selected', @fetchEventsIfSelected, @)
    
  fetchEventsIfSelected: () ->
    if @get('selected')
      @events.fetch()
    
  toggleSelected: () ->
    @set('selected', !@get('selected'))
  
class GB.Repos extends Backbone.Collection  
  model: GB.Repo
  url: "/api/repos"
  
  comparator: (repo) ->
    - repo.lastActivity()
    
  fetchEventsIfSelected: (callback) ->
    console.log 'fetchEventsIfSelected'
    _.each @where(selected: true), (repo) ->
      repo.events.fetchMore () =>
        callback?()
    
  currentPage: 0
  fetchMore: (callback) ->
    @currentPage += 1
    @fetch({
      data: {page: @currentPage}
      processData: true
      add: true
      success: callback
    })