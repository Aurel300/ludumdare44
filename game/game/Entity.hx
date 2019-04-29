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
  public var phase:Int = 0;
  public var hurtShow:Int = 0;
  public var hurtActors:Array<Int> = [];
  public var collectActors:Array<{ai:Int, vis:String}> = [];
  
  public var explodePhase:Int = 4;
  public var explodePower:Int = 0;
  public var explodeLength:Int = 0;
  public var explodeActors:Array<ExplodeParticle> = [];
  public var momentumX:Float = 0.0;
  public var momentumY:Float = 0.0;
  public var forwardX:Float = 0.0;
  public var forwardY:Float = 4.0;
  public var worth:Int = 0;
  public var dropCoin:Int = 0;
  public var hp:Int = 0;
  public var initHp:Int = 0;
  public var hpRem:Bool = true;
  public var hpExplode:Bool = true;
  public var owner:Entity = null;
  public var collectShift:Int = 0;
  public var remTimer:Int = 0;
  public var iframes:Int = 0;
  
  public var waveControl(get, never):Bool;
  private inline function get_waveControl():Bool return drivers.length > 0 && drivers[0].id == "wave";
  
  public function new(id:String, type:EntityType) {
    this.id = id;
    this.type = type;
  }
  
  function updateActors(?actors:Array<Actor>):Void {
    if (actors != null) this.actors = actors;
    explodeLength = 0;
    for (actor in actors) {
      var aw = actor.bmp != null ? actor.bmp.width : 1;
      var ah = actor.bmp != null ? actor.bmp.height : 1;
      var area = aw * ah;
      var mass = Math.sqrt(area);
      explodeLength += mass.floor();
    }
  }
  
  function updateLocate(?zones:Array<Zone>):Void {
    if (zones != null) this.zones = zones;
    locate = [ for (zone in zones) zone.type => {x: zone.x + (zone.w >> 1), y: zone.y + (zone.h >> 1)} ];
  }
  
  public function shoot(from:ZoneType, subtype:CoinType, ?hurtFor:CoinType):Void {
    var loc = locate[from];
    if (hurtFor == null) hurtFor = subtype;
    hp -= hurtFor.coinValue();
    GI.spawn(new EntityCoin(
         x + loc.x + offX, y + loc.y + offY
        ,momentumX * .1 + forwardX, momentumY * .1 + forwardY
        ,this, subtype, false
      ));
  }
  
  public function spawn(?other:Array<Entity>):Void {
    // override
  }
  
  public function death():Void {
    // override
  }
  
  public function hpDelta(delta:Int, ?coinHit:Bool = true):Void {
    hp += delta;
  }
  
  function explode():Void {
    if (explodePhase == 0) {
      if (this == GI.player) Sfx.play("player_death");
      else if (explodePower > 10) Sfx.play("ex_large");
      else Sfx.play("ex_small");
      explodeActors = [ for (actor in actors) {
          var aw = actor.bmp != null ? actor.bmp.width : 1;
          var ah = actor.bmp != null ? actor.bmp.height : 1;
          var ax = actor.x + aw / 2 + offX;
          var ay = actor.y + ah / 2 + offY;
          var area = aw * ah;
          var mass = Math.sqrt(area);
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
        if (explodePhase % 4 == 0) for (j in 0...explodePower - (explodePhase >> 1)) GI.particle(
             x + explodeActors[i].ax + Choice.nextFloat(-explodeActors[i].aw, explodeActors[i].aw) * .1
            ,y + explodeActors[i].ay + Choice.nextFloat(-explodeActors[i].ah, explodeActors[i].ah) * .1
            ,-explodeActors[i].vx + Choice.nextFloat(-explodeActors[i].aw, explodeActors[i].aw) * .2
            ,-explodeActors[i].vy + Choice.nextFloat(-explodeActors[i].ah, explodeActors[i].ah) * .2
          );
        if (i >= explodeActors.length) break;
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
    if (remTimer > 0) {
      remTimer--;
      if (remTimer == 0) rem = true;
    }
    xi = (x + offX).floor();
    yi = (y + offY).floor();
    if (hp <= 0) {
      hp = 0;
      if (this == GI.player) GI.playerDeath();
      if (hpRem && !rem) {
        death();
        if (this != GI.player && worth != 0) GI.score(worth); //, x, y);
        if (this != GI.player && dropCoin != 0) {
          for (c in dropCoin.randomChange()) GI.spawn(new EntityCoin(
             x + Choice.nextFloat(-1, 1), y + Choice.nextFloat(-2, 0)
            ,momentumX * .1 + Choice.nextFloat(-1, 1), momentumY * .1 + Choice.nextFloat(-3, -1)
            ,this, c, true
          ));
        }
        rem = true;
      }
    }
    phase++;
  }
  
  public function collisions(ent:Array<Entity>):Void {
    // TODO: optimise ?
    function collideAll(zone:Zone, onTypes:Array<ZoneType>):Void {
      for (other in ent) if (other != this && other.hp > 0) {
        for (ozone in other.zones) {
          if (onTypes.indexOf(ozone.type) != -1
              && zone.collide(xi, yi, ozone, other.xi, other.yi)) {
            other.collide(this, ozone.type, zone.type);
            break;
          }
        }
      }
    }
    for (zone in zones) collideAll(zone, switch (zone.type) {
        case Attack: [Normal, Collect, Shield];
        case Drop: [Collect];
        case Blade: [Normal, Shield];
        case Normal: [Normal];
        case _: continue;
      });
  }
  
  public function collide(other:Entity, zone:ZoneType, otherzone:ZoneType):Void {
    if (other.owner == this) return;
    switch [zone, otherzone] {
      case [Normal, Normal] if (iframes == 0 && hurtShow <= 4 && this == GI.player):
      Sfx.playThrottled("hit");
      other.hpDelta(-2);
      hpDelta(-2);
      hurtShow += 8;
      case [Collect, Attack | Drop]:
      if (this == GI.player) Sfx.playThrottled("player_collect");
      else Sfx.playThrottled("enemy_collect");
      hpDelta(other.hp);
      collectShift = 14;
      other.rem = true;
      case [Normal, Attack | Blade] if (iframes == 0 && hurtShow <= 4):
      if (this != GI.player && other.owner != GI.player) return;
      Sfx.playThrottled("hit");
      var mx = momentumX * 1.7 + other.momentumX * .3;
      var my = momentumY * 1.7 + other.momentumY * .3;
      for (i in 0...5) GI.particle(
          other.x, other.y, Choice.nextFloat(-3, 3) + mx, Choice.nextFloat(-3, 3) + my
        );
      hpDelta(-other.hp);
      hurtShow += (3 * other.hp).min(40);
      if (otherzone.match(Attack)) other.rem = true;
      case _:
    }
    update((driver, state, update) -> driver.collide(this, other, zone, otherzone, state, update));
  }
  
  public function render(to:ISurface, ox:Float, oy:Float):Void {
    if (iframes > 0) iframes--;
    for (i in hurtActors) actors[i].topTemp(Hurt, hurtShow > 0);
    for (c in collectActors) actors[c.ai].visual = c.vis.visual(collectShift != 0 ? 1 : 0);
    if (hpExplode) {
      if (hp > 0) explodePhase = 0;
      else explode();
    }
    if (iframes % 2 == 0) for (actor in actors) {
      actor.render(to, (x + ox + offX).floor(), (y + oy + offY).floor());
    }
    if (hurtShow > 0) hurtShow--;
    if (collectShift > 0) collectShift--;
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
