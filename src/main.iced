
engine = null

main = () ->
  docmod = require './document'
  engmod = require './engine'
  doc = new docmod.Browser window.document
  engine = new engmod.Engine doc
  engine.start()

window.onload = () -> main()

ungrey = (e) ->
  e.className += " input-black"
  
accept_focus = (e) ->
  se = event.srcElement
  unless se.className.match "input-black"
    ungrey se
    se.value = ""

accept_form_input = (e) ->
  engine.got_input e

accept_hide_passphrase_click = (e) ->
  hide = se = event.srcElement.checked
  (engine._doc.q 'passphrase').type = if hide then "password" else "text"
  
    
