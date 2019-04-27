package game;

class Entity {
  public var drivers:Array<Driver> = [];
  public var states:Array<DriverState> = [];
  public var nextDrivers:Array<Driver>;
  public var nextStates:Array<DriverState> = [];
  
  public var id:String;
  public var type:EntityType;
  public var x:Float = 0.0;
  public var y:Float = 0.0;
  public var rem:Bool = false;
  public var actors:Array<Actor> = [];
  public var zones:Array<Zone> = [];
  
  public function new(id:String, type:EntityType) {
    this.id = id;
    this.type = type;
  }
  
  private function update(f:Driver->DriverState->EntityUpdate->Void):Void {
    var update:EntityUpdate = {
         vx: 0.0
        ,vy: 0.0
        ,rem: false
      };
    for (i in 0...drivers.length) f(drivers[i], states[i], update);
    x += update.vx;
    y += update.vy;
    if (update.rem) rem = true;
    if (nextDrivers != null) {
      drivers = nextDrivers;
      states = nextStates;
      nextDrivers = null;
      nextStates = null;
    }
  }
  
  public function tick():Void {
    update((driver, state, update) -> driver.tick(this, state, update));
  }
  
  public function collide(other:Entity, zone:Zone):Void {
    update((driver, state, update) -> driver.collide(this, other, zone, state, update));
  }
  
  public function render(to:ISurface, ox:Float, oy:Float):Void {
    for (actor in actors) actor.render(to, (x + ox).floor(), (y + oy).floor());
  }
}
