package game;

class ShopItemTools {
  // levels including default level
  public static function levels(of:ShopItem):Int return (switch (of) {
      case Rapid: 4;
      case Mega: 3;
      case Armour: 3;
      case Collector: 3;
      case Badder | Smoler: 4;
      case Life: GSGame.MAXLIVES;
      case Bomb: GSGame.MAXBOMBS;
    });
  
  public static function canBuy(of:ShopItem, bought:Int):Bool return (switch (of) {
      case Rapid | Mega | Armour | Badder | Collector: currentLevel(of) < levels(of) - 1 && bought < 2;
      case Smoler: currentLevel(of) > 0 && bought < 2;
      case Life | Bomb: currentLevel(of) < levels(of) - 1 && bought < 3;
    });
  
  public static function buy(of:ShopItem):Void {
    switch (of) {
      case Rapid: GI.upRapid++; GI.player.requip();
      case Mega: GI.upMega++; GI.player.requip();
      case Armour: GI.upArmour++; GI.player.requip();
      case Collector: GI.upCollector++; GI.player.requip();
      case Badder: GI.upBadness++;
      case Smoler: GI.upBadness--;
      case Life: GI.lives++;
      case Bomb: GI.bombs++;
    }
  }
  
  public static function price(of:ShopItem):Int return (switch (of) {
      case Rapid: [10, 20, 30][currentLevel(of)];
      case Mega: [15, 25][currentLevel(of)];
      case Armour: [25, 40][currentLevel(of)];
      case Collector: [25, 40][currentLevel(of)];
      case Badder: [20, 10, 5][currentLevel(of)];
      case Smoler: [20, 10, 5][currentLevel(of) - 1];
      case Life: currentLevel(of) == 0 ? 5 : 20;
      case Bomb: currentLevel(of) == 0 ? 5 : 20;
    });
  
  public static function currentLevel(of:ShopItem):Int return (switch (of) {
      case Rapid: GI.upRapid;
      case Mega: GI.upMega;
      case Armour: GI.upArmour;
      case Collector: GI.upCollector;
      case Badder | Smoler: GI.upBadness;
      case Life: GI.lives;
      case Bomb: GI.bombs;
    });
}
