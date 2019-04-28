package game;

class ActorVisualTools {
  static var SINGLETONS:Map<String, Actor> = [];
  
  public static function singleton(vis:String, x:Int, y:Int, ?index:Int = 0):Actor {
    return singletonI(vis, "", x, y, index);
  }
  
  public static function singletonI(vis:String, post:String, x:Int, y:Int, ?index:Int = 0):Actor {
    var id = vis + post;
    if (!SINGLETONS.exists(id)) SINGLETONS[id] = new Actor(0, 0, index == -1 ? null : visual(vis, index));
    SINGLETONS[id].x = x;
    SINGLETONS[id].y = y;
    if (index != -1) SINGLETONS[id].visual = visual(vis, index);
    return SINGLETONS[id];
  }
  
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
      case "ui-bottom1": {x: 0, y: 120, w: 24, h: 40};
      case "ui-bottom-slot": {x: 24 + index * 32, y: 120, w: 32, h: 40};
      case "ui-slot-icon": {x: 0 + index * 24, y: 160, w: 24, h: 24};
      case "ui-right1": {x: 216, y: 0, w: 24, h: 300 - 9};
      case "ui-right2": {x: 216, y: 300 - 9, w: 24, h: 9};
      case "ui-right-coin": {x: 240, y: 0 + index * 16, w: 24, h: 9};
      case "ui-template": {x: 0, y: 184, w: 177, h: 37};
      case _: throw 'no such visual $of';
    });
  }
  
  public static function withPost(v:ActorVisual, post:Array<ActorPost>):ActorVisual {
    return {x: v.x, y: v.y, w: v.w, h: v.h, post: post};
  }
}
