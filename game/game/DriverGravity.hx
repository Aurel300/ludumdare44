package game;

class DriverGravity extends Driver {
  public function new() super("gravity");
  
  override public function tick(entity:Entity, state:DriverState, update:EntityUpdate):Void {
    if (entity.hp > 0) {
      entity.momentumX *= .93;
      entity.momentumY = (entity.momentumY + .15).min(1.5);
      update.vx = entity.momentumX;
      update.vy = entity.momentumY;
    }
  }
}
