describe '#bindTap', ->
  navobile = null
  support = null
  mock = null
  click_catch_false_opts =
    cta: "#show-navobile"
    changeDOM: true
    clickCatch: false

  beforeEach ->
    navobile = new JasmineNavobile()
    support = new NavobileSupport()
    mock = support.createMock()
    support.disableEffects()

  afterEach ->
    support.enableEffects()
    support.removeNavobile()

  describe 'on desktop', ->
    it 'should show navigation if cta clicked', ->
      $('html').removeClass('touch').addClass('no-touch')
      navobile.constructor()
      $(mock).find('#show-navobile').click()
      expect(support.navobileOpen()).toBe true

  describe 'on mobile', ->
    beforeEach ->
      $('html').removeClass('no-touch').addClass('touch')

    it 'should show navigation on touchend of cta', ->
      navobile.constructor()
      $(mock).find('#show-navobile').trigger('touchend')
      expect(support.navobileOpen()).toBe true

    it 'shouldnt close navigation on a click of #navobile-click-catch', ->
      navobile.constructor(click_catch_false_opts)
      $(mock).find('#show-navobile').trigger('touchend')
      $(mock).find('#navobile-click-catch').trigger('touchend')
      expect(support.navobileOpen()).toBe true

    it 'should close navigation on a second touchend of cta, if clickCatch is false', ->
      navobile.constructor(click_catch_false_opts)
      $(mock).find('#show-navobile').trigger('touchend')
      $(mock).find('#show-navobile').trigger('touchend')
      expect(support.navobileOpen()).toBe false

describe '#bindClickClose', ->
  navobile = null
  support = null
  mock = null

  beforeEach ->
    navobile = new JasmineNavobile()
    support = new NavobileSupport()
    mock = support.createMock()
    support.disableEffects()

  afterEach ->
    support.enableEffects()
    support.removeNavobile()

  it 'should close navigation on a click of #navobile-click-catch', ->
    $('html').removeClass('no-touch').addClass('touch')
    navobile.constructor()
    $(mock).find('#show-navobile').trigger('touchend')
    $(mock).find('#navobile-click-catch').trigger('touchend')
    expect(support.navobileOpen()).toBe false
