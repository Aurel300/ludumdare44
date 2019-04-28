package game;

class CoinTypeTools {
  public static function coinValue(of:CoinType):Int {
    return (switch (of) {
        case Normal: 1;
        case _: throw 'invalid coin type $of';
      });
  }
}
