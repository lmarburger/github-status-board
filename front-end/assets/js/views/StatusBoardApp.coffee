window.GB ||= {}

class GB.StatusBoardApp extends Backbone.View
  constructor: () ->
    @user = new GB.User()
    @repos = new GB.Repos()
    @pullRequests = new GB.PullRequests()
    @listView = new GB.ListView()
  
  loadAll: (callback) ->
    @repos.fetch()
    callback() if callback?
    
$ -> 
  window.App = new GB.StatusBoardApp()
  
  window.App.loadAll () ->
    
    # Dummy stuff until we have an API.
  
    window.App.repos.reset [
      {name: "Elliott's Repo", slug: "elliotts-repo"},
      {name: "Hector's Repo", slug: "elliotts-repo", commits: [
        {sha: "12345", message: "abc"},
        {sha: "2345", message: "abc"},
        {sha: "3456", message: "abc"},
        {sha: "4567", message: "abc"},
        {sha: "5678", message: "abc"}
      ]}
    ]
  
    window.App.user.set({
      name: "Elliott Kember",
      email: "elliott.kember@gmail.com",
      avatar_url: "https://twimg0-a.akamaihd.net/profile_images/1042496336/bath_bigger.jpg"
    })