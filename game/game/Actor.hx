package game;

class Actor {
  static var HID = 0;
  public static function hook():Hook return ["actor" => c -> {
      BMP_SOURCE = c;
      PAL = c.cut(0, 104, 32, 1).palette();
      BMP_SLOT_ICONS = Bitmap.fromColour(24, 24 * DriverPlayer.SLOT_COUNT * 2, 0);
      for (i in 0...DriverPlayer.SLOT_COUNT * 2) {
        BMP_SLOT_ICONS.blitAlphaRect(0, i * 24, (i % DriverPlayer.SLOT_COUNT) * 24, 160, 24, 24, BMP_SOURCE);
      }
      BMP_SLOT_ICONS = BMP_SLOT_ICONS.recolour(PAL[2]).under(BMP_SLOT_ICONS, 1, 1);
      BMP_SLOT_ICONS.lock();
      BMP_CACHE = [];
      HID++;
    }];
  
  static var BMP_SOURCE:Bitmap;
  public static var PAL:Array<Colour>;
  public static var BMP_SLOT_ICONS:Bitmap;
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
  
  public function new(x:Int, y:Int, ?visual:ActorVisual) {
    this.x = x;
    this.y = y;
    if (visual != null) set_visual(visual);
  }
  
  public function render(to:ISurface, ?ox:Int = 0, ?oy:Int = 0):Void {
#if JAM_DEBUG
    if (lastHID != HID && visual != null) updateVisual(visual);
#end
    to.blitAlpha(x + ox, y + oy, bmp);
  }
  
  public function renderClip(to:ISurface, ox:Int, oy:Int, sx:Int, sy:Int, sw:Int, sh:Int):Void {
#if JAM_DEBUG
    if (lastHID != HID && visual != null) updateVisual(visual);
#end
    to.blitAlphaRect(x + ox, y + oy, sx, sy, sw, sh, bmp);
  }
}
