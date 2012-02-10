window.UT =
  debug: $("html").data("debug") is "yes"

UT.p = (args...) ->
  console.log args... if UT.debug and console?
