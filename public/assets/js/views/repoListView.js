(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  GB.RepoListView = (function(_super) {

    __extends(RepoListView, _super);

    function RepoListView() {
      return RepoListView.__super__.constructor.apply(this, arguments);
    }

    RepoListView.prototype.initialize = function() {
      return this.model.on('change:selected', this.renderSelection, this);
    };

    RepoListView.prototype.tagName = "li";

    RepoListView.prototype.render = function() {
      this.$el.html(Mustache.to_html(GB.RepoListViewTemplate, this.model.attributes));
      this.$el.data("repo-slug", this.model.get('slug'));
      if (this.model.get('selected')) {
        this.$el.addClass('selected');
      }
      return this;
    };

    RepoListView.prototype.renderSelection = function() {
      if (this.model.get('selected')) {
        return this.$el.addClass('selected');
      } else {
        return this.$el.removeClass('selected');
      }
    };

    return RepoListView;

  })(Backbone.View);

}).call(this);
