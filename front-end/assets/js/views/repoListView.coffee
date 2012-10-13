class GB.RepoListView extends Backbone.View
  
  render: () ->
    @$el.data('repo-id', @model.get('id'))