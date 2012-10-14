class GB.Event extends Backbone.Model

class GB.EventsCollection extends Backbone.Collection
  model: GB.Event
  url: -> 
    ['api', 'repos', @repo.get('slug'), 'events'].join('/')  
  currentPage: 0
  fetchMore: () ->
    @currentPage += 1
    @fetch({
      data: {page: @currentPage}
      processData: true
      add: true
    })