import game.*;

class Main {
  public static inline final VWIDTH = 200;
  public static inline final VHEIGHT = 300;
  
  public static function main():Void {
    var g = new jam.Game([
         "load" => new GSLoad()
        ,"game" => new GSGame()
      ], {
         window: {width: VWIDTH, height: VHEIGHT, scale: 2}
        ,assets: {
            bitmaps: [
                 {alias: "actor", url: "png/actor.png"}
                ,{alias: "ns", url: "png/ns8x16.png"}
                ,{alias: "nsbold", url: "png/nsbold8x16.png"}
              ]
          }
      });
    g.debugConnect(3001);
    g.state("load");
  }
}
