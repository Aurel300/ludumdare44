package game;

class EntityPlayer extends Entity {
  public function new(x:Float, y:Float) {
    super("player", Player);
    this.moveTo(x, y);
    this.driveWith(["player"]);
    actors = [
        new Actor(-8, -8, {x: 0, y: 0, w: 16, h: 16})
      ];
  }
}
