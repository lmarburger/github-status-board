class GB.Router extends Backbone.router
  
  routes: {
    "": "home"
    "repo/:owner/:name": "repo"
    "repo/:owner/:name/commits/:sha": "commit"
    "repo/:owner/:name/issues": "issues"
    "repo/:owner/:name/issues/:sha": "issue"
  }
  
  home: () ->
    
  commit: () ->
    
  issue: () ->
    
  issues: () ->
    