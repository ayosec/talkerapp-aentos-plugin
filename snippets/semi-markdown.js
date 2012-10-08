
var reCode = /`(\S+?(?:\s+\S+?)*?)`/g;
var reBold = /\*(\S+?(?:\s+\S+?)*?)\*/g;

var lastInsertion = Talker.getLastInsertion();
lastInsertion.replace(reCode, "<tt style='background: #eee'>$1</tt>");
lastInsertion.replace(reBold, "<strong>$1</strong>");
