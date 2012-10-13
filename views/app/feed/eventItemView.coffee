class GB.EventItemView extends Backbone.View
  
  template: ->
    
    if @model.get('type') && eval("GB.#{@model.get('type')}Template")
      template = Handlebars.compile(eval("GB.#{@model.get('type')}Template"))
      template(@model.attributes)
    else
      "<span>#{@model.get('type')}"
  
  render: ->
    @$el.html @template()
    @