GB.CommitCommentEventTemplate = "
  <h3><b>{{repo/name}}</b></h3>
  <p><strong>{{actor/login}}</strong> commented on commit <strong><a href='#none' class='sha' data-sha='{{payload/comment/commit_id}}' data-repo-slug='{{repo/name}}'>{{payload/comment/commit_id}}</a></strong></p>
  <p class='comment'>{{payload/comment/body}}</p>
  <time>{{ago created_at}}</time>
"