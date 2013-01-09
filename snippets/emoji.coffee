Icons = "https://gist.github.com/raw/a47f11e7f8a40273033c/ac71981862f3f9777997197f0719f0f9c40b7805/icons.png"

OnePixelGif = "data:image/gif;base64,R0lGODlhAQABAPAAAAAAAAAAACH5BAEAAAAAIf4RQ3JlYXRlZCB3aXRoIEdJ\nTVAALAAAAAABAAEAAAICRAEAOw=="

if window.emoji
  Talker.getLastInsertion().replace(/:(\w+):/g, (matched, icon) ->
    position = emoji[icon.toLowerCase()]
    if position
      """<img width="22" height="22" src="#{OnePixelGif}" style="background:url(#{Icons}) #{position} no-repeat"/>"""
    else
      matched
  )
