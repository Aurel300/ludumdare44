package game;

class EntityCoin extends Entity {
  public function new(x:Float, y:Float, mx:Float, my:Float, player:Bool, subtype:Int, strength:Int) {
    super("coin", Coin(player));
    this.moveTo(x, y);
    this.driveWith(["constant", "bounds"]);
    momentumX = mx;
    momentumY = my;
    hp = strength;
    hpExplode = false;
    var size = [5, 6, 7][subtype - 1];
    actors = [
        new Actor(0, 0, 'coin$subtype'.visual())
      ];
    zones = [
        {x: 0, y: 0, w: size, h: size, type: Attack}
      ];
    offX = offY = -size / 2;
  }
}
