class GB.Event extends Backbone.Model

class GB.EventsCollection extends Backbone.Collection
  model: GB.Event
  url: -> 
    ['api', 'repos', @repo.get('slug'), 'events'].join('/')  
