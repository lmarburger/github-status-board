window.GB ||= {}
class GB.FeedView extends Backbone.View
  
  events: {}
    
  template: () ->
    Handlebars.compile(GB.FeedViewTemplate)()
  
  render: ->
    @$el.html @template()
    
    events = _.flatten(_.map(@model, (model) ->
      if model.events
        model.events.models
    ))
    
    # Please. "item" is a misnomer, these are events. "event" just felt wrong.
    _.each events, (item) =>
      view = new GB.EventItemView(model: item)
      view.render().$el.appendTo @$('#events')
    @