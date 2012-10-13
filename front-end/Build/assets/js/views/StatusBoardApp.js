(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  window.GB || (window.GB = {});

  GB.StatusBoardApp = (function(_super) {

    __extends(StatusBoardApp, _super);

    function StatusBoardApp() {
      return StatusBoardApp.__super__.constructor.apply(this, arguments);
    }

    StatusBoardApp.prototype.initialize = function() {
      this.setElement($('app'));
      this.user = new GB.User();
      this.repos = new GB.Repos();
      this.pullRequests = new GB.PullRequests();
      this.listView = new GB.ListView({
        collection: this.repos
      });
      this.detailContainer = this.$('#detail');
      return this.repos.bind('reset', this.renderListView, this);
    };

    StatusBoardApp.prototype.renderListView = function() {
      return this.$('#list').html(this.listView.render().$el);
    };

    StatusBoardApp.prototype.loadAll = function(callback) {
      this.repos.fetch();
      if (callback != null) {
        return callback();
      }
    };

    StatusBoardApp.prototype.showCommit = function(commit) {
      var commitView;
      commitView = GB.CommitView({
        model: commit
      });
      return this.detailContainer.html(commitView.render().$el);
    };

    StatusBoardApp.prototype.showRepos = function() {
      var ids;
      return ids = self.listView.selectedCommitIds();
    };

    return StatusBoardApp;

  })(Backbone.View);

  $(function() {
    window.App = new GB.StatusBoardApp();
    return window.App.loadAll(function() {
      return window.App.user.set({
        name: "Elliott Kember",
        email: "elliott.kember@gmail.com",
        avatar_url: "https://twimg0-a.akamaihd.net/profile_images/1042496336/bath_bigger.jpg"
      });
    });
  });

}).call(this);
