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
            ,sounds: [
 {alias: "bomb", url: "wav/bomb.wav"}
,{alias: "claw_launch", url: "wav/claw_launch.wav"}
,{alias: "claw_return", url: "wav/claw_return.wav"}
,{alias: "enemy_collect1", url: "wav/enemy_collect1.wav"}
,{alias: "enemy_collect2", url: "wav/enemy_collect2.wav"}
,{alias: "enemy_collect3", url: "wav/enemy_collect3.wav"}
,{alias: "ex_large1", url: "wav/ex_large1.wav"}
,{alias: "ex_large2", url: "wav/ex_large2.wav"}
,{alias: "ex_small1", url: "wav/ex_small1.wav"}
,{alias: "ex_small2", url: "wav/ex_small2.wav"}
,{alias: "ex_small3", url: "wav/ex_small3.wav"}
,{alias: "game_ok", url: "wav/game_ok.wav"}
,{alias: "game_over", url: "wav/game_over.wav"}
,{alias: "hit1", url: "wav/hit1.wav"}
,{alias: "hit2", url: "wav/hit2.wav"}
,{alias: "hit3", url: "wav/hit3.wav"}
,{alias: "hit4", url: "wav/hit4.wav"}
,{alias: "hit5", url: "wav/hit5.wav"}
,{alias: "player_collect1", url: "wav/player_collect1.wav"}
,{alias: "player_collect2", url: "wav/player_collect2.wav"}
,{alias: "player_collect3", url: "wav/player_collect3.wav"}
,{alias: "player_death", url: "wav/player_death.wav"}
,{alias: "player_shootL", url: "wav/player_shootL.wav"}
,{alias: "player_shootM", url: "wav/player_shootM.wav"}
,{alias: "player_shootS", url: "wav/player_shootS.wav"}
,{alias: "powerup1", url: "wav/powerup1.wav"}
,{alias: "shop_buy", url: "wav/shop_buy.wav"}
,{alias: "shop_close", url: "wav/shop_close.wav"}
,{alias: "shop_open", url: "wav/shop_open.wav"}
,{alias: "shop_poor", url: "wav/shop_poor.wav"}
,{alias: "side_coin1", url: "wav/side_coin1.wav"}
,{alias: "side_coin2", url: "wav/side_coin2.wav"}
,{alias: "side_coin3", url: "wav/side_coin3.wav"}
,{alias: "side_coin4", url: "wav/side_coin4.wav"}
,{alias: "slot_decided1", url: "wav/slot_decided1.wav"}
,{alias: "slot_decided2", url: "wav/slot_decided2.wav"}
,{alias: "slot_decided3", url: "wav/slot_decided3.wav"}
              ]
          }
      });
    g.debugConnect(3001);
    g.state("load");
  }
}
