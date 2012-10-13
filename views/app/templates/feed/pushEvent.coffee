GB.PushEventTemplate = "
  <strong>{{actor}}</strong> pushed {{payload/size}} commmits to {{repo/name}}:<br />
  <ul class='commits'>
    {{#each payload/commits}}
      <li>{{sha}} - {{message}}</li>
    {{/each}}
  </ul>
"