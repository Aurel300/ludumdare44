package game;

class Sfx {
  static var variations:Map<String, Array<String>> = [];
  static var counter:Int = 0;
  
  public static function load():Loader {
    return [{
        run: () -> {
            for (snd in Platform.assets.sounds.keys()) {
              var base = snd;
              while (base.charCodeAt(base.length - 1).within("0".code, "9".code)) base = base.substr(0, base.length - 1);
              if (!variations.exists(base)) variations[base] = [];
              variations[base].push(snd);
            }
            true;
          }
      }];
  }
  
  public static function tick():Void if (counter > 0) counter--;
  
  public static function play(base:String, ?vol:Float = 1.0):Void {
#if !(NOSOUND)
    if (counter++ > 10) return;
    Platform.assets.sounds[Choice.nextElement(variations[base])].play(vol);
#end
  }
}
