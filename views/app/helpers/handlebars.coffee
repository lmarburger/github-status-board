Handlebars.registerHelper 'ago', (context, options) ->
  moment(context).fromNow()
  
Handlebars.registerHelper 'truncate', (context, length) ->
  length ||= 30
  console.log length
  if context.length > length - 3
    context.substring(0, length)+"..."
  else
    context