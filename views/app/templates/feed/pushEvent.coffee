GB.PushEventTemplate = "
  <h3>{{repo/name}}</h3>
  <strong>{{actor/login}}</strong> pushed {{payload/size}} commits to {{payload/ref}}:<br />
  <ul class='commits'>
    {{#each payload/commits}}
      <li>{{sha}} - {{message}}</li>
    {{/each}}
  </ul>
  <time>{{ago created_at}}</time>
"
