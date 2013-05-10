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
