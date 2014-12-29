describe '#bindSwipe', ->
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

  it 'should not be active if HammerJS not loaded', ->
    $('html').removeClass('no-touch').addClass('touch')
    window.Hammer = null
    navobile.constructor()
    $(mock).find('#content').trigger('swipeleft')
    expect('swipeleft').not.toHaveBeenTriggeredOn $(mock).find('#content')
