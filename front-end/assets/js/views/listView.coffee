window.GB ||= {}
class GB.ListView extends Backbone.View
  
  events: 
    'click .repo': 'showRepo'
    
  showRepo: (e) ->
    console.log "Showing repo."
    repo = @collection.get($(e.targetElement).data('repo-id'))
    
  render: ->
    if @collection
      @collection.each (repo) ->
        view = new GB.RepoListView(model : repo)