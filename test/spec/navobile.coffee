describe '#attach', ->
  navobile = null
  support = null
  mock = null

  beforeEach ->
    navobile = new JasmineNavobile()
    support = new NavobileSupport()
    mock = support.createMock()

  afterEach ->
    support.removeNavobile()

  it 'if page #navigation', ->
    spy = spyOn navobile, 'attachNavobile'
    navobile.constructor()
    expect(spy).toHaveBeenCalled()

  it 'should create a data attribute', ->
    navobile.constructor()
    console.log $(mock).find('#navigation').data('plugin_navobile')

  it 'should add additional classes so CSS can be applied', ->
    navobile.constructor()
    expect($(mock).find('.navobile-navigation').length).toBeGreaterThan(0)
    expect($(mock).find('#content')).toHaveClass('navobile-content')
    expect($('body')).toHaveClass('navobile-bound')

  describe 'at mobile viewport', ->
    it 'should be visible', ->
      navobile.constructor()
      expect(support.navobileVisible()).toBe true

  describe 'click catch should be created', ->
    it 'when clickCatch true', ->
      navobile.constructor()
      expect($(mock).find('#navobile-click-catch').length).toBeGreaterThan(0)

  describe 'click catch shouldnt be created', ->
    it 'when clickCatch false', ->
      opts =
        cta: "#show-navobile"
        changeDOM: true
        clickCatch: false

      navobile.constructor(opts)

      expect($(mock).find('#navobile-click-catch').length).toBe(0)
