GB.PushEventTemplate = "
  <h3>{{repo/name}}</h3>
  <strong>{{actor/login}}</strong> pushed {{payload/size}} commits to {{payload/ref}}:<br />
  <ul class='commits'>
    {{#each payload/commits}}
    {{repo/name}}
      <li><a href='#none' class='sha' data-sha='{{sha}}' data-repo-slug='{{../repo/name}}'>{{sha}}</a> - {{truncate message 80}}</li>
    {{/each}}
  </ul>
  <time>{{ago created_at}}</time>
"
