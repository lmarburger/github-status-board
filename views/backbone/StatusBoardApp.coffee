window.GB ||= {}

class GB.StatusBoardApp extends Backbone.View
    
  initialize: ->
    
    @setElement $('app')
    
    @user = new GB.User()
    @repos = new GB.Repos()
    @pullRequests = new GB.PullRequests()
    @listView = new GB.ListView(collection: @repos)
    
    # @listView.render().$el.appendTo $('#list')
    
    @detailContainer = @$('#detail')
    
    @repos.bind('reset', @renderListView, @)
  
  renderListView: () ->
    @$('#list').html @listView.render().$el
  
  loadAll: (callback) ->
    @repos.fetch()
    callback() if callback?
    
  showCommit: (commit) ->
    commitView = GB.CommitView(model: commit)
    @detailContainer.html commitView.render().$el
    
  showRepos: () ->
    ids = self.listView.selectedCommitIds()
    
$ -> 
  window.App = new GB.StatusBoardApp()
  
  window.App.loadAll () ->
    
    # Dummy stuff until we have an API.
  
    window.App.user.set({
      name: "Elliott Kember",
      email: "elliott.kember@gmail.com",
      avatar_url: "https://twimg0-a.akamaihd.net/profile_images/1042496336/bath_bigger.jpg"
    })