package game;

class DriverConstant extends Driver {
  public function new() super("constant");
  
  override public function tick(entity:Entity, state:DriverState, update:EntityUpdate):Void {
    if (entity.hp > 0) {
      update.vx = entity.momentumX;
      update.vy = entity.momentumY;
    }
  }
}
