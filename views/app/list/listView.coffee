Array::remove = (e) -> @[t..t] = [] if (t = @indexOf(e)) > -1

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
    
    if repo.get('selected')
      @selectedRepoSlugs.push(repo.get('slug'))
    else
      @selectedRepoSlugs.remove(repo.get('slug'))
    
    @trigger('change:selection', @repos())
    
  repos: () ->
    _.filter @collection.models, (repo) => 
      @selectedRepoSlugs.indexOf(repo.get('slug')) > -1
    
  template: () ->
    GB.ListViewTemplate
  
  render: ->
    @$el.html @template()
    
    @collection.each (repo) =>
      view = new GB.RepoListView(model : repo)
      view.render().$el.appendTo @$("ul")
      
    @