GB.PullRequestEventTemplate = "
  
  <strong>{{actor}} </strong> {{payload/action}} a pull request ({{payload/pull_request/commits}} commits):
  
  <ul class='commits'>
    <li>
      {{#with payload}}
        {{#with pull_request}}
          <strong>{{body}}</strong>
        {{/with}}
      {{/with}}
    </li>
  </ul>
"