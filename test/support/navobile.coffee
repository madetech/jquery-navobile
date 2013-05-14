
window.NavobileSupport = class NavobileSupport
  createMock: ->
    affix '#mock #content'
    @attachCta()
    @attachNavigation()
    $('#mock')

  attachCta: ->
    $('#mock #content').affix 'a#show-navobile'

  attachNavigation: ->
    $('#mock #content').affix '#navigation ul'

    for i in [1..5] by 1
      $('#mock #content #navigation ul').affix "li a[href=\"#\"]"

  setMobile: (is_mobile)->
    $('#navobile-device-pixel').css
      width: if is_mobile then 1 else ''

  navobileVisible: ->
    if $('.navobile-navigation').css('display') == 'block' then true else false

  navobileOpen: ->
    if $('html').hasClass('csstransforms3d') or $('html').hasClass('csstransforms')
      return if $('.navobile-content').hasClass('navobile-content-hidden') then true else false
    else
      return if $('.navobile-content').css('left') is '0%' then false else true

  enableEffects: ->
    $.fx.off = false

  disableEffects: ->
    $.fx.off = true

  removeNavobile: ->
    $('body').removeClass 'navobile-bound'
