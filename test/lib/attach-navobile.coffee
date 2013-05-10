window.JasmineNavobile = class JasmineNavobile
  constructor: ->
    if $("#navigation").length > 0
      @attachNavobile()

  attachNavobile: ->
    $("#navigation").navobile
      bindSwipe: true
      cta: "#show-navobile"
      changeDOM: true

new JasmineNavobile()
