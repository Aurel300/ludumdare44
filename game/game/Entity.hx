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
  public var offX:Float = 0.0;
  public var offY:Float = 0.0;
  public var xi:Int = 0;
  public var yi:Int = 0;
  public var rem:Bool = false;
  public var actors:Array<Actor> = [];
  public var zones:Array<Zone> = [];
  public var locate:Map<ZoneType, {x:Int, y:Int}> = [];
  
  public var momentumX:Float = 0.0;
  public var momentumY:Float = 0.0;
  public var hp:Int = 0;
  
  public function new(id:String, type:EntityType) {
    this.id = id;
    this.type = type;
  }
  
  function updateLocate(?zones:Array<Zone>):Void {
    if (zones != null) this.zones = zones;
    locate = [ for (zone in zones) zone.type => {x: zone.x + (zone.w >> 1), y: zone.y + (zone.h >> 1)} ];
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
    xi = x.floor();
    yi = y.floor();
    if (hp <= 0) rem = true;
  }
  
  public function collisions(ent:Array<Entity>):Void {
    // TODO: optimise ?
    function collideAll(zone:Zone, onTypes:Array<ZoneType>):Void {
      for (other in ent) if (other != this) {
        for (ozone in other.zones) {
          if (onTypes.indexOf(ozone.type) != -1
              && zone.collide(xi, yi, ozone, other.xi, other.yi)) other.collide(this, ozone.type, zone.type);
        }
      }
    }
    for (zone in zones) collideAll(zone, switch (zone.type) {
        case Attack: [Normal, Collect];
        case _: continue;
      });
  }
  
  public function collide(other:Entity, zone:ZoneType, otherzone:ZoneType):Void {
    if (type.match(Player) && other.type.match(Coin(true))) return;
    switch [zone, otherzone] {
      case [Collect, Attack]: hp++; other.rem = true;
      case [Normal, Attack]:
      var mx = momentumX * 1.7 + other.momentumX * .3;
      var my = momentumY * 1.7 + other.momentumY * .3;
      for (i in 0...5) GSGame.particle(
          other.x, other.y, Choice.nextFloat(-3, 3) + mx, Choice.nextFloat(-3, 3) + my
        );
      hp--; other.rem = true;
      case _:
    }
    update((driver, state, update) -> driver.collide(this, other, zone, otherzone, state, update));
  }
  
  public function render(to:ISurface, ox:Float, oy:Float):Void {
    for (actor in actors) actor.render(to, (x + ox).floor(), (y + oy).floor());
  }
}
