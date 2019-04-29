package game;

class EntityCoin extends Entity {
  public function new(
     x:Float, y:Float, mx:Float, my:Float
    ,owner:Entity, type:CoinType, drop:Bool
  ) {
    super(drop ? "drop" : (owner == GI.player ? "player-bullet" : "bullet"), Coin);
    if (id == "bullet" && GI.bombTimer > 0) rem = true;
    this.owner = owner;
    this.moveTo(x, y);
    this.driveWith([drop ? "gravity" : "constant", "bounds"]);
    momentumX = mx;
    momentumY = my;
    hp = type.coinValue();
    if (id == "bullet") hp = (hp * [0.5, 1, 2, 3][GI.upBadness]).floor().max(1);
    hpExplode = false;
    var showType = type.showType();
    var size = [5, 6, 7][showType - 1];
    actors = [
        new Actor(0, 0, 'coin${drop ? "" : "-attack"}${showType}'.visual())
      ];
    zones = [
        {x: 0, y: 0, w: size, h: size, type: drop ? Drop : Attack}
      ];
    offX = -size / 2;
    offY = -(size + 8) / 2;
  }
  
  override public function tick():Void {
    super.tick();
    if (id == "bullet" && GI.upBadness == 3) {
      if (GI.player.x > x + 3) x++;
      if (GI.player.x < x - 3) x--;
    }
  }
}
