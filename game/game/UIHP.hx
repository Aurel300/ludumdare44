package game;

class UIHP {
  public static inline final ADD_INTERVAL = 10;
  public static inline final DROP_INTERVAL = 7;
  
  public static var coins:Array<UIHPCoin> = [];
  static var addPending:Array<CoinType> = [];
  static var dropValue:Int = 0;
  static var coinAddPhase = 0;
  static var coinDropPhase = 0;
  static var flying = 10000;
  
  public static function add(num:Int, type:CoinType):Void {
    for (i in 0...num) addPending.push(type);
  }
  
  public static function drop(value:Int):Void {
    dropValue += value;
  }
  
  public static function bounce():Void {
    for (i in 0...5.min(coins.length)) coins[0].vy = -3 + Choice.nextFloat(0, 1);
  }
  
  public static function reset(player:EntityPlayer):Void {
    add(player.hp, Normal);
  }
  
  public static function render(to:ISurface):Void {
    "ui-right1".singleton(Main.VWIDTH - 24, 0).render(to);
    for (coin in coins) {
      coin.actor.render(to, Main.VWIDTH - 24, 0);
    }
    "ui-right2".singleton(Main.VWIDTH - 24, 300 - 9).render(to);
  }
  
  public static function tick():Void {
    if (addPending.length > 0 && coins.length < 96) {
      if (coinAddPhase == 0 || (addPending.length > 10 && coinAddPhase < ADD_INTERVAL - 3)) {
        coins.push({
             actor: new Actor(0, -4, "ui-right-coin".visual())
            ,dark: false
            ,y: -4
            ,vy: 1
            ,type: addPending.shift()
          });
        coinAddPhase = ADD_INTERVAL;
      }
    }
    if (dropValue > 0 && coins.length > 0) {
      if (dropValue >= coins[0].type.coinValue()) {
        dropValue -= coins[0].type.coinValue();
        coins.shift();
        coinDropPhase = DROP_INTERVAL;
      }
    }
    if (coinAddPhase > 0) coinAddPhase--;
    if (coinDropPhase > 0) coinDropPhase--;
    
    var maxY:Float = 300 - 5 - 9;
    var nextFlying = 0;
    for (i in 0...coins.length) {
      var coin = coins[i];
      coin.y += coin.vy;
      if (coin.vy.abs() > 2) nextFlying++;
      if (coin.y > maxY) {
        if (coin.vy > 2.5 && Choice.nextFloat() < 1 / (1 + flying)) Sfx.play("side_coin");
        if (coin.vy > .5) coin.vy = -coin.vy * (coins.length - i > 5 ? .2 : .86);
        else coin.vy = 0;
        coin.y = maxY;
      }
      coin.actor.y = coin.y.floor();
      maxY = coin.y - 3;
      coin.vy = (coin.vy + 0.8).min(4.5);
      var dark = (i > 0 && coin.y - coins[i - 1].y < 5);
      if (coin.dark != dark) {
        coin.actor.visual = "ui-right-coin".visual(dark ? 1 : 0);
        coin.dark = dark;
      }
    }
    flying = nextFlying;
  }
}

typedef UIHPCoin = {
     actor:Actor
    ,dark:Bool
    ,y:Float
    ,vy:Float
    ,type:CoinType
  };
