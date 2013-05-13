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

  it 'Should not open if on desktop and desktop width', ->
    navobile.constructor()
    support.setMobile false
    $(mock).find('#show-navobile').click()
    expect('click').toHaveBeenPreventedOn $(mock).find('#show-navobile')
    expect(support.navobileOpen()).toBe false
