var BumpAddressBar,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

window.BumpAddressBar = BumpAddressBar = (function() {

  function BumpAddressBar() {
    this.loaded = __bind(this.loaded, this);

    this.scrollWindow = __bind(this.scrollWindow, this);

    this.bodyCheck = __bind(this.bodyCheck, this);
    this.bodycheck_interval = null;
    this.scroll_top = 1;
    if (!location.hash && window.addEventListener) {
      window.scrollTo(0, 1);
      this.bodycheck_interval = setInterval(this.bodyCheck, 15);
      window.addEventListener('load', this.loaded);
    }
  }

  BumpAddressBar.prototype.getScrollTop = function() {
    return window.pageYOffset || window.document.compatMode === 'CSS1Compat' && window.document.documentElement.scrollTop || window.document.body.scrollTop || 0;
  };

  BumpAddressBar.prototype.bodyCheck = function() {
    if (document.body) {
      clearInterval(this.bodycheck_interval);
      this.scroll_top = this.getScrollTop() === 1 ? 0 : 1;
      return this.scrollWindow();
    }
  };

  BumpAddressBar.prototype.scrollWindow = function() {
    if (this.getScrollTop() < 3) {
      return window.scrollTo(0, this.scroll_top);
    }
  };

  BumpAddressBar.prototype.loaded = function() {
    var _this = this;
    return setTimeout((function() {
      return _this.scrollWindow();
    }), 0);
  };

  return BumpAddressBar;

})();

new BumpAddressBar();
