describe 'Navobile gets bound', ->
  navobile = null;
  support = null;
  mock = null;

  beforeEach ->
    navobile = new JasmineNavobile()
    support = new NavobileSupport()
    mock = support.createMock()

  it 'Should attach navobile if page #navigation', ->
    spy = spyOn navobile, 'attachNavobile'
    navobile.constructor()
    expect(spy).toHaveBeenCalled()

  it 'Should not be visible at a width greater than the media query', ->
    navobile.constructor()
    expect(support.navobileVisible()).toBe false

  it 'Should bind navobile classes so CSS can be applied', ->
    navobile.constructor()
    expect($('.navobile-navigation').length).toBeGreaterThan(0)
    expect($('#content')).toHaveClass('navobile-content')
    expect($('body')).toHaveClass('navobile-bound')

describe 'Open Navobile using CTA', ->
  navobile = null;
  support = null;
  mock = null;

  beforeEach ->
    navobile = new JasmineNavobile()
    support = new NavobileSupport()
    mock = support.createMock()
    support.disableEffects()

  afterEach ->
    support.enableEffects()

  it 'Should not open if on desktop and desktop width', ->
    navobile.constructor()
    support.setMobile false
    $('#show-navobile').click()
    expect('click').toHaveBeenPreventedOn $('#show-navobile')
    expect(support.navobileOpen()).toBe false


