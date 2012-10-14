GB.CommitCommentEventTemplate = "
  <h3>{{repo/name}}</h3>
  <strong>{{actor/login}}</strong> 
  commented on commit 
  <strong>
    <a href='#none' class='sha' data-sha='{{payload/comment/commit_id}}' data-repo-slug='{{repo/name}}'>{{payload/comment/commit_id}}</a>
  </strong>:
  <p>{{payload/comment/body}}</p>
  <time>{{ago created_at}}</time>
"