
travisLogo = "https://raw.github.com/ayosec/talkerapp-aentos-plugin/master/images/travis.png"

lastInsertion = Talker.getLastInsertion()

if match = /^TRAVIS BUILD (.*)/.exec(lastInsertion.text())

  build = JSON.decode(match[1])

  # Layout

  block = $ "<div>", class: "travis-notification" 
  prefix = if navigator.appCodeName == "Mozilla" then "moz" else "webkit"

  block.
    css("display", "-#{prefix}-box").
    css("-#{prefix}-box-orient", "horizontal")

  otherLogo = lastInsertion.closest("td").find("img.github-logo")

  if otherLogo.get(0)
    block.append($("<div>")
      .text(" ")
      .css("display", "inline-block")
      .css("width", "40px"))
  else
    block.append($("<div>")
      .addClass("github-logo")
      .css("background", "url(#{travisLogo}) no-repeat 50% 50%")
      .css("width", "40px")
      .css("height", "40px")
      .css("vertical-align", "top")
      .css("display", "inline-block"))

  content =
    $("<div>")
      .addClass("content")
      .css("-#{prefix}-box-flex", "1")
      .css("vertical-align", "top")
      .css("display", "inline-block")
      .appendTo(block)

  row = $("<div>").appendTo(content)

  if build.number
    $("<a>")
      .attr("href", build.build_url)
      .attr("target", "_blank")
      .css("text-decoration", "none")
      .text("Build #" + build.number)
      .appendTo(row)

    $("<span>")
      .text(" for ")
      .appendTo(row)


  $("<a>")
    .attr("href", build.repository.url)
    .attr("target", "_blank")
    .css("text-decoration", "none")
    .text(build.repository.owner_name + "/" + build.repository.name)
    .appendTo(row)

  row.append($("<span>").text(" ("))
  row.append(
    $("<a>")
      .attr("target", "_blank")
      .css("text-decoration", "none")
      .attr("href", build.compare_url)
      .text("#{build.branch} at #{build.commit.slice(0, 6)}"))
  row.append($("<span>").text(")"))

  time =
    if build.duration > 60
      "#{parseInt(build.duration / 60)}m #{build.duration % 60}s"
    else
      "#{build.duration}s"

  resultColor = if parseInt(build.result) == 0 then "#272" else "#944"

  $("<div>")
    .append(
      $("<span>")
        .width(10)
        .height(10)
        .css("border-radius", "5px")
        .css("display", "inline-block")
        .css("margin-right", "1ex")
        .css("background-color", resultColor))
    .append(
      $("<b>")
        .css("color", resultColor)
        .text(build.result_message ? ""))
    .append(
      $("<span>")
        .css("margin-left", "1ex")
        .css("color", "#777")
        .text(time))
    .appendTo(content)

  lastInsertion.empty()
  lastInsertion.append(block)
