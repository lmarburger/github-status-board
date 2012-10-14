GB.CommitDetailViewTemplate = "
  I'm details of commit {{sha}}.
  
  <br />
  <br />
  <br />
  
  {{#if committer}}
    {{#with committer}}
      <img height=20 width=20 src='{{avatar_url}}' /> <strong>{{login}}</strong> committed
    {{/with}}
  {{/if}}
  
  <strong>{{message}}</strong>
  
  <br />
  <br />
  <br />
  
  {{#if files}}
    {{#each files}}
      {{filename}}:<br />
      <commit>{{{rawPatch patch}}}</commit>
    {{/each}}
  {{/if}}
  <br />
  <br />
  <br />
  
  {{#if stats}}
    {{#with stats}}
      {{additions}} additions, {{deletions}} deletions.
    {{/with}}
  {{/if}}
"