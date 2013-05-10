var NavobileSupport;

window.NavobileSupport = NavobileSupport = (function() {

  function NavobileSupport() {}

  NavobileSupport.prototype.createMock = function() {
    affix('#mock');
    this.attachCta();
    this.attachNavigation();
    return $('#mock');
  };

  NavobileSupport.prototype.attachCta = function() {
    return $('#mock').affix('a#show-navobile');
  };

  NavobileSupport.prototype.attachNavigation = function() {
    var i, _i, _results;
    $('#mock').affix('#navigation ul');
    _results = [];
    for (i = _i = 1; _i <= 5; i = _i += 1) {
      _results.push($('#mock #navigation ul').affix("li a[href=\"#\"]"));
    }
    return _results;
  };

  NavobileSupport.prototype.navobileVisible = function() {
    return ($('.navobile-navigation').css('display') == 'block') ? true : false ;
  };

  NavobileSupport.prototype.enableEffects = function() {
    return $.fx.off = false;
  };

  NavobileSupport.prototype.disableEffects = function() {
    return $.fx.off = true;
  };

  return NavobileSupport;

})();
