window.GB ||= {}
class GB.FeedView extends Backbone.View
  
  events: 
    # 
    
  render: ->
    @$el.html @template()
    
    # Please. "item" is a misnomer, these are events. "event" just felt wrong.
    _.each @collection, (item) =>
      
      switch feedEvent.get('type')
        when "IssueCommentEvent"
          view = new GB.IssueCommentEventView(model: item)
        when "PushEvent"
          view = new GB.PushEventView(model: item)
      
      
    @