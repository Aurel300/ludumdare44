import game.*;

class Main {
  public static function main():Void {
    var g = new jam.Game([
        // "load" => new GSLoad()
        "game" => new GSGame()
      ], {
         window: {width: 200, height: 300, scale: 2}
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
