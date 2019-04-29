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
      case Rapid: [20, 30, 50][currentLevel(of)];
      case Mega: [30, 75][currentLevel(of)];
      case Armour: [35, 90][currentLevel(of)];
      case Collector: [65, 100][currentLevel(of)];
      case Badder: [50, 25, 15][currentLevel(of)];
      case Smoler: [50, 25, 15][currentLevel(of) - 1];
      case Life: currentLevel(of) == 0 ? 5 : 30;
      case Bomb: currentLevel(of) == 0 ? 5 : 30;
    });
  
  public static function tooltip(of:ShopItem):String return (switch (of) {
      case Rapid: '${Tx.gold()}RAPID:${Tx.normal()} shoot faster';
      case Mega: '${Tx.gold()}MEGA:${Tx.normal()} larger bullets';
      case Armour: '${Tx.gold()}ARMOUR:${Tx.normal()} damage resist';
      case Collector: '${Tx.gold()}COLLECTOR:${Tx.normal()} wider funnels';
      case Badder: '${Tx.gold()}BADDER:${Tx.normal()} harder, more score';
      case Smoler: '${Tx.gold()}SMOLER:${Tx.normal()} easier, less score';
      case Life: '${Tx.gold()}LIFE:${Tx.normal()} +1 life';
      case Bomb: '${Tx.gold()}BOMB:${Tx.normal()} +1 bomb';
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
