Handlebars.registerHelper 'ago', (context, options) ->
  moment(context).fromNow()

Handlebars.registerHelper 'truncate', (text, length) ->
  length ||= 30
  if text.length > length - 3
    "#{text.substring(0, length)}..."
  else
    text
    
Handlebars.registerHelper 'rawPatch', (patch) ->
  lines = []
  
  _.each patch.split("\n"), (line) ->
    
    first = line[0]
    
    line = _.escape(line)
    if first == '+'
      line = "<span class='plus'>#{line}</span>"
    else if first == '-'
      line = "<span class='minus'>#{line}</span>"
    else
      line ="<span>#{line}</span>"
    
    lines.push(line)
  lines.join('\n')
  
Handlebars.registerHelper 'markdown', (text) ->
  marked(text)

Handlebars.registerHelper 'markless', (text) ->
  tmp = document.createElement("DIV")
  tmp.innerHTML = marked(text)
  tmp.textContent||tmp.innerText