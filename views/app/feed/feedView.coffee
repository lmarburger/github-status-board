window.GB ||= {}
class GB.FeedView extends Backbone.View
  
  events: 
    # 
    
  render: ->
    @$el.html @template()
    
    # Please. "item" is a misnomer, these are events. "event" just felt wrong.
    _.each @collection, (item) =>
      view = new GB.EventItemView(model: item)
      view.render().$el.appendTo @$el
      
    @