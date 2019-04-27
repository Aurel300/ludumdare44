package game;

class EntityCoin extends Entity {
  public function new(x:Float, y:Float, mx:Float, my:Float, player:Bool) {
    super("coin", Coin(player));
    this.moveTo(x, y);
    this.driveWith(["constant", "bounds"]);
    momentumX = mx;
    momentumY = my;
    hp = 1;
    actors = [
        new Actor(-2, -2, "coin1".visual())
      ];
    zones = [
        {x: -2, y: -2, w: 4, h: 4, type: Attack}
      ];
  }
}
