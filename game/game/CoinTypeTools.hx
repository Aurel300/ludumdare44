package game;

class CoinTypeTools {
  public static function coinValue(of:CoinType):Int {
    return (switch (of) {
        case Normal: 1;
        case Medium: 3;
        case Large: 10;
        case _: throw 'invalid coin type $of';
      });
  }
  
  public static function showType(of:CoinType):Int {
    return (switch (of) {
        case Normal: 1;
        case Medium: 2;
        case Large: 3;
        case _: throw 'invalid coin type $of';
      });
  }
  
  public static function randomChange(val:Int):Array<CoinType> {
    return [ while (val > 0) {
        if (val >= 10 && Choice.nextBool()) { val -= 10; Large; }
        else if (val >= 3 && Choice.nextBool()) { val -= 3; Medium; }
        else { val--; Normal; }
      } ];
  }
}
