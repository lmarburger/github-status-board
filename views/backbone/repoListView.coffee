class GB.RepoListView extends Backbone.View
  
  initialize: () ->
    @model.on('change:selected', @renderSelection, @)
  
  tagName: "li"
  
  render: () ->
    @$el.html Mustache.to_html(GB.RepoListViewTemplate, @model.attributes)
    @$el.data("repo-slug", @model.get('slug'))
    if @model.get('selected')
      @$el.addClass('selected')
    @
    
  renderSelection: () ->
    if @model.get('selected')
      @$el.addClass('selected')
    else
      @$el.removeClass('selected')