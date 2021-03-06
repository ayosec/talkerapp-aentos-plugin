
patterns = 0

githubLogo = "https://raw.github.com/ayosec/talkerapp-aentos-plugin/master/images/small-octocat.png"

initializePlugin = ->

  patterns = 
    parsePush: (text) ->
      if matched = /\[(\S+)\] (\S+) pushed (\d+ new commits?) to (\S+) .* (https?:\S*)/.exec(text)
        {
          project: matched[1],
          user: matched[2],
          commitCount: matched[3],
          branch: matched[4],
          url: matched[5]
        }
      else
        false

    parseForcePush: (text) ->
      if matched = /\[(\w+)\] (\S+) force-pushed (\S+) from (\S+) to (\S+) .* (https?.*)/.exec(text)
        {
          project: matched[1]
          user: matched[2],
          branch: matched[3],
          fromCommit: matched[4],
          toCommit: matched[5],
          url: matched[6]
        }
      else
        false

    parseCommit: (text) ->
      if matched = /\[(\S+)\/(\S+)\] (.*) - (\S+) .* (https?.*)/.exec(text)
        {
          project: matched[1],
          branch: matched[2],
          message: matched[3],
          user: matched[4],
          url: matched[5]
        }
      else if matched = /\[(\S+)\/(\S+)\] (.*) - (.+)$/.exec(text)
        {
          project: matched[1],
          branch: matched[2],
          message: matched[3],
          user: matched[4],
        }
      else
        false

    parseNewBranch: (text) ->
      if matched = /\[(\S+)\] (\S+) created (\S+) (.*?) \S+ (http.*)/.exec(text)
        {
          project: matched[1],
          user: matched[2],
          branch: matched[3],
          info: matched[4],
          urlInfo: matched[5]
        }
      else
        false

    parseMerged: (text) ->
      if matched = /\[(\S+)\] (\S+) merged (\S+) into (\S+) \S+ (htt.*)/.exec(text)
        {
          project: matched[1],
          user: matched[2],
          sourceBranch: matched[3]
          branch: matched[4],
          urlDiff: matched[5]
        }
      else
        false

    parseMergePullRequest: (text) ->
      if matched = /\[(\S+)\/(\S+)\] Merge pull request (#\d+) from (\S+) - (.+)/.exec(text)
        {
          project: matched[1],
          branch: matched[2],
          prNumber: matched[3],
          origin: matched[4],
          user: matched[5]
        }
      else
        false

    parseDeletedBranch: (text) ->
      if matched = /\[(\S+)\] (\S+) deleted (\S+) at (\S+) \S* (http\S+)/.exec(text)
        {
          project: matched[1],
          user: matched[2],
          branch: matched[3],
          lastCommit: matched[4],
          lastCommitURL: matched[5]
        }
      else
        false

initializePlugin() if patterns == 0

lastInsertion = Talker.getLastInsertion()
text = lastInsertion.text()

newBlock = ->
  block = $ "<div>", class: "github-notification" 
  prefix = if navigator.appCodeName == "Mozilla" then "moz" else "webkit"

  block.
    css("display", "-#{prefix}-box").
    css("-#{prefix}-box-orient", "horizontal")

  otherLogo = lastInsertion.closest("td").find(".vendor-logo:last")

  block.append($("<span>")
    .addClass("github-logo")
    .addClass("vendor-logo")
    .css("background", "url(#{githubLogo}) no-repeat 50% 50%")
    .css("background-size", "100%")
    .css("margin-right", "20px")
    .css("width", "20px")
    .css("height", "20px")
    .css("vertical-align", "top")
    .css("display", "inline-block"))

  block.append($("<div>")
    .addClass("content")
    .css("-#{prefix}-box-flex", "1")
    .css("vertical-align", "top")
    .css("display", "inline-block"))

  block

refBlock = (data) ->
  $("<span>").
    css("font-size", "90%").
    css("color", "#777").
    append($("<tt>").text(data.branch)).
    append($("<span>").text(" at ")).
    append($("<b>").text(data.project))

block = null
if push = patterns.parsePush(text)
  block = newBlock()
  concat = (string, tag = "span") -> $("<#{tag}>").text(string).appendTo(content)

  content = block.find(".content")
  concat("[PUSH]").css("color", "#777")
  content.append $("<b>").text(push.user)
  concat("pushed")
  content.append $("<a>").text(push.commitCount).attr("href", push.url).attr("target", "_blank")
  content.append("<br>")
  content.append refBlock(push)



else if commit = patterns.parseCommit(text)
  block = newBlock()

  concat = (string, tag = "span") -> $("<#{tag}>").text(string).appendTo(content)

  content = block.find(".content")
  concat("[COMMIT]").css("color", "#777")
  content.append $("<b>").text(commit.user)
  concat("\u2192")

  message =
    if commit.message.length > 60
      commit.message[0..60] + "\u2026"
    else
      commit.message

  if commit.url
    content.append $("<a>").text(message).attr("href", commit.url).attr("target", "_blank")
  else
    concat(message)

  content.append("<br>")
  content.append refBlock(commit)



else if forcePush = patterns.parseForcePush(text)

  block = newBlock()
  concat = (string, tag = "span") -> $("<#{tag}>").text(string).appendTo(content)

  content = block.find(".content")
  concat("[FORCE PUSH]").css("color", "#f33")
  content.append $("<b>").text(forcePush.user)
  concat("pushed")
  concat("from")
  concat(forcePush.fromCommit, "tt").css("color", "#777")
  concat("to")
  concat(forcePush.toCommit, "tt").css("color", "#777")
  content.append("<br>")
  content.append refBlock(forcePush)



else if merged = patterns.parseMerged(text)

  block = newBlock()
  concat = (string, tag = "span") -> $("<#{tag}>").text(string).appendTo(content)

  content = block.find(".content")
  concat("[MERGE]").css("color", "#777")
  content.append $("<b>").text(merged.user)
  concat("merged")
  concat(merged.sourceBranch, "tt").css("color", "#777")
  concat("into")
  concat(merged.branch, "tt").css("color", "#777")
  content.append $("<a>").text("[view diff]").attr("href", merged.urlDiff).attr("target", "_blank")
  content.append("<br>")
  content.append refBlock(merged)



else if newBranch = patterns.parseNewBranch(text)

  block = newBlock()
  concat = (string, tag = "span") -> $("<#{tag}>").text(string).appendTo(content)

  content = block.find(".content")
  concat("[NEW BRANCH]").css("color", "#393")
  content.append $("<b>").text(newBranch.user)
  concat("created")
  concat(newBranch.branch, "b")
  content.append $("<a>").text(newBranch.info).attr("href", newBranch.urlInfo).attr("target", "_blank")
  content.append("<br>")
  content.append refBlock(newBranch)



else if mergePullRequest = patterns.parseMergePullRequest(text)

  block = newBlock()
  concat = (string, tag = "span") -> $("<#{tag}>").text(string).appendTo(content)

  content = block.find(".content")
  concat("[MERGE PULL REQUEST]").css("color", "#393")
  content.append $("<b>").text(mergePullRequest.user)
  concat("merged PR")
  concat(mergePullRequest.prNumber, "tt").css("color", "#777")
  content.append("<br>")
  concat("From", "b")
  concat(mergePullRequest.origin, "tt")
  content.append("<br>")
  content.append refBlock(mergePullRequest)


else if deletedBranch = patterns.parseDeletedBranch(text)

  block = newBlock()
  concat = (string, tag = "span") -> $("<#{tag}>").text(string).appendTo(content)

  content = block.find(".content")
  concat("[DELETE BRANCH]").css("color", "#933")
  content.append $("<b>").text(deletedBranch.user)
  concat("deleted the")
  concat(deletedBranch.branch, "tt").css("color", "#777")
  concat("in")
  concat(deletedBranch.project, "tt").css("color", "#777")
  content.append("<br>")
  concat("It was")
  content.append $("<a>").text(deletedBranch.lastCommit).attr("href", deletedBranch.lastCommitURL).attr("target", "_blank")


if block
  block.find("tt, span:not(.vendor-logo), a, b").css("margin", "auto 0.4ex")
  lastInsertion.empty()
  lastInsertion.append block

  # Disable yellow shadow
  setTimeout (->
    lastInsertion.parents("blockquote").
      css("box-shadow", "0 0 0 0").
      css("background", "white")
  ), 100
