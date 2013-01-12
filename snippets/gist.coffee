
unless window.gistPluginInitialized
  window.gistPluginInitialized = true
  window.addEventListener(
    "message", ( (event) ->
      if height = event.data.gistHeight
        $("##{event.data.iframeId}").height(event.data.gistHeight)
      return
    ), false)



Talker.getLastInsertion().find("a").each ->
  if match = /gist.github.com\/(\w+)/.exec(@href)
    endTag = "</" + "script>"
    iframe = $("<iframe>")
    iframeId = "gist" + Math.random().toString().replace(".", "")

    iframe.css("width", "100%")
    iframe[0].id = iframeId
    iframe[0].src = "data:text/html," + encodeURIComponent("""
      <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js">#{endTag}
      <script src="https://gist.github.com/#{match[1]}.js">#{endTag}
      <script>parent.postMessage({gistHeight: $(document).height(), iframeId: "#{iframeId}"}, "*");#{endTag}""")

    $(@).closest("div").append(iframe)

  return
