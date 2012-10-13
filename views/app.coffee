window.GB ||= {}

class GB.Commit extends Backbone.Model
  url: -> ["api", "commits", @get('sha')].join('/')
  
class GB.User extends Backbone.Model