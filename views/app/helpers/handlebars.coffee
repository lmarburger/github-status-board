Handlebars.registerHelper 'ago', (context, options) ->
  moment(context).fromNow()

Handlebars.registerHelper 'truncate', (text, length) ->
  length ||= 30
  if text.length > length - 3
    "#{text.substring(0, length)}..."
  else
    text
    
Handlebars.registerHelper 'rawPatch', (patch) ->
  patch