/*
Copyright (c) 2013, Made By Made Ltd
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the "Made By Made Ltd" nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL MADE BY MADE LTD BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/


(function() {

  (function(window, $) {
    'use strict';
    $.navobile = function(el, method) {
      var base, methods;
      base = this;
      base.$el = $(el);
      base.el = el;
      base.$el.data("navobile", base);
      base.attach = function() {
        base.$el.data({
          open: false
        });
        base.$content.data({
          drag: false
        });
        base.bindTap(base.$cta, base.$nav, base.$content, ($('html').hasClass('touch') ? 'touchend' : 'click'));
        if (typeof Hammer === 'function' && (base.options.bindSwipe || base.options.bindDrag)) {
          base.$content.hammer();
          if (base.options.bindSwipe) {
            base.bindSwipe(base.$nav, base.$content);
          }
          if (base.options.bindDrag) {
            return base.bindDrag(base.$nav, base.$content);
          }
        }
      };
      base.bindTap = function($cta, $nav, $content, type) {
        return $cta.on(type, function(ev) {
          ev.preventDefault();
          ev.stopPropagation();
          if (ev.gesture !== void 0) {
            ev.gesture.preventDefault();
            ev.gesture.stopPropagation();
          }
          if (!base.isMobile()) {
            return false;
          }
          if ($nav.data('open')) {
            base.slideContentIn($nav, $content);
          } else {
            base.slideContentOut($nav, $content);
          }
          return false;
        });
      };
      base.bindSwipe = function($nav, $content) {
        $content.on('swipeleft', function(e) {
          if (!base.isMobile()) {
            return false;
          }
          if ($content.data('drag')) {
            base.removeInlineStyles($nav, $content);
            $content.data('drag', false);
          }
          base.slideContentIn($nav, $content);
          e.gesture.preventDefault();
          return e.stopPropagation();
        });
        return $content.on('swiperight', function(e) {
          if (!base.isMobile()) {
            return false;
          }
          if ($content.data('drag')) {
            base.removeInlineStyles($nav, $content);
            $content.data('drag', false);
          }
          base.slideContentOut($nav, $content);
          e.gesture.preventDefault();
          return e.stopPropagation();
        });
      };
      base.bindDrag = function($nav, $content) {
        return $content.on('dragstart drag dragend release', function(e) {
          var posX, translateX;
          if (!base.isMobile()) {
            return false;
          }
          if (e.type === 'release') {
            base.removeInlineStyles($nav, $content);
            return false;
          }
          if (e.direction === 'left') {
            if (!$content.hasClass('navobile-content-hidden')) {
              return false;
            } else {
              base.slideContentIn($nav, $content);
            }
          }
          if (e.direction === 'right') {
            if (e.type === 'dragend') {
              if (e.distance > 60) {
                base.slideContentOut($nav, $content);
              } else {
                base.slideContentIn($nav, $content);
              }
              base.removeInlineStyles($nav, $content);
              return false;
            }
            if (e.type === 'dragstart') {
              $content.data('drag', true);
            }
            posX = e.position.x;
            translateX = Math.ceil(base.calculateTranslate(posX));
            if (translateX > 80 || translateX < 0) {
              return false;
            }
            if ($('html').hasClass('csstransforms3d')) {
              return $content.css('transform', "translate3d(" + translateX + "%, 0, 0)");
            } else if ($('html').hasClass('csstransforms')) {
              return $content.css('transform', "translateX(" + translateX + "%)");
            }
          }
        });
      };
      base.animateLeft = function(percent, $nav, $content) {
        if (!$('html').hasClass('csstransforms3d') && !$('html').hasClass('csstransforms')) {
          $content.animate({
            left: percent
          }, 200, base.options.easing);
        } else {
          if (percent === '0%') {
            $content.removeClass('navobile-content-hidden');
          } else {
            $content.addClass('navobile-content-hidden');
          }
        }
        if (percent === '0%') {
          $nav.removeClass('navobile-navigation-visible');
        } else {
          $nav.addClass('navobile-navigation-visible');
        }
        return base.removeInlineStyles($nav, $content);
      };
      base.slideContentIn = function($nav, $content) {
        $nav.data('open', false);
        return base.animateLeft('0%', $nav, $content);
      };
      base.slideContentOut = function($nav, $content) {
        $nav.data('open', true);
        return base.animateLeft('80%', $nav, $content);
      };
      base.calculateTranslate = function(posX) {
        return (posX / $(document).width()) * 100;
      };
      base.removeInlineStyles = function($nav, $content) {
        return $content.css('transform', '');
      };
      base.isMobile = function() {
        return $('#navobile-device-pixel').width() > 0;
      };
      methods = {
        init: function(options) {
          var originalId;
          if ($('body').hasClass('navobile-bound')) {
            return;
          }
          base.options = $.extend({}, $.navobile.settings, options);
          base.$cta = $(base.options.cta);
          base.$content = $(base.options.content);
          base.$nav = base.options.changeDOM ? base.$el.clone() : base.$el;
          base.$content.addClass('navobile-content');
          if ($('#navobile-device-pixel').length === 0) {
            $('body').append('<div id="navobile-device-pixel" />');
          }
          $('body').addClass('navobile-bound');
          if (base.options.changeDOM) {
            base.$el.addClass('navobile-desktop-only');
            base.$nav.addClass('navobile-mobile-only');
            originalId = base.$nav.attr('id');
            base.$nav.attr('id', "navobile-" + originalId);
            base.$content.before(base.$nav);
          }
          base.$nav.addClass('navobile-navigation');
          return base.attach();
        }
      };
      if (methods[method]) {
        return methods[method].apply(this, Array.prototype.slice.call(argument, 1));
      } else if (typeof method === "object" || !method) {
        return methods.init(method);
      } else {
        return $.error("Method " + method + " does not exist on jQuery.navobile");
      }
    };
    $.navobile.settings = {
      cta: '#show-navigation',
      content: '#content',
      easing: 'linear',
      changeDOM: false,
      bindSwipe: false,
      bindDrag: false
    };
    return $.fn.navobile = function(method) {
      return this.each(function() {
        return new $.navobile(this, method);
      });
    };
  })(window, jQuery);

}).call(this);
