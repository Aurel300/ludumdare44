package game;

class Actor {
  static var HID = 0;
  public static function hook():Hook return ["actor" => c -> {
      BMP_SOURCE = c;
      BMP_CACHE = [];
      HID++;
    }];
  
  static var BMP_SOURCE:Bitmap;
  static var BMP_CACHE:Map<String, Bitmap> = [];
  
  public static function generate(to:ActorVisual):Bitmap {
    var ret = BMP_SOURCE.cut(to.x, to.y, to.w, to.h);
    if (to.post != null) for (post in to.post) ret = (switch (post) {
      case FlipH: ret.flipH();
      case FlipV: ret.flipV();
      case _: throw 'invalid actor post ${post}';
    });
    return ret.lock();
  }
  
  public var x:Int = 0;
  public var y:Int = 0;
  public var lastHID = 0;
  public var bmp:Bitmap;
  
  private function updateVisual(to:ActorVisual):Void {
    lastHID = HID;
    var id = '${to.x}/${to.y}/${to.w}/${to.h}/${to.post != null ? to.post.join(".") : ""}';
    if (BMP_CACHE.exists(id)) bmp = BMP_CACHE[id];
    else bmp = BMP_CACHE[id] = generate(to);
  }
  
  public var visual(null, set):ActorVisual;
  private function set_visual(to:ActorVisual):ActorVisual {
    updateVisual(to);
    return this.visual = to;
  }
  
  public function new(x:Int, y:Int, visual:ActorVisual) {
    this.x = x;
    this.y = y;
    set_visual(visual);
  }
  
  public function render(to:ISurface, ox:Int, oy:Int):Void {
#if JAM_DEBUG
    if (lastHID != HID) updateVisual(visual);
#end
    to.blitAlpha(x + ox, y + oy, bmp);
  }
}
