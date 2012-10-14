class GB.Repo extends Backbone.Model
  @selected = false
  url: -> ['api', 'repos', @get('slug')].join('/')
  
  lastActivity: () ->
    if @events.length > 0
      new Date(_.sortBy(@events.models, (e) -> - (new Date(e.get('created_at'))))[0].get('created_at'))
    else
      null
  
  initialize: () ->
    @events = new GB.EventsCollection(this.get('events'))
    @events.repo = @
    @events.on('change reset', @eventsUpdated, @)
    
  eventsUpdated: () ->
    @trigger('change')
  
  toggleSelected: () ->
    @set('selected', !@get('selected'))
    

  
class GB.Repos extends Backbone.Collection  
  model: GB.Repo
  url: "/api/repos"
  
  comparator: (repo) ->
    - repo.lastActivity()
    
  currentPage: 0
  fetchMore: () ->
    @currentPage += 1
    @fetch({
      data: {page: @currentPage}
      procesData: true
    })