class GB.EventItemView extends Backbone.View
  
  template: ->
    Mustache.to_html eval("GB.#{@model.get('type')}Template"), @model.attributes
  
  render: ->
    