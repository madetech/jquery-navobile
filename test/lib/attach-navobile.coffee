window.JasmineNavobile = class JasmineNavobile
  constructor: (@opts) ->
    @opts or=
      bindSwipe: true
      cta: "#show-navobile"
      changeDOM: true

    if $("#mock").find("#navigation").length > 0
      @attachNavobile()

  attachNavobile: ->
    $("#mock").find("#navigation").navobile(@opts)
