GB.CommitDetailViewTemplate = "
  Commit {{sha}}.
  
  <br />
  
  {{#if commit}}
  
    {{#if committer}}
      {{#with committer}}
        <img height=20 width=20 src='{{avatar_url}}' /> <strong>{{login}}</strong> committed
      {{/with}}
    {{/if}}
  
    <strong>{{message}}</strong>
  
    <br />
  
    {{#if files}}
      {{#each files}}
        {{filename}}:<br />
        <commit>{{{rawPatch patch}}}</commit>
      {{/each}}
    {{/if}}

    <br />
  
    {{#if stats}}
      {{#with stats}}
        {{additions}} additions, {{deletions}} deletions.
      {{/with}}
    {{/if}}
  {{else}}
    Loading...
  {{/if}}
"