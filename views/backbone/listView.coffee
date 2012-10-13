window.GB ||= {}
class GB.ListView extends Backbone.View
  
  selectedRepoSlugs: []
  
  events: 
    'click li a': 'didClickRepo'
    
  didClickRepo: (e) ->
    element = $(e.target).closest('li')
    slug = element.data('repo-slug')
    repo = @collection.where(slug: slug)[0]
    repo.toggleSelected()
    
  repos: () ->
    @collection.where(id: selectedRepoSlugs)
    
  template: () ->
    GB.ListViewTemplate
  
  render: ->
    @$el.html @template()
    
    @collection.each (repo) =>
      view = new GB.RepoListView(model : repo)
      view.render().$el.appendTo @$("ul")
      
    @