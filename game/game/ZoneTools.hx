package game;

class ZoneTools {
  public static function contains(a:Zone, ox:Int, oy:Int, x:Int, y:Int):Bool {
    return (a.x + ox) <= x && (a.x + a.w + ox) > x
      && (a.y + oy) <= y && (a.y + a.h + oy) > y;
  }
  
  public static function collide(a:Zone, aox:Int, aoy:Int, b:Zone, box:Int, boy:Int):Bool {
    var ax1 = a.x       + aox;
    var ax2 = a.x + a.w + aox;
    var ay1 = a.y       + aoy;
    var ay2 = a.y + a.h + aoy;
    var bx1 = b.x       + box;
    var bx2 = b.x + b.w + box;
    var by1 = b.y       + boy;
    var by2 = b.y + b.h + boy;
    return !(bx1 >= ax2 || ax1 >= bx2 || by1 >= ay2 || ay1 >= by2);
  }
}
