GB.IssueCommentEventTemplate = "
  <h3>{{repo/name}}</h3>
  <strong>{{actor}}</strong> commented on <strong>Issue \#{{payload/issue/id}} - {{payload/issue/body}}</strong>:
  {{payload/comment/body}}
"