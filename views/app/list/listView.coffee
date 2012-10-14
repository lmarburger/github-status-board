Array::remove = (e) -> @[t..t] = [] if (t = @indexOf(e)) > -1

window.GB ||= {}

class GB.ListView extends Backbone.View
  
  selectedRepoSlugs: []
  
  initialize: () ->
    GB.ListView.__super__.initialize.apply(this, arguments)
    
  deSelectAll: () ->
    @selectedRepoSlugs = []
    @collection.each (model) -> model.set('selected', false)
    @trigger('change:selection', [])
    
  selectAllWithCommits: () ->
    reposWithCommits = @collection.filter (repo) => repo.events.length > 0
    _.each reposWithCommits, (repo) -> repo.set('selected', true)
    window.r = reposWithCommits
    @selectedRepoSlugs = _.map reposWithCommits, (object) -> object.get('slug')
    @trigger('change:selection', @selectedRepos())
    
  selectAll: () ->
    @selectedRepoSlugs = @collection.pluck('slug')
    @collection.each (model) -> model.set('selected', true)
    @trigger('change:selection', @selectedRepos())
  
  events: 
    'tap li a': 'didClickRepo'
    'mousedown li a': 'didClickRepo'
    
  didClickRepo: (e) ->
    
    element = $(e.target).closest('li')
    slug = element.data('repo-slug')
    repo = @collection.where(slug: slug)[0]

    repo.toggleSelected()
    
    if repo.get('selected')
      @selectedRepoSlugs.push(repo.get('slug'))
    else
      @selectedRepoSlugs.remove(repo.get('slug'))
    
    _.defer () =>
      @trigger('change:selection', @selectedRepos())
    
    e.stopPropagation()
    e.preventDefault()
    
  selectedRepos: () ->
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