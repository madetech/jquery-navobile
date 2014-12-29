describe 'Events', ->
  navobile = null
  support = null
  mock = null
  eventSpy = null

  beforeEach ->
    navobile = new JasmineNavobile()
    support = new NavobileSupport()
    mock = support.createMock()
    support.disableEffects()
    $('html').removeClass('no-touch').addClass('touch')

  afterEach ->
    support.enableEffects()
    support.removeNavobile()

  it 'Should trigger an open event', ->
    navobile.constructor()
    spyEvent = spyOnEvent document, 'navobile:open'
    $(mock).find('#show-navobile').trigger('touchend')
    expect('navobile:open').toHaveBeenTriggeredOn(document);
    expect(spyEvent).toHaveBeenTriggered();

  it 'Should trigger an close event', ->
    navobile.constructor()
    spyEvent = spyOnEvent document, 'navobile:close'
    $(mock).find('#show-navobile').trigger('touchend')
    $(mock).find('#navobile-click-catch').trigger('touchend')
    expect('navobile:close').toHaveBeenTriggeredOn(document);
    expect(spyEvent).toHaveBeenTriggered();
