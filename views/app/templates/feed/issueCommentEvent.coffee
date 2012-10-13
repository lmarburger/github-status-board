GB.IssueCommentEventTemplate = "
  <h3>{{repo/name}}</h3>
  <strong>{{actor}}</strong> commented on Issue \#{{payload/issue/id}} 

  <strong>{{payload/issue/body}}</strong>:
  <p>{{payload/comment/body}}</p>
  
  <time>{{ago created_at}}</time>
"