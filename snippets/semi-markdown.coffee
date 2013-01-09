
reCode = /[=`](\S+?(?:\s+\S+?)*?)[`=]/g
reBold = /\*(\S+?(?:\s+\S+?)*?)\*/g

escapeHTML = (content) ->
  content.
    replace(/</g, "&lt;").
    replace(/>/g, "&gt;").
    replace(/\&/g, "&amp;")

lastInsertion = Talker.getLastInsertion()
lastInsertion.replace(reCode, (_, c) -> "<tt style='background: #eee'>#{escapeHTML c}</tt>")
lastInsertion.replace(reBold, (_, c) -> "<strong>#{escapeHTML c}</strong>")
