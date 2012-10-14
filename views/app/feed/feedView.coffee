window.GB ||= {}
class GB.FeedView extends Backbone.View
  
  events: 
    'click .sha': 'showCommit'
  
  showCommit: (e) ->
    element = $(e.target).closest('a.sha')
    sha = element.data('sha')
    repoSlug = element.data('repo-slug')
    
    repo = App.repos.where('slug': element.data('repo-slug'))[0]
    
    repo.events.each (event) ->
      _.each event.get('payload').commits, (commit) ->
        if commit.sha == sha
          commit = new GB.Commit(commit)
          App.showCommit(repo, commit)
    
  template: () ->
    Handlebars.compile(GB.FeedViewTemplate)()
  
  render: ->
        
    _.each @oldModels, (model) => model.events.unbind('change reset')
    
    @oldModels = @model
    
    _.each @model, (model) => model.events.on('change reset', @render, @)
    
    @$el.html @template()
    
    events = _.flatten(_.map(@model, (model) ->
      if model.events
        model.events.models
    ))
    
    events = _.sortBy(events, (e) ->
      - (new Date(e.get('created_at')))
    )
    
    _.each events, (thisEvent) =>
      new GB.EventItemView(model: thisEvent).render().$el.appendTo @$('#events')
    @