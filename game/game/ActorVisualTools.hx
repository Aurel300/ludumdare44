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
      case "player-body": {x: 0, y: 0 + index * 24, w: 24, h: 24};
      case "player-collect0": {x: 72, y: 80 + index * 16, w: 16, h: 16};
      case "player-collect1": {x: 72 + 16, y: 80 + index * 16, w: 16, h: 16};
      case "player-collect2": {x: 72 + 32, y: 80 + index * 16, w: 16, h: 16};
      case "player-gun0": {x: 24, y: 40 + index * 16, w: 16, h: 16};
      case "player-gun1": {x: 24 + 16, y: 40 + index * 16, w: 16, h: 16};
      case "player-gun2": {x: 24 + 32, y: 40 + index * 16, w: 16, h: 16};
      case "player-lever": {x: 72 + index * 12, y: 40, w: 12, h: 40};
      case "coin1": {x: 0, y: 72 + index * 8, w: 5, h: 5};
      case "coin2": {x: 8, y: 72 + index * 8, w: 6, h: 6};
      case "coin3": {x: 16, y: 72 + index * 8, w: 7, h: 7};
      case "enemy-collect-top": {x: 120, y: 80 + index * 16, w: 8, h: 9};
      case "enemy-collect-bottom": {x: 128, y: 80 + index * 16, w: 8, h: 9};
      case "enemy-pop1": {x: 40, y: 0 + index * 16, w: 13, h: 9};
      case "enemy-pop2": {x: 56, y: 0 + index * 13, w: 13, h: 13};
      case "enemy-dropper": {x: 72, y: 0, w: 11, h: 16};
      case "enemy-claw-stick": {x: 72 + index * 16, y: 16, w: 16, h: 24};
      case "enemy-claw-line": {x: 136, y: 0, w: 16, h: 24};
      case "enemy-claw-hook": {x: 136, y: 24, w: 16, h: 16};
      case "enemy-pool": {x: 88, y: 0, w: 27, h: 16};
      case "enemy-pool-ball": {x: 120, y: 0 + index * 4, w: 3, h: 4};
      case "enemy-pool-leg": {x: 120 + index * 2, y: 8, w: 2, h: 4};
      case "enemy-pinball": {x: 152, y: 0, w: 32, h: 34};
      case "enemy-pinball-boss": {x: 184, y: 24 + index * 40, w: 32, h: 34};
      case "enemy-cashbag": {x: 184 + index * 16, y: 0, w: 16, h: 22};
      case "ui-bottom1": {x: 0, y: 120, w: 24, h: 40};
      case "ui-bottom-slot": {x: 24 + index * 32, y: 120, w: 32, h: 40};
      case "ui-slot-icon": {x: 0 + index * 24, y: 160, w: 24, h: 24};
      case "ui-right1": {x: 216, y: 0, w: 24, h: 300 - 9};
      case "ui-right2": {x: 216, y: 300 - 9, w: 24, h: 9};
      case "ui-right-coin": {x: 240, y: 0 + index * 16, w: 24, h: 9};
      case "ui-life": {x: 0 + index * 16, y: 184, w: 16, h: 16};
      case "ui-bomb": {x: 32 + index * 16, y: 184, w: 16, h: 16};
      case "boss-icon": {x: 64, y: 184, w: 16, h: 16};
      case "boss-bar-empty": {x: 80, y: 184, w: 80, h: 8};
      case "boss-bar-full": {x: 80, y: 192, w: 80, h: 8};
      //case "ui-template": {x: 0, y: 184, w: 177, h: 37};
      case "shop-top": {x: 264, y: 0, w: 116, h: 88};
      case "shop-bottom": {x: 264, y: 88, w: 116, h: 96};
      case "shop-button": {x: 384, y: 0 + index * 32, w: 27, h: 27};
      case "shop-slot": {x: 384, y: 96 + index * 48, w: 36, h: 44};
      case "shop-item": {x: 240 + (index & 3) * 32, y: 184 + (index >> 2) * 40, w: 30, h: 38};
      case _: throw 'no such visual $of';
    });
  }
  
  public static function withPost(v:ActorVisual, post:Array<ActorPost>):ActorVisual {
    return {x: v.x, y: v.y, w: v.w, h: v.h, post: post};
  }
  
  public static function withAddedPost(v:ActorVisual, post:Array<ActorPost>):ActorVisual {
    return {x: v.x, y: v.y, w: v.w, h: v.h, post: v.post != null ? v.post.concat(post) : post};
  }
}
