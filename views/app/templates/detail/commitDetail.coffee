GB.CommitDetailViewTemplate = "
  I'm details of commit {{sha}}.
  
  <br />
  <br />
  <br />
  
  {{#if committer}}
    {{#with committer}}
      <img src='{{avatar_url}}' /> {{login}}
    {{/with}}
  {{/if}}
  
  <strong>{{message}}</strong>
  
  {{#if files}}
    {{#each files}}
      {{filename}}:<br />
      <pre>{{rawPatch patch}}</pre>
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