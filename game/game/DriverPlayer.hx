package game;

class DriverPlayer extends Driver {
  static inline final DEC = .88;
  static inline final ACC = .3;
  static inline final MAX = 3;
  
  public function new() super("player");
  
  override public function initState(entity:Entity):DriverState {
    return Momentum({vx: 0, vy: 0});
  }
  
  override public function tick(entity:Entity, state:DriverState, update:EntityUpdate):Void {
    switch (state) {
      case Momentum(m):
      m.vx = (m.vx * DEC + ACC.negpos(inputs.keysHeld[ArrowLeft], inputs.keysHeld[ArrowRight])).clamp(-MAX, MAX);
      m.vy = (m.vy * DEC + ACC.negpos(inputs.keysHeld[ArrowUp], inputs.keysHeld[ArrowDown])).clamp(-MAX, MAX);
      update.vx = m.vx;
      update.vy = m.vy;
      case _:
    }
  }
}
