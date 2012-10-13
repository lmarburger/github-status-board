class CommitDetailView extends Backbone.View
  
  template: ->
    Handlebars.compile(GB.CommitDetailViewTemplate)(@model.attributes)
  
  render: ->
    @$el.html @template()