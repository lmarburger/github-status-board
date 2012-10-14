class GB.CommitDetailView extends Backbone.View
  
  template: ->
    Handlebars.compile(GB.CommitDetailViewTemplate)(@model.attributes)
  
  initialize: ->
    GB.CommitDetailView.__super__.initialize.apply(this, arguments);
    @model.bind('change', @render, @)
    @model.fetch()
  
  render: ->
    @$el.html @template()
    @
    
  