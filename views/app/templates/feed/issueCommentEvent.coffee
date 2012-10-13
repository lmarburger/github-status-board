GB.IssueCommentEventTemplate = "
  <h3>{{repo/name}}</h3>
  <strong>{{actor/login}}</strong> commented on Issue \#{{payload/issue/id}} 

  <p>{{truncate payload/issue/body 150}}</p>
  <p>{{truncate payload/comment/body 150}}</p>
  
  <time>{{ago created_at}}</time>
"
