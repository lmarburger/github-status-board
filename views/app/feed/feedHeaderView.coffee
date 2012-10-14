class GB.FeedHeaderView extends Backbone.View
  
  tagName: "h3"
  
  model: GB.Event
  
  render: () ->
    @$el.html @template()
    @
    
  template: () ->
    Handlebars.compile(GB.FeedHeaderTemplate)(@model.attributes)