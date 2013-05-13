describe 'Navobile gets bound', ->
  navobile = null
  support = null
  mock = null

  beforeEach ->
    navobile = new JasmineNavobile()
    support = new NavobileSupport()
    mock = support.createMock()

  afterEach ->
    support.removeNavobile()

  it 'Should attach navobile if page #navigation', ->
    spy = spyOn navobile, 'attachNavobile'
    navobile.constructor()
    expect(spy).toHaveBeenCalled()

  it 'Should not be visible at a width greater than the media query', ->
    navobile.constructor()
    expect(support.navobileVisible()).toBe false

  it 'Should bind navobile classes so CSS can be applied', ->
    navobile.constructor()
    expect($(mock).find('.navobile-navigation').length).toBeGreaterThan(0)
    expect($(mock).find('#content')).toHaveClass('navobile-content')
    expect($('body')).toHaveClass('navobile-bound')
