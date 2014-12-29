describe 'Methods', ->
  navobile = null
  support = null
  mock = null

  beforeEach ->
    navobile = new JasmineNavobile()
    support = new NavobileSupport()
    mock = support.createMock()

  afterEach ->
    support.removeNavobile()

  describe '#destroy', ->
    it 'should remove navobile', ->
      navobile.constructor()
      expect($(mock).find('.navobile-navigation').length).toBe(1)
      $(mock).find("#navigation").navobile('destroy')
      expect($(mock).find('.navobile-navigation').length).toBe(0)
