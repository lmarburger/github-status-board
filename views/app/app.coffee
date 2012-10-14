window.GB ||= {}

class GB.StatusBoardApp extends Backbone.View
    
  initialize: ->
    
    @setElement $('app')
    
    @user = new GB.User()
    @repos = new GB.Repos()
    
    @listView = new GB.ListView(collection: @repos)
    @feedView = new GB.FeedView(model: @listView.repos())
    
    @$('#feed').html @feedView.render().$el
    
    @feedContainer = @$('#feed')
    @detailContainer = @$('#detail')
    
    @listView.on('change:selection', @renderMainView, @)
    @repos.on('reset change', @renderListView, @)
  
  events: 
    'click .sha': 'showCommit'
  
  renderMainView: () ->
    @feedView.model = @listView.repos()
    @feedView.render()
  
  renderListView: () ->
    @$('#list').html @listView.render().$el
  
  loadAll: (callback) ->
    @repos.fetch success: () =>
      @listView.selectAll()
    callback?()
    
  showCommit: (e) ->
    
    element = $(e.target).closest('a.sha')
    sha = element.data('sha')
    repoSlug = element.data('repo-slug')
    repo = App.repos.where('slug': element.data('repo-slug'))[0]

    repo.events.each (event) =>
      _.each event.get('payload').commits, (commit) =>
        if commit.sha == sha
          commit = new GB.Commit(commit)
          commitView = new GB.CommitDetailView(model: commit)
          @detailContainer.html commitView.render().$el
    
  showRepos: () ->
    ids = @listView.selectedCommitIds()
    
$ -> 
  window.App = new GB.StatusBoardApp()
  
  window.App.loadAll () ->
    
    # Dummy stuff until we have an API.
  
    window.App.user.set({
      name: "Elliott Kember",
      email: "elliott.kember@gmail.com",
      avatar_url: "https://twimg0-a.akamaihd.net/profile_images/1042496336/bath_bigger.jpg"
    })