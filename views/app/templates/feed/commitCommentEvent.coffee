GB.CommitCommentEventTemplate = "
  <h3>{{repo/name}}</h3>
  <strong>{{actor/login}}</strong> 
  commented on commit 
  <strong>{{payload/comment/commit_id}}</strong>:
  <p>{{payload/comment/body}}</p>
  <time>{{ago created_at}}</time>
"