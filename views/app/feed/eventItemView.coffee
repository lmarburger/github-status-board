class GB.EventItemView extends Backbone.View
  
  tagName: "event"
  
  template: ->
    console.log @model if @model.get('type') == "PullRequestEvent"
    type = @model.get('type')
    source = GB["#{type}Template"]
    if source
      template = Handlebars.compile(source)
      template(@model.attributes)
    else
      "<span>#{type}"
  
  render: ->
    @$el.html @template()
    @$el.addClass @model.get('type')
    @
