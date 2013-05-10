###
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
###

((window, $) ->
  'use strict'

  $.navobile = (el, method) ->
    base = @
    base.$el = $(el)
    base.el = el
    base.$el.data "navobile", base

    base.attach = ->
      base.$el.data
        open: false

      base.$content.data
        drag: false

      base.bindTap base.$cta, base.$nav, base.$content, (
        if $('html').hasClass 'touch' then 'touchend' else 'click'
      )

      if typeof Hammer is 'function' and (base.options.bindSwipe or base.options.bindDrag)
        base.$content.hammer()

        if base.options.bindSwipe
          base.bindSwipe base.$nav, base.$content

        if base.options.bindDrag
          base.bindDrag base.$nav, base.$content

    ################################################
    # Touch Interactions
    ################################################

    base.bindTap = ($cta, $nav, $content, type) ->
      $cta.on type, (ev)->
        ev.preventDefault()
        ev.stopPropagation()

        return false if !base.isMobile()

        if $nav.data('open')
          base.slideContentIn $nav, $content
        else
          base.slideContentOut $nav, $content

        return false

    base.bindSwipe = ($nav, $content) ->
      $content.on 'swipeleft', (e) ->
        return false if !base.isMobile()

        if $content.data('drag')
          base.removeInlineStyles $nav, $content
          $content.data 'drag', false

        base.slideContentIn $nav, $content
        e.gesture.preventDefault()
        e.stopPropagation()

      $content.on 'swiperight', (e) ->
        return false if !base.isMobile()

        if $content.data('drag')
          base.removeInlineStyles $nav, $content
          $content.data 'drag', false

        base.slideContentOut $nav, $content
        e.gesture.preventDefault()
        e.stopPropagation()

    base.bindDrag = ($nav, $content) ->
      $content.on 'dragstart drag dragend release', (e) ->
        return false if !base.isMobile()

        if e.type is 'release'
          base.removeInlineStyles $nav, $content
          return false

        if e.direction is 'left'
          if !$content.hasClass('navobile-content-hidden')
            return false
          else
            base.slideContentIn $nav, $content

        if e.direction is 'right'
          if e.type is 'dragend'

            if e.distance > 60
              base.slideContentOut $nav, $content
            else
              base.slideContentIn $nav, $content

            base.removeInlineStyles $nav, $content

            return false

          if e.type is 'dragstart'
            $content.data 'drag', true

          posX = e.position.x
          translateX = Math.ceil base.calculateTranslate posX
          if translateX > 80 || translateX < 0
            return false

          if $('html').hasClass('csstransforms3d')
            $content.css 'transform', "translate3d(#{translateX}%, 0, 0)"
          else if $('html').hasClass('csstransforms')
            $content.css 'transform', "translateX(#{translateX}%)"

    ################################################
    # Element Movement
    ################################################

    base.animateLeft = (percent, $nav, $content) ->
      if !$('html').hasClass('csstransforms3d') and !$('html').hasClass('csstransforms')
        $content.animate
            left: percent
        , 200
        , base.options.easing
      else
        if percent is '0%' then $content.removeClass 'navobile-content-hidden' else $content.addClass 'navobile-content-hidden'

      if percent is '0%' then $nav.removeClass 'navobile-navigation-visible' else $nav.addClass 'navobile-navigation-visible'

      base.removeInlineStyles $nav, $content

    base.slideContentIn = ($nav, $content) ->
      $nav.data 'open', false
      base.animateLeft '0%', $nav, $content

    base.slideContentOut = ($nav, $content) ->
      $nav.data 'open', true
      base.animateLeft '80%', $nav, $content

    ################################################
    # Helpers
    ################################################

    base.calculateTranslate = (posX) ->
      (posX / $(document).width()) * 100

    base.removeInlineStyles = ($nav, $content) ->
      $content.css 'transform', ''

    base.isMobile = ->
      $('#navobile-device-pixel').width() > 0

    ################################################
    # Methods
    ################################################

    methods =
      init: (options) ->
        return if $('body').hasClass 'navobile-bound'

        base.options = $.extend({}, $.navobile.settings, options)
        base.$cta = $(base.options.cta)
        base.$content = $(base.options.content)
        base.$nav = if base.options.changeDOM then base.$el.clone() else base.$el
        base.$content.addClass 'navobile-content'

        if $('#navobile-device-pixel').length is 0
          $('body').append '<div id="navobile-device-pixel" />'

        $('body').addClass 'navobile-bound'

        if base.options.changeDOM
          base.$el.addClass 'navobile-desktop-only'
          base.$nav.addClass 'navobile-mobile-only'
          originalId = base.$nav.attr 'id'
          base.$nav.attr 'id', "navobile-#{ originalId }"
          base.$content.before base.$nav

        base.$nav.addClass 'navobile-navigation'
        base.attach()

    if methods[method]
      return methods[method].apply this, Array::slice.call(argument, 1)
    else if typeof method is "object" or not method
      return methods.init method
    else
      return $.error "Method #{ method } does not exist on jQuery.navobile"

  $.navobile.settings =
    cta: '#show-navigation'
    content: '#content'
    easing: 'linear'
    changeDOM: false
    bindSwipe: false
    bindDrag: false

  $.fn.navobile = (method) ->
    @each ->
      new $.navobile(@, method)

) window, jQuery