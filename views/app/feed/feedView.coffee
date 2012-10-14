window.GB ||= {}
class GB.FeedView extends Backbone.View
  
  template: () ->
    Handlebars.compile(GB.FeedViewTemplate)()
  
  render: ->
    
    $('#events').empty()
    
    _.each @oldModels, (model) => model.events.unbind('change reset')
    @oldModels = @model
    _.each @model, (model) => model.events.on('change reset', @render, @)
    
    @$el.html @template()
    
    events = _.flatten(_.map(@model, (model) -> model?.events?.models))
    
    events = _.sortBy events, (e) -> - (new Date(e.get('created_at')))
    
    previousEventRepoId = null
    _.each events, (thisEvent) =>
      if previousEventRepoId != thisEvent.get('repo').id
        header = new GB.FeedHeaderView(model: new GB.Repo(thisEvent.get('repo')))
        header.render().$el.appendTo @$('#events')
      new GB.EventItemView(model: thisEvent).render().$el.appendTo @$('#events')
      previousEventRepoId = thisEvent.get('repo').id
    
    @$('.loading').remove() if @model.length > 0
    
    @