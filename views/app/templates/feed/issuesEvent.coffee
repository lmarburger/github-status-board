GB.IssuesEventTemplate = "
  <h3>{{repo/name}}</h3>
  <strong>{{actor/login}}</strong> {{payload/action}} an issue on {{repo/name}}
  <p>{{payload/issue/body}}</p>
  
  <time>{{ago created_at}}</time>
"
