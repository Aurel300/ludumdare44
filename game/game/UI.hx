package game;

class UI {
  public var elements:Map<String, UIElement>;
  public var heldName:String;
  public var heldOriginalX:Int;
  public var heldOriginalY:Int;
  public var heldOffX:Int;
  public var heldOffY:Int;
  public var hoverName:String;
  
  public var click:IObserver<String>;
  var clickEmit:Emitter<String>;
  
  public function new(?elements:Map<String, UIElement>) {
    this.elements = elements != null ? elements : new Map();
    clickEmit = new Emitter();
    click = clickEmit;
  }
  /*
  public function target(el:String, ?x:Float, ?y:Float, ?instant:Bool = false):Void {
    function targetHelper(el:UIElement):Void switch (el) {
      case ImageF(xf, yf, _) | ButtonF(xf, yf, _):
      if (x != null) xf.setTo(x, instant);
      if (y != null) yf.setTo(y, instant);
      case Ref({el: el}): targetHelper(el);
      case _:
    }
    targetHelper(elements[el]);
  }
  public function swap(el:String, b:Bitmap):Void {
    function targetHelper(el:UIElement):UIElement return (switch (el) {
      case ImageF(xf, yf, _): UIElement.ImageF(xf, yf, b);
      case ButtonF(xf, yf, _): UIElement.ButtonF(xf, yf, [b]);
      case Ref({el: el}): UIElement.Ref({el: targetHelper(el)});
      case _: el;
    });
    elements[el] = targetHelper(elements[el]);
  }
  */
  public function keyboard(e:KeyboardEvent):Bool {
    return false;
  }
  
  function over(el:UIElement, mx:Int, my:Int):Bool {
    return (switch (el) {
        case Clickable(x, y, w, h): mx.withinIE(x, x + w) && my.withinIE(y, y + h);
        //case ImageF(x, y, vis):
        //mx.withinIE(x.value.floor(), x.value.floor() + vis.width) && my.withinIE(y.value.floor(), y.value.floor() + vis.height);
        //case ButtonF(x, y, vis):
        //mx.withinIE(x.value.floor(), x.value.floor() + vis[0].width) && my.withinIE(y.value.floor(), y.value.floor() + vis[0].height);
        //case Button(x, y, vis): mx.withinIE(x, x + vis[0].width) && my.withinIE(y, y + vis[0].height);
        //case Ref({el: el}): over(el, mx, my);
      });
  }
  
  public function at(mx:Int, my:Int):String {
    for (e in elements.keys()) if (over(elements[e], mx, my)) return e;
    return null;
  }
  
  public function mouse(e:MouseEvent, ?ox:Int = 0, ?oy:Int = 0):Bool return (switch (e) {
    case Down(mx, my, _) if (hoverName != null):
    mx -= ox;
    my -= oy;
    heldOriginalX = mx;
    heldOriginalY = my;
    heldOffX = 0;
    heldOffY = 0;
    heldName = hoverName;
    true;
    case Up(mx, my, _) if (heldName != null):
    mx -= ox;
    my -= oy;
    if (heldName == hoverName) clickEmit.emit(heldName);
    heldName = null;
    true;
    case Move(mx, my):
    mx -= ox;
    my -= oy;
    if (heldName != null) {
      heldOffX = mx - heldOriginalX;
      heldOffY = my - heldOriginalY;
    }
    hoverName = at(mx, my);
    hoverName != null;
    case _: false;
  });
  /*
  public function render(?ox:Int, ?oy:Int):Void {
    if (ox == null) ox = 0;
    if (oy == null) oy = 0;
    function renderHelper(name:String, el:UIElement):Void switch (el) {
      case Clickable(_, _, _, _):
      case ImageF(xf, yf, vis):
      xf.tick();
      yf.tick();
      var x = xf.value.floor();
      var y = yf.value.floor();
      Platform.window.blitAlpha(ox + x, oy + y, vis);
      case ButtonF(xf, yf, vis):
      xf.tick();
      yf.tick();
      var x = xf.value.floor();
      var y = yf.value.floor();
      var state = (name == heldName ? 1 : 0) + (name == hoverName ? 1 : 0);
      var ustate = state;
      if (state >= vis.length) {
        ustate = 0;
        y += state;
      }
      Platform.window.blitAlpha(ox + x, oy + y, vis[ustate]);
      case Button(x, y, vis):
      var state = (name == heldName ? 1 : 0) + (name == hoverName ? 1 : 0);
      var ustate = state;
      if (state >= vis.length) {
        ustate = 0;
        y += state;
      }
      Platform.window.blitAlpha(ox + x, oy + y, vis[ustate]);
      case Ref({el: el}): renderHelper(name, el);
    }
    for (e in elements.keys()) renderHelper(e, elements[e]);
  }
  */
}
