GB.CreateEventTemplate = "
  <h3>{{repo/name}}</h3>
  <strong>{{actor}}</strong> created <strong>{{payload/master_branch}}</strong> {{payload/ref_type}}
  <time>{{ago created_at}}</time>
"