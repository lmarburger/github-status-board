class GB.FeedHeaderView extends Backbone.View
  model: GB.Event
  
  render: () ->
    @$el.html @template()
    @
    
  template: () ->
    Handlebars.compile(GB.FeedHeaderTemplate)(@model.attributes)