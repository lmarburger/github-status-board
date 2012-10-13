GB.PullRequestEventTemplate = "
  
  <h3>{{repo/name}}</h3>
  
  <strong>{{actor/login}} </strong> {{payload/action}} a pull request ({{payload/pull_request/commits}} commits):
  
  <ul class='commits'>
    <li>
      {{#with payload}}
        {{#with pull_request}}
          <strong>{{body}}</strong>
        {{/with}}
      {{/with}}
    </li>
  </ul>
  <time>{{ago created_at}}</time>
"
