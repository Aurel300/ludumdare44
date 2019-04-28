package game;

class EntityCoin extends Entity {
  public function new(
     x:Float, y:Float, mx:Float, my:Float
    ,owner:Entity, type:CoinType, drop:Bool
  ) {
    super("coin", Coin);
    this.owner = owner;
    this.moveTo(x, y);
    this.driveWith([drop ? "gravity" : "constant", "bounds"]);
    momentumX = mx;
    momentumY = my;
    hp = type.coinValue();
    hpExplode = false;
    var showType = type.showType();
    var size = [5, 6, 7][showType - 1];
    actors = [
        new Actor(0, 0, 'coin${showType}'.visual())
      ];
    zones = [
        {x: 0, y: 0, w: size, h: size, type: Attack}
      ];
    offX = offY = -size / 2;
  }
}
