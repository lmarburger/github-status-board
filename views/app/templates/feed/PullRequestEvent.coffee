GB.PullRequestEventTemplate = "
  
  <strong>{{actor}} </strong> {{payload/action}} a pull request 
  
  <ul class='commits'>
    <li>
      {{#with payload}}
        
        {{#with pull_request}}
          ({{commits}} commits): <br />
          <strong>{{body}}</strong>
        {{/with}}
      {{/with}}
    </li>
  </ul>
"