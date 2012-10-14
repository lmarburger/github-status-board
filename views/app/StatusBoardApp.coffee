window.GB ||= {}

class GB.StatusBoardApp extends Backbone.View
    
  initialize: ->
    
    @setElement $('app')
    
    @user = new GB.User()
    @repos = new GB.Repos()
    
    @listView = new GB.ListView(collection: @repos)
    @feedView = new GB.FeedView(model: @listView.repos())
    
    @$('#detail').html @feedView.render().$el
    
    @detailContainer = @$('#detail')
    
    @listView.on('change:selection', @renderMainView, @)
    @repos.on('reset change', @renderListView, @)
  
  renderMainView: () ->
    @feedView.model = @listView.repos()
    @feedView.render()
  
  renderListView: () ->
    @$('#list').html @listView.render().$el
  
  loadAll: (callback) ->
    @repos.fetch success: () =>
      @listView.selectAll()
    callback() if callback?
    
  showCommit: (commit) ->
    commitView = GB.CommitView(model: commit)
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