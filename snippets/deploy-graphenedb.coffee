
grapheneLogo = "http://s3.amazonaws.com/graphenedb-assets-beta/images/favicon.png"

lastInsertion = Talker.getLastInsertion()

if match = /Deploy to (\S+)\/(\S+) started: (http\S+)/.exec(lastInsertion.text())

  repository = match[1]
  environment = match[2]
  url = match[3]

  # Layout

  block = $ "<div>", class: "-notification" 
  prefix = if navigator.appCodeName == "Mozilla" then "moz" else "webkit"

  block.
    css("display", "-#{prefix}-box").
    css("-#{prefix}-box-orient", "horizontal")

  block.append($("<span>")
    .addClass("graphenedb-logo")
    .addClass("vendor-logo")
    .css("background", "url(#{grapheneLogo}) no-repeat 50% 50%")
    .css("background-size", "100%")
    .css("margin-right", "20px")
    .css("width", "20px")
    .css("height", "20px")
    .css("vertical-align", "top")
    .css("display", "inline-block"))

  content =
    $("<div>")
      .addClass("content")
      .css("-#{prefix}-box-flex", "1")
      .css("vertical-align", "top")
      .css("display", "inline-block")
      .appendTo(block)

  content
    .append($("<span>").text("Deploy "))
    .append($("<b>").text(repository))
    .append($("<span>").text(" to "))
    .append($("<b>").text(environment))
    .append(
      $("<a>")
        .css("margin-left", "1em")
        .attr("href", url)
        .attr("target", "_blank")
        .text("Show details"))

  lastInsertion.empty()
  lastInsertion.append(block)
