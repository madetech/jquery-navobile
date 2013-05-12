window.JasmineNavobile = class JasmineNavobile
  constructor: ->
    if $("#mock").find("#navigation").length > 0
      @attachNavobile()

  attachNavobile: ->
    $("#mock").find("#navigation").navobile
      bindSwipe: true
      cta: "#show-navobile"
      changeDOM: true

new JasmineNavobile()
