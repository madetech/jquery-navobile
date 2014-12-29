(($, window, document) ->
  'use strict'

  Navobile = (element, args) ->
    @_name = pluginName

    @methods =
      destroy: =>
        @destroy()

    return @init element, args

  pluginName = "navobile"
  defaults =
    cta: '#show-navigation'
    clickCatch: true,
    content: '#content'
    direction: 'ltr'
    easing: 'linear'
    changeDOM: false
    copyBoundEvents: false
    bindSwipe: false
    bindDrag: false
    openOffset: '80%'
    hammerOptions: {}

  $.extend Navobile::,
    init: (element, args) ->
      return if $('body').hasClass('navobile-bound')
      $('body').addClass 'navobile-bound'

      @elem = element
      @$elem = $(@elem)
      @settings = $.extend({}, defaults, args)
      @_defaults = defaults
      @$cta = $(@settings.cta)
      @$content = $(@settings.content)
      @$nav = if @settings.changeDOM then @$elem.clone(@settings.copyBoundEvents) else @$elem

      @createNewElems()

      @cloneDom() if @settings.changeDOM

      @$content.addClass "navobile-content navobile-content--#{@settings.direction}"

      @attach()

      @$nav.addClass "navobile-navigation navobile-navigation--#{@settings.direction}"

      return @

    attach: ->
      @$elem.data open: false
      @$content.data drag: false

      interaction = if $('html').hasClass 'touch' then 'touchend' else 'click'

      @bindTap("#{interaction}.navobile")
      @bindClickCatch("#{interaction}.navobile") if @settings.clickCatch

      if typeof Hammer is 'function' and (@settings.bindSwipe or @settings.bindDrag)
        hammerObject = Hammer(@$content, @settings.hammerOptions)

        @bindSwipe() if @settings.bindSwipe
        @bindDrag() if @settings.bindDrag

    bindClickCatch: (type) ->
      @$content.on 'scroll.navobile touchdrag.navobile touchmove.navobile', (e) =>
        return if $('#navobile-click-catch').not(':visible')
        e.preventDefault()
        e.stopPropagation()

      @$content.parent().on 'scroll.navobile touchdrag.navobile touchmove.navobile', (e) =>
        return if $('#navobile-click-catch').not(':visible')
        e.preventDefault()
        e.stopPropagation()

      $('#navobile-click-catch').on 'scroll.navobile touchdrag.navobile touchmove.navobile', (e) =>
        e.preventDefault()
        e.stopPropagation()

      $('#navobile-click-catch').on type, (e) =>
        e.preventDefault()
        e.stopPropagation()

        return false if !@isMobile()
        @slideContentIn()
        false

    bindTap: (type) ->
      @$cta.on type, (e) =>
        e.preventDefault()
        e.stopPropagation()

        return false if !@isMobile() and !@settings.clickCatch

        if @$nav.data('open') and !@settings.clickCatch
          @slideContentIn()
        else
          @slideContentOut()

        false

    bindSwipe: ->
      in_gesture = if @showOnRight() then 'right' else 'left'
      out_gesture = if @showOnRight() then 'left' else 'right'

      @$content.on "swipe#{in_gesture}.navobile", (e) =>
        return false if !@isMobile()

        if @$content.data('drag')
          @removeInlineStyles()
          @$content.data 'drag', false

        @slideContentIn()
        e.gesture.preventDefault()
        e.stopPropagation()

      @$content.on "swipe#{out_gesture}.navobile", (e) =>
        return false if !@isMobile()

        if @$content.data('drag')
          @removeInlineStyles()
          @$content.data 'drag', false

        @slideContentOut()
        e.gesture.preventDefault()
        e.stopPropagation()

    bindDrag: ->
      in_gesture = if @showOnRight() then 'right' else 'left'
      out_gesture = if @showOnRight() then 'left' else 'right'

      @$content.on 'dragstart.navobile drag.navobile dragend.navobile release.navobile', (e) =>
        return false if !@isMobile()

        if e.type is 'release'
          @removeInlineStyles()
          return false

        if e.direction is in_gesture
          if !@$content.hasClass('navobile-content-hidden')
            return false
          else
            @slideContentIn()

        if e.direction is out_gesture
          if e.type is 'dragend'

            if e.distance > 60
              @slideContentOut()
            else
              @slideContentIn()

            @removeInlineStyles()

            return false

          if e.type is 'dragstart'
            @$content.data('drag', true)

          posX = e.position.x
          translateX = Math.ceil @calculateTranslate posX
          if translateX > 80 or translateX < 0
            return false

          if $('html').hasClass('csstransforms3d')
            @$content.css 'transform', "translate3d(#{translateX}%, 0, 0)"
          else if $('html').hasClass('csstransforms')
            @$content.css 'transform', "translateX(#{translateX}%)"

    ################################################
    # Methods
    ################################################

    destroy: ->
      $('#navobile-click-catch').off('.navobile')
      @$content.off('.navobile')
      @$content.parent().off('.navobile')

      @$nav.addClass "navobile-navigation navobile-navigation--#{@settings.direction}"
      @$content.removeClass "navobile-content navobile-content--#{@settings.direction}"

      @destroyDom() if @settings.changeDOM

    destroyDom: ->
      @$elem.removeClass('navobile-desktop-only')
      @$nav.remove()

      if @settings.clickCatch
        $('#navobile-click-catch').remove()

      $('#navobile-device-pixel').remove()

    ################################################
    # Element Movement
    ################################################

    animateContent: (percent) ->
      if !@canUseCssTransforms()
        dir_anime = if @showOnRight() then right: percent else left: percent

        @$content.animate dir_anime
        , 100
        , @settings.easing
        , =>
          eventName = if percent is '0%' then 'closed' else 'opened'
          @triggerEvent(eventName)
      else
        if percent is '0%'
          @transitionEndEvents('closed')
          @$content.removeClass('navobile-content-hidden')
        else
          @transitionEndEvents('opened')
          @$content.addClass('navobile-content-hidden')

      if percent is '0%'
        @$nav.removeClass('navobile-navigation-visible')
      else
        @$nav.addClass('navobile-navigation-visible')

      @removeInlineStyles()

    slideContentIn: ->
      @triggerEvent('close')
      @$nav.data 'open', false
      @animateContent '0%'

    slideContentOut: ->
      @triggerEvent('open')
      @$nav.data 'open', true
      @animateContent @settings.openOffset

    ################################################
    # Helpers
    ################################################

    clickCatchHtml: ->
      """
      <div id="navobile-click-catch"></div>
      """

    cloneDom: ->
      @$elem.addClass 'navobile-desktop-only'
      @$nav.addClass 'navobile-mobile-only'
      @originalId = "navobile-#{@$nav.attr 'id'}"
      @$nav.attr 'id', @originalId

      @$content.before @$nav

    createNewElems: ->
      if $('#navobile-device-pixel').length is 0
        $('body').append '<div id="navobile-device-pixel" />'

      if @settings.clickCatch
        @$content.prepend(@clickCatchHtml())

    showOnRight: ->
      @settings.direction is 'rtl'

    canUseCssTransforms: ->
      $('html').hasClass('csstransforms3d') or $('html').hasClass('csstransforms')

    calculateTranslate: (posX) ->
      (posX / $(document).width()) * 100

    isMobile: ->
      $('#navobile-device-pixel').width() > 0

    removeInlineStyles: ->
      @$content.css 'transform', ''

    triggerEvent: (eventName) ->
      $(document).trigger("navobile:#{eventName}")

    transitionEndEvents: (eventName) ->
      @$content.one 'webkitTransitionEnd oTransitionEnd otransitionend transitionend msTransitionEnd', =>
        @triggerEvent eventName

  $.fn[pluginName] = (args) ->
    @each ->
      if !$.data(@, "plugin_#{pluginName}") and (typeof args is "object" or not args)
        return $.data(@, "plugin_#{pluginName}", new Navobile(@, args))
      else if $.data(@, "plugin_#{pluginName}")
        if $.data(@, "plugin_#{pluginName}").methods[args]
          return $.data(@, "plugin_#{pluginName}").methods[args].apply @, Array::slice.call(args, 1)
        else
          return $.error "Method #{ args } does not exist on jQuery.#{ pluginName }"
    this

  return
) jQuery, window, document
