
engine = null
doc    = null

# -------------

$ ->
  attach_ux_events()
  main()

attach_ux_events = ->
  $('#btn-no-sync, #btn-sync, #login_row').mouseover ->
    $('#sync-explanation').addClass 'highlight'
  $('#btn-no-sync, #btn-sync, #login_row').mouseout ->
    $('#sync-explanation').removeClass 'highlight'
  $('#btn-login').click -> click_login @
  $('#input-email, #input-passphrase, #input-service').focus -> $(@).addClass 'modified'
  $('#input-email, #input-passphrase, #input-service').keyup (e) ->
    engine.got_input $(@).attr('id')
    if engine.has_login_info()
      $('#btn-login').attr("disabled", false)

click_login = (e) ->
  console.log "logging in"
  $('#login-status-row').slideDown 'fast'
  $('#btn-login').attr("disabled", "disabled")
  #if $('#input-email').val() and $('#input-passhprase').val()
  #  try_to_login 
  #  console.log "logging in"
  #  $('#login-status-row').slideDown 'fast'
  #  $('#btn-login').attr("disabled", "disabled")
  #else



main = () ->
  docmod = require './document'
  locmod = require './location'
  engmod = require './engine'
  doc = new docmod.Browser window.document
  loc = new locmod.Location window.location
  engine = new engmod.Engine doc, loc
  engine.start()

ungrey = (e) ->
  e.className += " input-black"
  
accept_focus = (e) ->
  se = event.srcElement
  se.value = "" if doc.ungrey se

accept_form_input = (e) ->
  engine.got_input e

click_hide_passphrase = (e) ->
  hide = event.srcElement.checked
  (doc.q 'passphrase').type = if hide then "password" else "text"

tbody_enable = (e, b) ->
  e.style.display = if b then "table-row-group" else "none"
trow_enable = (e, b) -> 
  e.style.display = if b then "table-row" else "none"
inline_enable = (e, b) ->
  e.style.display = if b then 'inline' else 'none' 

show_advanced = (b) ->
  tbody_enable doc.q('advanced-expander'), not b
  tbody_enable doc.q('advanced'), b
  
click_run_timers = (e) ->
  engine.toggle_timers e.srcElement.checked

select_text = (e) ->
  e.srcElement.focus()
  e.srcElement.select()

click_sync = (e) ->
  b = e.srcElement.checked
  tbody_enable doc.q('sync-details'), b
  trow_enable doc.q('sync-note-row'), b
  inline_enable doc.q('sync-push-button'), b
  doc.clear_sync_status()
  engine.toggle_sync b
  for f in [ 'passphrase', 'email' ]
    doc.q(f).readOnly = b

click_signup = (e) ->
  engine.client().signup()

push_record = (e) ->
  engine.client().push_record()

select_stored_recored = (e) ->
  engine.select_stored_record(e.srcElement.value)
  



