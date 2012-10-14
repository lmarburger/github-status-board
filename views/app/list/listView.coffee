Array::remove = (e) -> @[t..t] = [] if (t = @indexOf(e)) > -1

window.GB ||= {}

class GB.ListView extends Backbone.View
  
  selectedRepoSlugs: []
  
  initialize: () ->
    GB.ListView.__super__.initialize.apply(this, arguments)
    
  selectAll: () ->
    @selectedRepoSlugs = @collection.pluck('slug')
    @collection.each (model) -> model.set('selected', true)
    @trigger('change:selection', @repos())
  
  events: 
    'tap li a': 'didClickRepo'
    'mousedown li a': 'didClickRepo'
    
  didClickRepo: (e) ->
    
    element = $(e.target).closest('li')
    slug = element.data('repo-slug')
    repo = @collection.where(slug: slug)[0]

    console.log 'toggleSelected'
    repo.toggleSelected()
    
    if repo.get('selected')
      @selectedRepoSlugs.push(repo.get('slug'))
    else
      @selectedRepoSlugs.remove(repo.get('slug'))
    
    _.defer () =>
      @trigger('change:selection', @repos())
    
    e.stopPropagation()
    e.preventDefault()
    
  repos: () ->
    _.filter @collection.models, (repo) => 
      @selectedRepoSlugs.indexOf(repo.get('slug')) > -1
    
  template: () ->
    GB.ListViewTemplate
  
  render: ->
    @$el.html @template()
    
    $('.loading').remove() if @collection.length > 0
    
    @collection.each (repo) =>
      new GB.RepoListView(model : repo).render().$el.appendTo @$("ul")
    @