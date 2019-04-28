package game;

class Actor {
  static function reload():Void {
    var c = Platform.assets.bitmaps["actor"];
    BMP_SOURCE = c;
    PAL = c.cut(0, 104, 64, 1).palette();
    BMP_SLOT_ICONS = Bitmap.fromColour(24, 24 * UISlots.SLOT_TYPES * 2, 0);
    for (i in 0...UISlots.SLOT_TYPES * 2) {
      BMP_SLOT_ICONS.blitAlphaRect(0, i * 24, (i % UISlots.SLOT_TYPES) * 24, 160, 24, 24, BMP_SOURCE);
    }
    BMP_SLOT_ICONS = BMP_SLOT_ICONS.recolour(PAL[2]).under(BMP_SLOT_ICONS, 1, 1);
    BMP_SLOT_ICONS.lock();
    if (PARTICLES == null) {
      PARTICLES = [];
      var curve = c.getRect(0, 88, 16, 16);
      var ci = 0;
      var steps = [ for (y in 0...16) {
          var min = 16;
          var max = 0;
          for (x in 0...16) if (!curve[ci++].transparent) {
            min = min.min(x);
            max = max.max(x);
          }
          [min, max];
        } ];
      for (vy in -3...4) for (vx in -4...5) {
        var rvx:Float = vx;
        var rvy:Float = vy;
        var x = 0.0;
        var y = 0.0;
        var pos = [ for (t in 0...16) {
            x += vx * .2;
            y += rvy * .2;
            rvx *= .9;
            rvy += 0.45;
            {x: x, y: y};
          } ];
        for (t in 0...16) {
          var vec = new Vector<Colour>(24 * 24);
          for (i in steps[t][0]...steps[t][1] + 1) {
            var p = pos[i];
            var px = (p.x + 12).floor();
            var py = (p.y + 12).floor();
            if (!px.withinIE(0, 24) || !py.withinIE(0, 24)) continue;
            vec[px + py * 24] = PAL[i == steps[t][1] ? 11 : 9];
          }
          PARTICLES['${vy}/${vx}/${t}'] = Bitmap.fromVector(24, 24, vec).outline(1, PAL[(11 - (t >> 1)).max(6)], false).lock();
        }
      }
    }
    BMP_CACHE = [];
    HID++;
  }
  
  static var HID = 0;
  public static function hook():Hook return ["actor" => reload];
  public static function load():Loader {
    return [{
         run: () -> { reload(); true; }
        ,desc: "Generating actors ..."
      }];
  }
  
  static var BMP_SOURCE:Bitmap;
  public static var PAL:Array<Colour>;
  public static var PARTICLES:Map<String, Bitmap> = null;
  public static var BMP_SLOT_ICONS:Bitmap;
  static var BMP_CACHE:Map<String, Bitmap> = [];
  
  public static function generate(to:ActorVisual):Bitmap {
    var ret = BMP_SOURCE.cut(to.x, to.y, to.w, to.h);
    if (to.post != null) for (post in to.post) ret = (switch (post) {
      case FlipH: ret.flipH();
      case FlipV: ret.flipV();
      case Hurt: ret.recolour(PAL[5]);
      case _: throw 'invalid actor post ${post}';
    });
    return ret.lock();
  }
  
  public var x:Int = 0;
  public var y:Int = 0;
  public var hide:Bool = false;
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
  
  var tempStack:Array<{prev:ActorVisual, eff:ActorPost}> = [];
  public function topTemp(eff:ActorPost, on:Bool):Void {
    if (on) {
      if (tempStack.length == 0 || tempStack[0].eff != eff) {
        tempStack.unshift({prev: visual, eff: eff});
        set_visual(visual.withAddedPost([eff]));
      }
    } else {
      if (tempStack.length != 0 && tempStack[0].eff == eff) {
        set_visual(tempStack.shift().prev);
      }
    }
  }
  
  public function new(x:Int, y:Int, ?visual:ActorVisual) {
    this.x = x;
    this.y = y;
    if (visual != null) set_visual(visual);
  }
  
  public function particle(vx:Int, vy:Int, t:Int):Actor {
#if JAM_DEBUG
    if (!vy.within(-3, 3) || !vx.within(-4, 4) || !t.within(0, 15)) throw "invalid particle";
#end
    bmp = PARTICLES['${vy}/${vx}/${t}'];
    return this;
  }
  
  public function render(to:ISurface, ?ox:Int = 0, ?oy:Int = 0):Void {
#if JAM_DEBUG
    if (lastHID != HID && visual != null) updateVisual(visual);
#end
    if (!hide && (x + ox).withinIE(-bmp.width, Main.VWIDTH) && (y + oy).withinIE(-bmp.height, Main.VHEIGHT))
      to.blitAlpha(x + ox, y + oy, bmp);
  }
  
  public function renderClip(to:ISurface, ox:Int, oy:Int, sx:Int, sy:Int, sw:Int, sh:Int):Void {
#if JAM_DEBUG
    if (lastHID != HID && visual != null) updateVisual(visual);
#end
    if (!hide) to.blitAlphaRect(x + ox, y + oy, sx, sy, sw, sh, bmp);
  }
}
