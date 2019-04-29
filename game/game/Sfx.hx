package game;

class Sfx {
  static var variations:Map<String, Array<String>> = [];
  static var throttles:Map<String, Int> = [
       "hit" => 0
      ,"player_collect" => 0
      ,"enemy_collect" => 0
    ];
  
  public static var enableSound:Bool = true;
  public static var enableMusic:Bool = true;
  
  public static function toggleSound():Void {
    enableSound = !enableSound;
  }
  public static function toggleMusic():Void {
    enableMusic = !enableMusic;
  }
  
  static var musicChannel:plu.audio.IChannel;
  
  public static function music(on:Bool):Void {
    if (on) {
      if (enableMusic) {
        musicChannel = Platform.assets.sounds["music"].play(Forever, .7);
      }
    } else {
      if (musicChannel != null) musicChannel.stop();
    }
  }
  
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
  
  public static function tick():Void {
    for (k in throttles.keys()) if (throttles[k] > 0) throttles[k]--;
  }
  
  public static function playThrottled(base:String, ?vol:Float = 1.0):Void {
    if (throttles[base] != 0) return;
    throttles[base] = 16;
    play(base, vol);
  }
  
  public static function play(base:String, ?vol:Float = 1.0):Void {
    if (!enableSound) return;
#if !(NOSOUND)
    Platform.assets.sounds[Choice.nextElement(variations[base])].play(vol);
#end
  }
}
