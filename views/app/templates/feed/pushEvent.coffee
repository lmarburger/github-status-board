GB.PushEventTemplate = "
  <h3><strong>{{payload/ref}}</strong> on <b>{{repo/name}}</b></h3>
  <p><strong>{{actor/login}}</strong> pushed {{payload/size}} commits to {{payload/ref}}</p>
  <ul class='commits'>
    {{#each payload/commits}}
    {{repo/name}}
      <li><a href='#none' class='sha' data-sha='{{sha}}' data-repo-slug='{{../repo/name}}'>{{sha}}</a> &#8220;{{truncate message 80}}&#8221;</li>
    {{/each}}
  </ul>
  <time>{{ago created_at}}</time>
"
