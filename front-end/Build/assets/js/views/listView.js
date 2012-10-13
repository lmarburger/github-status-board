(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  window.GB || (window.GB = {});

  GB.ListView = (function(_super) {

    __extends(ListView, _super);

    function ListView() {
      return ListView.__super__.constructor.apply(this, arguments);
    }

    ListView.prototype.selectedRepoSlugs = [];

    ListView.prototype.events = {
      'click li a': 'didClickRepo'
    };

    ListView.prototype.didClickRepo = function(e) {
      var element, repo, slug;
      element = $(e.target).closest('li');
      slug = element.data('repo-slug');
      repo = this.collection.where({
        slug: slug
      })[0];
      return repo.toggleSelected();
    };

    ListView.prototype.repos = function() {
      return this.collection.where({
        id: selectedRepoSlugs
      });
    };

    ListView.prototype.template = function() {
      return GB.ListViewTemplate;
    };

    ListView.prototype.render = function() {
      var _this = this;
      this.$el.html(this.template());
      this.collection.each(function(repo) {
        var view;
        view = new GB.RepoListView({
          model: repo
        });
        return view.render().$el.appendTo(_this.$("ul"));
      });
      return this;
    };

    return ListView;

  })(Backbone.View);

}).call(this);
