class GB.EventItemView extends Backbone.View
  
  template: ->
    
    type = @model.get('type')
    source = GB["#{type}Template"]
    if source
      template = Handlebars.compile(source)
      template(@model.attributes)
    else
      "<span>#{type}"
  
  render: ->
    @$el.html @template()
    @
