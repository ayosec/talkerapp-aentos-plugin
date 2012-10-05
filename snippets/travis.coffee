
travisLogo = "https://raw.github.com/ayosec/talkerapp-aentos-plugin/master/images/travis.png"

lastInsertion = Talker.getLastInsertion()

if match = /^TRAVIS (START|BUILD) (\{.*\})/.exec(lastInsertion.text())

  action = match[1]
  build = JSON.decode(match[2])

  # Layout

  block = $ "<div>", class: "travis-notification" 
  prefix = if navigator.appCodeName == "Mozilla" then "moz" else "webkit"

  block.
    css("display", "-#{prefix}-box").
    css("-#{prefix}-box-orient", "horizontal")

  otherLogo = lastInsertion.closest("td").find(".vendor-logo:last")

  if otherLogo.is(".travis-logo")
    block.append($("<div>")
      .text(" ")
      .css("display", "inline-block")
      .css("width", "40px"))
  else
    block.append($("<div>")
      .addClass("travis-logo")
      .addClass("vendor-logo")
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


  if action == "BUILD"
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

  else if action == "START"
    content
      .append($("<b>").text("Build started"))
      .append($("<span>").text(" for "))
      .append(
        $("<a>")
          .attr("href", "https://github.com/#{build.repository}")
          .attr("target", "_blank")
          .text(build.repository))
      .append($("<span>").text(" at "))
      .append(
        $("<a>")
          .attr("href", "https://github.com/#{build.repository}/commit/#{build.commit}")
          .attr("target", "_blank")
          .text(build.commit.slice(0, 6)))

  lastInsertion.empty()
  lastInsertion.append(block)
