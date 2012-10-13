GB.DeleteEventTemplate = "
  <h3>{{repo/name}}</h3>
  {{actor/login}} deleted {{payload/ref_type}} <strong>{{payload/ref}}</strong>
  <time>{{ago created_at}}</time>
"