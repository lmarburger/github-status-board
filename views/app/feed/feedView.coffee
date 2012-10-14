window.GB ||= {}
class GB.FeedView extends Backbone.View
  
  className: "events"
    
  events: {
    'click a.more': 'fetchMore'
  }
  
  template: () ->
    Handlebars.compile(GB.FeedViewTemplate)()
  
  initialize: () ->
    GB.FeedView.__super__.initialize.apply(this, arguments)
  
  fetchMore: () ->
    @$('.more').css('opacity', 0.4)
    App.repos.fetchEventsIfSelected () =>
      @reRender()
      @$('#events').scrollTop(1000)
    
  reRender: ->  
  
  addOne: (thisEvent) ->
    
    if @previousEventRepoId != thisEvent.get('repo').id
      header = new GB.FeedHeaderView(model: new GB.Repo(thisEvent.get('repo')))
      header.render().$el.appendTo @$('#events')
    new GB.EventItemView(model: thisEvent).render().$el.appendTo @$('#events')
    @previousEventRepoId = thisEvent.get('repo').id
    @$('.more').css('opacity', 1.0).remove().appendTo(@$('#events'))
  
  render: ->
    
    $('#events').empty()
    
    _.each @oldModels, (model) => model.events.unbind('change add reset')
    
    @oldModels = @model
    _.each @model, (model) => 
      model.events.on('change reset', @render, @)
      model.events.on('add', @addOne, @)
    
    @$el.html @template()
    
    events = _.flatten(_.map(@model, (model) -> model?.events?.models))
    
    events = _.sortBy events, (e) -> - (new Date(e.get('created_at')))
    
    @previousEventRepoId = null
    _.each events, (thisEvent) =>
      @addOne(thisEvent)
    
    @$('#events').append $('<a href="#none" class="more">more</a>')
    
    @$('.loading').remove() if @model.length > 0
    
    @