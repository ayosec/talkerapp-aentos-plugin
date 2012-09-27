
var snippets = $snippets;

plugin.onMessageInsertion = function(event) {
  for(var i = 0; i < snippets.length; i++) {
    snippets[i](event);
  }
};
