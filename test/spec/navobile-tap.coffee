describe 'Open Navobile using CTA', ->
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

  it 'Should show navigation if cta clicked on desktop', ->
    $('html').removeClass('touch').addClass('no-touch')
    navobile.constructor()
    $(mock).find('#show-navobile').click()
    expect(support.navobileOpen()).toBe true

  it 'Should show navigation on touchend of cta', ->
    $('html').removeClass('no-touch').addClass('touch')
    navobile.constructor()
    $(mock).find('#show-navobile').trigger('touchend')
    expect(support.navobileOpen()).toBe true

  it 'Should close navigation on a click of #navobile-click-catch', ->
    $('html').removeClass('no-touch').addClass('touch')
    navobile.constructor()
    $(mock).find('#show-navobile').trigger('touchend')
    $(mock).find('#navobile-click-catch').trigger('touchend')
    expect(support.navobileOpen()).toBe false
