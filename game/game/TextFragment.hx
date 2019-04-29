package game;

class TextFragment {
  public static var alpha:Array<String> = "abcdefghijklmnopqrstuvwxyz".split("");
  public static var bases:Map<FontType, Font>;
  public static var fonts:Array<{type:FontType, baseColour:Colour, ?shadowColour:Colour, ?outlineColour:Colour, font:Font}>;
  public static var fontTS:Int->Font;
  
  public static function fontIndex(type:FontType, baseColour:Colour, ?shadowColour:Colour, ?outlineColour:Colour):Int {
    for (i in 0...fonts.length) {
      var font = fonts[i];
      if (font.type == type && font.baseColour == baseColour && font.shadowColour == shadowColour && font.outlineColour == outlineColour) return i;
    }
    var font = bases[type].apply(b -> {
        var o = b.recolour(baseColour).grow(1, 1, 1, 1);
        if (shadowColour != null) o = o.recolour(shadowColour).under(o, 0, 1);
        if (outlineColour != null) o = o.outline(1, outlineColour);
        return o.lock();
      });
    fonts.push({type: type, baseColour:baseColour, shadowColour:shadowColour, outlineColour:outlineColour, font: font});
    return fonts.length - 1;
  }
  
  public static function font(type:FontType, baseColour:Colour, ?shadowColour:Colour, ?outlineColour:Colour):Font {
    return fonts[fontIndex(type, baseColour, shadowColour, outlineColour)].font;
  }
  
  public static function load():Loader {
    return [{
        run: () -> {
            bases = [
                 NS => FontTools.fromBitmap(Platform.assets.bitmaps["ns"], 8, 16).autoKern(1)
                ,NSBold => FontTools.fromBitmap(Platform.assets.bitmaps["nsbold"], 8, 16).autoKern(1)
              ];
              /*
            var titleBase = bases[FontType.NSBold]
              .apply((b) -> b.scaleNN(2.3, 5)
                .grow(1, 1, 1, 10)
                .applyGeometry((x, y) -> [x + y * .2, y])
                .outline(1, Colour.BLACK, false).lock()
              ).autoKern(0);
            titleBase.lineHeight = 50;
            bases[FontType.Title] = titleBase;*/
            fonts = [];
            fontTS = i -> fonts[i].font;
            fontIndex(NS, Colour.fromARGB32(0xFF34332A));
            true;
          }
        ,desc: "Generating fonts ..."
      }];
  }
  
  public static function sizeOf(txt:String):{w:Int, h:Int} {
    return fonts[0].font.size(txt, fontTS);
  }
  
  public var text(default, set):String;
  function set_text(text:String):String {
    if (text != this.text) {
      this.text = text;
      updateAll();
    }
    return text;
  }
  
  var cache(default, null):Array<{w:Int, h:Int, b:Bitmap}> = [];
  
  public function new(?text:String) {
    this.text = text;
  }
  
  function updateAll():Void {
    for (c in cache) c.b = render(c.w, c.h);
  }
  
  function render(w:Int, h:Int):Bitmap {
    var ret = Bitmap.fromColour(w, h, 0);
    fonts[0].font.render(ret, text, fontTS); //, w - 2);
    return ret.lock();
  }
  
  public function size(w:Int, h:Int, ?addToCache:Bool = true):Bitmap {
    for (c in cache) if (c.w == w && c.h == h) return c.b;
    var ret = render(w, h);
    if (addToCache) cache.push({w: w, h: h, b: ret});
    return ret;
  }
  
  public function full(?turn:Int, ?addToCache:Bool = true):Bitmap {
    var fullSize = sizeOf(text);
    var ret = size(fullSize.w + 8, fullSize.h, addToCache);
    if (turn != null) ret = ret.turn(turn).lock();
    return ret;
  }
}
