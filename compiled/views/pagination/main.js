(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(function(require) {
    var Fn, Pagination, Views, tpls, _ref;
    Fn = require('hilib/functions/general');
    Views = {
      Base: require('views/base')
    };
    tpls = require('hilib/templates');
    return Pagination = (function(_super) {
      __extends(Pagination, _super);

      function Pagination() {
        _ref = Pagination.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      Pagination.prototype.className = '';

      Pagination.prototype.initialize = function() {
        var _base, _base1;
        Pagination.__super__.initialize.apply(this, arguments);
        this.setCurrentPage(1);
        if ((_base = this.options).step10 == null) {
          _base.step10 = false;
        }
        return (_base1 = this.options).triggerPagenumber != null ? (_base1 = this.options).triggerPagenumber : _base1.triggerPagenumber = false;
      };

      Pagination.prototype.render = function() {
        this.options.pageCount = Math.ceil(this.options.resultCount / this.options.rowCount);
        this.el.innerHTML = tpls['hilib/views/pagination/main'](this.options);
        return this;
      };

      Pagination.prototype.events = function() {
        return {
          'click li.prev10.active': 'prev10',
          'click li.prev.active': 'prev',
          'click li.next.active': 'next',
          'click li.next10.active': 'next10'
        };
      };

      Pagination.prototype.prev10 = function() {
        return this.setCurrentPage(this.options.currentPage - 10);
      };

      Pagination.prototype.prev = function() {
        return this.setCurrentPage(this.options.currentPage - 1);
      };

      Pagination.prototype.next = function() {
        return this.setCurrentPage(this.options.currentPage + 1);
      };

      Pagination.prototype.next10 = function() {
        return this.setCurrentPage(this.options.currentPage + 10);
      };

      Pagination.prototype.setCurrentPage = function(pageNumber) {
        var direction,
          _this = this;
        if (!this.triggerPagenumber) {
          direction = pageNumber < this.options.currentPage ? 'prev' : 'next';
          this.trigger(direction);
        }
        this.options.currentPage = pageNumber;
        this.render();
        return Fn.timeoutWithReset(500, function() {
          return _this.trigger('change:pagenumber', pageNumber);
        });
      };

      return Pagination;

    })(Views.Base);
  });

}).call(this);
