(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  window.GB || (window.GB = {});

  GB.Repo = (function(_super) {

    __extends(Repo, _super);

    function Repo() {
      return Repo.__super__.constructor.apply(this, arguments);
    }

    Repo.selected = false;

    Repo.prototype.toggleSelected = function() {
      return this.set('selected', !this.get('selected'));
    };

    return Repo;

  })(Backbone.Model);

  GB.Repos = (function(_super) {

    __extends(Repos, _super);

    function Repos() {
      return Repos.__super__.constructor.apply(this, arguments);
    }

    Repos.prototype.model = GB.Repo;

    Repos.prototype.url = "/api/repos";

    return Repos;

  })(Backbone.Collection);

  GB.Commit = (function(_super) {

    __extends(Commit, _super);

    function Commit() {
      return Commit.__super__.constructor.apply(this, arguments);
    }

    Commit.prototype.url = function() {
      return ["api", "commits", this.get('sha')].join('/');
    };

    return Commit;

  })(Backbone.Model);

  GB.Event = (function(_super) {

    __extends(Event, _super);

    function Event() {
      return Event.__super__.constructor.apply(this, arguments);
    }

    return Event;

  })(Backbone.Model);

  GB.User = (function(_super) {

    __extends(User, _super);

    function User() {
      return User.__super__.constructor.apply(this, arguments);
    }

    return User;

  })(Backbone.Model);

  GB.PullRequest = (function(_super) {

    __extends(PullRequest, _super);

    function PullRequest() {
      return PullRequest.__super__.constructor.apply(this, arguments);
    }

    return PullRequest;

  })(Backbone.Model);

  GB.PullRequests = (function(_super) {

    __extends(PullRequests, _super);

    function PullRequests() {
      return PullRequests.__super__.constructor.apply(this, arguments);
    }

    PullRequests.prototype.model = GB.PullRequest;

    return PullRequests;

  })(Backbone.Collection);

}).call(this);
