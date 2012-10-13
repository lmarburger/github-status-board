Handlebars.registerHelper 'ago', (context, options) ->
  moment(context).fromNow()