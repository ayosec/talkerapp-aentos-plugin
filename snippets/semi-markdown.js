
var reCode = /`(\S+(?:\s+\S+)*)`/;
var reBold = /\*(\S+(?:\s+\S+)*)\*/;

var lastInsertion = Talker.getLastInsertion();
lastInsertion.replace(reCode, "<tt style='background: #eee'>$1</tt>");
lastInsertion.replace(reBold, "<strong>$1</strong>");
