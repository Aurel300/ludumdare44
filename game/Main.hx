import game.*;

class Main {
  public static inline final VWIDTH = 200;
  public static inline final VHEIGHT = 300;
  
  public static function main():Void {
    var g = new jam.Game([
        // "load" => new GSLoad()
        "game" => new GSGame()
      ], {
         window: {width: VWIDTH, height: VHEIGHT, scale: 2}
        ,assets: {
            bitmaps: [
                {alias: "actor", url: "png/actor.png"}
              ]
          }
      });
    g.debugConnect(3001);
    for (hook in [
        Actor.hook()
      ]) {
      for (alias => cb in hook) plu.Platform.assets.fbitmaps[alias].then(cb);
    }
    plu.Platform.assets.allLoaded.then(_ -> g.state("game"));
  }
}
