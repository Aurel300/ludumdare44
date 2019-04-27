package game;

class ActorVisualTools {
  public static function visual(of:String, ?index:Int = 0):ActorVisual {
    return (switch (of) {
      case "player-body": {x: 0, y: 0, w: 40, h: 40};
      case "player-collect": {x: 0, y: 40 + index * 16, w: 8, h: 16};
      case "player-gun1": {x: 40, y: 40 + index * 16, w: 24, h: 16};
      case "player-lever": {x: 64 + index * 12, y: 40, w: 12, h: 40};
      case "coin1": {x: 0, y: 72 + index * 8, w: 5, h: 5};
      case "coin2": {x: 8, y: 72 + index * 8, w: 6, h: 6};
      case "coin3": {x: 16, y: 72 + index * 8, w: 7, h: 7};
      case "enemy-pop1": {x: 40, y: 0, w: 16, h: 24};
      case "enemy-pop2": {x: 56, y: 0, w: 16, h: 24};
      case "enemy-dispenser": {x: 72, y: 0, w: 16, h: 24};
      case _: throw 'no such visual $of';
    });
  }
  
  public static function withPost(v:ActorVisual, post:Array<ActorPost>):ActorVisual {
    return {x: v.x, y: v.y, w: v.w, h: v.h, post: post};
  }
}
