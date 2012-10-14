GB.CommitDetailViewTemplate = "
  Commit {{sha}}.
  
  <br />
  
  
  <br />
  
  {{#if commit}}
  
    {{{markdown commit/message}}}
  
    {{#if committer}}
      {{#with committer}}
        <img height=20 width=20 src='{{avatar_url}}' /> <strong>{{login}}</strong> committed
      {{/with}}
    {{/if}}
  
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
    
    {{#if comments}}}
      <div class='comments'>
        {{#each comments}}
          <div class='comment'>
            <img src='{{user/avatar_url}}' /> {{user/login}}: {{{body_html}}}
          </div>
        {{/each}}
      </div>
    {{/if}}
  {{else}}
    Loading...
  {{/if}}
"