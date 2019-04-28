package game;

class EntityEnemy extends Entity {
  public var enemyType:EnemyType;
  
  public function new(type:EnemyType, x:Float, y:Float, ?wave:DriverState) {
    super("enemy", Enemy);
    enemyType = type;
    momentumX = 0;
    momentumY = 2;
    var dwConstant = true;
    var dwBounds = true;
    var dwOther = [];
    hurtActors = [0];
    explodePower = 1;
    explodeLength = 2;
    var normType = type;
    switch (type) {
      case Pop1 | SuPop1:
      hp = 2;
      willShoot = true;
      worth = 50;
      dropCoin = 4;
      updateActors([
           new Actor(0, 8, "enemy-pop1".visual())
          ,new Actor(3, 0, "enemy-collect-top".visual())
        ]);
      updateLocate([
           {x: 3, y: 0, w: 7, h: 9, type: Collect}
          ,{x: 0, y: 8, w: 13, h: 9, type: Normal}
          ,{x: 6, y: 10, w: 1, h: 1, type: Gun}
        ]);
      collectActors = [{ai: 1, vis: "enemy-collect-top"}];
      offX = -13 / 2;
      offY = -17 / 2;
      normType = Pop1;
      case Pop2 | SuPop2:
      hp = 4;
      willShoot = true;
      worth = 100;
      dropCoin = 7;
      updateActors([
           new Actor(0, 8, "enemy-pop2".visual(2))
          ,new Actor(3, 0, "enemy-collect-top".visual())
        ]);
      updateLocate([
           {x: 3, y: 0, w: 7, h: 9, type: Collect}
          ,{x: 0, y: 8, w: 13, h: 9, type: Normal}
          ,{x: 6, y: 10, w: 1, h: 1, type: Gun}
          ,{x: 0, y: 17, w: 13, h: 4, type: Shield}
        ]);
      collectActors = [{ai: 1, vis: "enemy-collect-top"}];
      offX = -13 / 2;
      offY = -21 / 2;
      normType = Pop2;
      case Dropper:
      hp = 20;
      willShoot = true;
      worth = 200;
      dropCoin = 20;
      updateActors([
           new Actor(0, 8, "enemy-dropper".visual())
          ,new Actor(2, 0, "enemy-collect-top".visual())
        ]);
      updateLocate([
           {x: 3, y: 0, w: 7, h: 9, type: Collect}
          ,{x: 0, y: 8, w: 11, h: 16, type: Normal}
          ,{x: 6, y: 10, w: 1, h: 1, type: Gun}
        ]);
      collectActors = [{ai: 1, vis: "enemy-collect-top"}];
      offX = -11 / 2;
      offY = -24 / 2;
      case Claw:
      hp = 30;
      worth = 500;
      dropCoin = 50;
      updateActors([
           new Actor(0, 0, "enemy-claw-stick".visual())
          ,new Actor(0, 15, "enemy-collect-bottom".visual())
        ]);
      updateLocate([
           {x: 0, y: 0, w: 16, h: 20, type: Normal}
          ,{x: 0, y: 15, w: 8, h: 9, type: Collect}
        ]);
      collectActors = [{ai: 1, vis: "enemy-collect-bottom"}];
      offX = -16 / 2;
      offY = -24 / 2;
    }
    suicidal = type.match(SuPop1 | SuPop2);
    enemyType = normType;
    this.driveWith(
        []
        .concat((dwConstant || wave != null) ? [wave != null ? "wave" : "constant"] : [])
        .concat(dwOther)
        .concat(dwBounds? ["bounds"] : [])
        ,wave != null ? [wave] : null
      );
    this.moveTo(x, y); // + offX, y + offY);
  }
  
  var suicidal = false;
  var willShoot = false;
  var wasHit = false;
  
  override public function tick():Void {
    super.tick();
    switch (enemyType) {
      case Pop1 | Pop2:
      var vis = (enemyType.match(Pop1) ? "enemy-pop1" : "enemy-pop2");
      var mlen = (30/* - hp*/).max(20); // too hyper!
      var mphase = (phase + 10) % mlen;
      if (mphase == 0) {
        if (enemyType.match(Pop1) || wasHit) actors[0].visual = vis.visual(0);
        willShoot = (hp > 1 || suicidal);
      }
      if (enemyType.match(Pop2) && !wasHit) willShoot = false;
      if (willShoot && mphase.within(mlen - 20, mlen)) actors[0].visual = vis.visual(mphase % 2);
      if (willShoot && mphase == mlen - 1) shoot(Gun, Normal);
      case Dropper:
      var mlen = 16;
      var mphase = (phase + 5) % mlen;
      if (mphase == mlen - 1) shoot(Gun, Medium);
      case _:
    }
  }
  
  override public function collide(other:Entity, zone:ZoneType, otherzone:ZoneType):Void {
    super.collide(other, zone, otherzone);
    switch [enemyType, zone, otherzone] {
      case [Pop2, Shield, Attack]:
      zones.pop();
      wasHit = true;
      actors[0].visual = "enemy-pop2".visual(0);
      case _:
    }
  }
}
