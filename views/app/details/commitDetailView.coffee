class GB.CommitDetailView extends Backbone.View
  
  template: ->
    window.m = @model
    Handlebars.compile(GB.CommitDetailViewTemplate)(@model.attributes)
  
  render: ->
    @$el.html @template()
    @