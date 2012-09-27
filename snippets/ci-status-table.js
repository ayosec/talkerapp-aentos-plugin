
var lastInsertion = Talker.getLastInsertion();
var preBlocks = lastInsertion.find("pre:last");
if(preBlocks.length > 0 && Talker.getLastAuthor() == "aentos_hubot") {

  // Check if we are showing a `ci status` block
  var textLines = preBlocks.text().split("\n");
  var lastLineSplitted = textLines[0].split(/\s+/);
  if(lastLineSplitted.length === 3 && lastLineSplitted[1].match(/green|red/i)) {
    var table = $("<table>");
    for(var i = 0; i < textLines.length; i++) {
      var lineItems = textLines[i].split(/\s+/);
      var line = { name: lineItems[0], status: lineItems[1], url: lineItems[2] }

      var row = $("<tr>").css("color", line.status).appendTo(table);
      $("<td>").text(line.name).appendTo(row);
      $("<td>").text(line.status).appendTo(row);

      var ghPath = line.url.replace(/.*:/, "");
      $("<td>").
        appendTo(row).
        append(
          $("<a>").
            text(ghPath).
            attr("target", "_blank").
            attr("href", "https://github.com/" + ghPath));
    }

    table.insertBefore(preBlocks);
    preBlocks.remove();
  }

}
