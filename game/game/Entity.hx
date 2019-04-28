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
  
  public var explodePhase:Int = 0;
  public var explodeLength:Int = 0;
  public var explodeActors:Array<ExplodeParticle> = [];
  public var momentumX:Float = 0.0;
  public var momentumY:Float = 0.0;
  public var forwardX:Float = 0.0;
  public var forwardY:Float = 4.0;
  public var hp:Int = 0;
  public var hpRem:Bool = true;
  
  public function new(id:String, type:EntityType) {
    this.id = id;
    this.type = type;
  }
  
  function updateActors(?actors:Array<Actor>):Void {
    if (actors != null) this.actors = actors;
  }
  
  function updateLocate(?zones:Array<Zone>):Void {
    if (zones != null) this.zones = zones;
    locate = [ for (zone in zones) zone.type => {x: zone.x + (zone.w >> 1), y: zone.y + (zone.h >> 1)} ];
  }
  
  public function shoot(from:ZoneType, subtype:Int, strength:Int):Void {
    var loc = locate[from];
    GSGame.spawn(new EntityCoin(x + loc.x, y + loc.y, momentumX * .1 + forwardX, momentumY * .1 + forwardY, true, subtype, strength));
  }
  
  function explode():Void {
    if (explodePhase == 0) {
      explodeLength = 0;
      explodeActors = [ for (actor in actors) {
          var aw = actor.bmp != null ? actor.bmp.width : 1;
          var ah = actor.bmp != null ? actor.bmp.height : 1;
          var ax = actor.x + aw / 2 + offX;
          var ay = actor.y + ah / 2 + offY;
          var area = aw * (actor.bmp != null ? actor.bmp.height : 1);
          var mass = Math.sqrt(area);
          explodeLength += mass.floor();
          {
             x: 0.0
            ,y: 0.0
            ,ax: ax
            ,ay: ay
            ,aw: aw
            ,ah: ah
            ,ox: actor.x
            ,oy: actor.y
            ,vx: ax * (2 / mass) + Choice.nextFloat(-1, 1)
            ,vy: ay * (2 / mass) - 1.5 + Choice.nextFloat(-0.5, 0)
          };
        } ];
    }
    if (explodePhase < explodeLength) {
      for (i in 0...actors.length) {
        if (explodePhase % 4 == 0) for (j in 0...16 - (explodePhase >> 1)) GSGame.particle(
             x + explodeActors[i].ax + Choice.nextFloat(-explodeActors[i].aw, explodeActors[i].aw) * .1
            ,y + explodeActors[i].ay + Choice.nextFloat(-explodeActors[i].ah, explodeActors[i].ah) * .1
            ,-explodeActors[i].vx + Choice.nextFloat(-explodeActors[i].aw, explodeActors[i].aw) * .2
            ,-explodeActors[i].vy + Choice.nextFloat(-explodeActors[i].ah, explodeActors[i].ah) * .2
          );
        actors[i].x = explodeActors[i].ox + explodeActors[i].x.floor();
        actors[i].y = explodeActors[i].oy + explodeActors[i].y.floor();
        explodeActors[i].x += explodeActors[i].vx;
        explodeActors[i].ax += explodeActors[i].vx;
        explodeActors[i].y += explodeActors[i].vy;
        explodeActors[i].ay += explodeActors[i].vy;
        explodeActors[i].vx *= 0.98;
        explodeActors[i].vy += 0.13;
      }
    }
    explodePhase++;
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
    xi = (x + offX).floor();
    yi = (y + offY).floor();
    if (hp <= 0 && hpRem) rem = true;
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
      case [Collect, Attack]:
      hp += other.hp; other.rem = true;
      case [Normal, Attack]:
      var mx = momentumX * 1.7 + other.momentumX * .3;
      var my = momentumY * 1.7 + other.momentumY * .3;
      for (i in 0...5) GSGame.particle(
          other.x, other.y, Choice.nextFloat(-3, 3) + mx, Choice.nextFloat(-3, 3) + my
        );
      hp -= other.hp; other.rem = true;
      case _:
    }
    update((driver, state, update) -> driver.collide(this, other, zone, otherzone, state, update));
  }
  
  public function render(to:ISurface, ox:Float, oy:Float):Void {
    for (actor in actors) actor.render(to, (x + ox + offX).floor(), (y + oy + offY).floor());
  }
}

typedef ExplodeParticle = {
     x:Float
    ,y:Float
    ,ax:Float
    ,ay:Float
    ,aw:Int
    ,ah:Int
    ,ox:Int
    ,oy:Int
    ,vx:Float
    ,vy:Float
  };
