package game;

class Tx {
  public static inline function normal():String return "$t" + TextFragment.fontIndex(NS, Actor.PAL[3], Actor.PAL[1], Actor.PAL[0]).hex(2);
  public static inline function bold():String return "$t" + TextFragment.fontIndex(NSBold, Actor.PAL[3], Actor.PAL[1], Actor.PAL[0]).hex(2);
  public static inline function gold():String return "$t" + TextFragment.fontIndex(NSBold, Actor.PAL[10], null, Actor.PAL[6]).hex(2);
  //public static inline function title():String return "$t" + TextFragment.fontIndex(Title, Actor.PAL[1], Actor.PAL[4], Actor.PAL[5]).hex(2);
  public static inline function baseX(at:Int):String return "$b" + (at).hex(2);
  public static inline function setX(at:Int):String return "$x" + (at).hex(2);
  public static inline function setY(at:Int):String return "$y" + (at).hex(2);
  public static inline function center(txt:String, fillW:Int):String return setX((fillW - TextFragment.sizeOf(txt).w) >> 1) + txt;
  public static function formatTime(timer:Int):String {
    var secs = Std.int(timer / 60);
    var mins = Std.int(secs / 60);
    var ms = Std.string(mins).lpad("0", 2);
    var ss = Std.string(secs % 60).lpad("0", 2);
    var ts = Std.string(timer % 60).lpad("0", 2);
    return '${ms}:${ss}:$ts';
  }
}
