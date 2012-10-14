class GB.Commit extends Backbone.Model
  
  url: () ->
    ['api', 'repos', @get('repo').get('slug'), 'commits', @get('sha')].join('/')
    
  initialize: () ->
    window.commit = @
    console.log @
  
  