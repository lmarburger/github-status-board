window.GB ||= {}
class GB.FeedView extends Backbone.View
  
  events: {}
    
  template: () ->
    Handlebars.compile(GB.FeedViewTemplate)()
  
  
  render: ->
    
    console.log 'render'
    
    _.each @oldModels, (model) => model.unbind('change')
    
    @oldModels = @model
    
    _.each @model, (model) => model.on('change', @render, @)
    
    @$el.html @template()
    
    events = _.flatten(_.map(@model, (model) ->
      if model.events
        model.events.models
    ))
    
    events = _.sortBy(events, (e) ->
      - (new Date(e.get('created_at')))
    )
    
    _.each events, (thisEvent) =>
      new GB.EventItemView(model: thisEvent).render().$el.appendTo @$('#events')
    @