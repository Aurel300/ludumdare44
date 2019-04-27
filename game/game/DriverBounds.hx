package game;

class DriverBounds extends Driver {
  static inline final MARGIN = 30;
  
  public function new() super("bounds");
  
  override public function tick(entity:Entity, state:DriverState, update:EntityUpdate):Void {
    if (!entity.x.within(-MARGIN, GSGame.GWIDTH + MARGIN)
        || !entity.y.within(-MARGIN, GSGame.GHEIGHT + MARGIN)) update.rem = true;
  }
}
