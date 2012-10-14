Handlebars.registerHelper 'ago', (context, options) ->
  moment(context).fromNow()
  
Handlebars.registerHelper 'truncate_sha', (sha) ->
  sha.substring(0, 6)

Handlebars.registerHelper 'truncate', (text, length) ->
  length ||= 30
  if text.length > length - 3
    "#{text.substring(0, length)}..."
  else
    text

Handlebars.registerHelper 'branch_name', ->
  branch = @payload.ref.replace 'refs/heads/', ''
  url = "https://github.com/#{@repo.name}/tree/#{branch}"
  "<a class='branch' href='#{url}' target='_blank'>#{branch}</a>"

Handlebars.registerHelper 'issue_label', ->
  label = "##{@payload.issue.number}"
  url = @payload.issue.html_url
  "<a class='branch' href='#{url}' target='_blank'>#{label}</a>"

Handlebars.registerHelper 'pull_request_label', ->
  label = "##{@payload.number}"
  url = @payload.pull_request.html_url
  "<a class='branch' href='#{url}' target='_blank'>#{label}</a>"

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

Handlebars.registerHelper 'markless', (text, limit) ->
  text = text.substring(0, limit) if limit and text.length > limit
  tmp = document.createElement("DIV")
  tmp.innerHTML = marked(text)
  tmp.textContent||tmp.innerText
