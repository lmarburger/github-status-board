window.GB ||= {}

class GB.StatusBoardApp extends Backbone.View
    
  initialize: ->
    
    @setElement $('app')
    
    @user = new GB.User()
    @repos = new GB.Repos()
    @feedEvents = new GB.EventsCollection()
    
    @listView = new GB.ListView(collection: @repos)
    @feedView = new GB.FeedView(model: @listView.selectedRepos())
    
    @$('#feed').html @feedView.render().$el
    
    @feedContainer = @$('#feed')
    @detailContainer = @$('#detail')
    
    @listView.on('change:selection', @renderMainView, @)
    @repos.on('reset add', @renderListView, @)
    
    @renderListView()
    @hideDetails()
  
  events: 
    'click .sha': 'showCommit'
    'click #back': 'hideDetails'
    'click #toggle-all': 'toggleAll'
  
  renderMainView: () ->
    @feedView.model = @listView.selectedRepos()
    @feedView.render()
  
  renderListView: () ->
    @$('#list').html @listView.render().$el
  
  toggleAll: () ->
    $('#toggle-all').toggleClass('selected')
        
    if $('#toggle-all').hasClass('selected')
      @listView.selectAll()
    else
      @listView.deSelectAll()
  
  seedRepos: (data) ->
    @repos.reset data
    @listView.selectAllWithCommits()

  showCommit: (e) ->
    
    element = $(e.target).closest('a.sha')
    sha = element.data('sha')
    repoSlug = element.data('repo-slug')
    repo = App.repos.where('slug': element.data('repo-slug'))[0]

    commit = new GB.Commit({sha: sha})
    commit.set('repo', repo)
    commitView = new GB.CommitDetailView(model: commit)
    @detailContainer.html commitView.render().$el
    
    @showDetails()
    
  showDetails: () ->
    # @feedContainer.hide()
    # @detailContainer.show()
    @feedContainer.css({left: "-100%"})
    @detailContainer.css({left: "0%"})
    
  hideDetails: () ->
    @feedContainer.css({left: "0%"})
    @detailContainer.css({left: "100%"})

  showRepos: () ->
    ids = @listView.selectedCommitIds()
    
$ -> 
  window.App = new GB.StatusBoardApp()
  window.App.seedRepos window.repoSeedData
    
  # Dummy stuff until we have an API.
  window.App.user.set({
    name: "Elliott Kember",
    email: "elliott.kember@gmail.com",
    avatar_url: "https://twimg0-a.akamaihd.net/profile_images/1042496336/bath_bigger.jpg"
  })
