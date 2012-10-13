GB.PushEventTemplate = "
  <h3>{{repo/name}}</h3>
  <strong>{{actor}}</strong> pushed {{payload/size}} commmits to {{payload/ref}}:<br />
  <ul class='commits'>
    {{#each payload/commits}}
      <li>{{sha}} - {{message}}</li>
    {{/each}}
  </ul>
"