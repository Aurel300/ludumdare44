package game;

class EntityEnemy extends Entity {
  static var ENE_ID = 0;
  
  public var idn:Int;
  public var enemyType:EnemyType;
  public var boss:Bool;
  public var bossA:Bool;
  public var bossOther:EntityEnemy;
  
  public function new(type:EnemyType, x:Float, y:Float, ?wave:DriverState, ?boss:Bool = false) {
    super("enemy", Enemy);
    this.idn = ENE_ID++;
    enemyType = type;
    this.boss = boss;
    momentumX = 0;
    momentumY = 2;
    var dwConstant = true;
    var dwBounds = !boss;
    var dwOther = [];
    hurtActors = [0];
    explodePower = 1;
    explodeLength = 2;
    var normType = type;
    switch (type) {
      case Pop1 | SuPop1:/**************************************************/
      hp = 2;
      willShoot = true;
      worth = 50;
      dropCoin = 4;
      updateActors([
           new Actor(0, 8, "enemy-pop1".visual())
          ,new Actor(3, 0, "enemy-collect-top".visual())
        ]);
      updateLocate([
          /* {x: 3, y: 0, w: 7, h: 9, type: Collect}
          ,*/{x: 0, y: 8, w: 13, h: 9, type: Normal}
          ,{x: 6, y: 10, w: 1, h: 1, type: Gun}
        ]);
      collectActors = [{ai: 1, vis: "enemy-collect-top"}];
      offX = -13 / 2;
      offY = -17 / 2;
      normType = Pop1;
      case Pop2 | SuPop2:/**************************************************/
      hp = 1;
      willShoot = true;
      worth = 100;
      dropCoin = 7;
      updateActors([
           new Actor(0, 8, "enemy-pop2".visual(2))
          ,new Actor(3, 0, "enemy-collect-top".visual())
        ]);
      updateLocate([
          /* {x: 3, y: 0, w: 7, h: 9, type: Collect}
          ,*/{x: 0, y: 8, w: 13, h: 9, type: Normal}
          ,{x: 6, y: 10, w: 1, h: 1, type: Gun}
          ,{x: 0, y: 17, w: 13, h: 4, type: Shield}
        ]);
      collectActors = [{ai: 1, vis: "enemy-collect-top"}];
      offX = -13 / 2;
      offY = -21 / 2;
      normType = Pop2;
      case Dropper:/********************************************************/
      hp = 5;
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
      case ClawA:/**********************************************************/
      hp = 18;
      worth = 2500;
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
      case ClawB:/**********************************************************/
      hp = 1;
      explodeLength = 60;
      explodePower = 20;
      worth = 0;
      dropCoin = 5;
      updateActors([ for (i in 0...12)
          new Actor(0, i * 24, "enemy-claw-line".visual())
        ].concat([
          new Actor(0, 12 * 24, "enemy-claw-hook".visual())
        ]));
      updateLocate([
           {x: 6, y: 0, w: 4, h: 12 * 24 + 4, type: Blade}
          ,{x: 0, y: 12 * 24 + 4, w: 16, h: 12, type: Blade}
        ]);
      momentumY = 0;
      dwBounds = false;
      hurtActors = [];
      offX = -16 / 2;
      offY = -304;
      case Pool:/***********************************************************/
      hp = 8;
      worth = 100;
      dropCoin = 35;
      updateActors([
           new Actor(0, 0, "enemy-pool".visual())
          ,new Actor(6, 3, "enemy-pool-ball".visual())
          ,new Actor(12, 3, "enemy-pool-ball".visual(1))
          ,new Actor(18, 4, "enemy-pool-ball".visual())
          ,new Actor(1, 12, "enemy-pool-leg".visual())
          ,new Actor(24, 12, "enemy-pool-leg".visual(1))
        ]);
      updateLocate([
          {x: 0, y: 0, w: 27, h: 12, type: Normal}
        ]);
      offX = -27 / 2;
      offY = -12 / 2;
      case Pinball:/********************************************************/
      hp = 30;
      worth = 1000;
      dropCoin = 50;
      updateActors([
           new Actor(0, 0, boss ? "enemy-pinball-boss".visual(idn % 2) : "enemy-pinball".visual())
          ,new Actor(0, 11, "enemy-collect-bottom".visual())
          ,new Actor(25, 11, "enemy-collect-bottom".visual())
        ]);
      updateLocate([
           {x: 8, y: 0, w: 16, h: 34, type: Normal}
          ,{x: 4, y: 18, w: 1, h: 1, type: GunI(0)}
          ,{x: 28, y: 18, w: 1, h: 1, type: GunI(1)}
          ,{x: 0, y: 11, w: 8, h: 9, type: Collect}
          ,{x: 24, y: 11, w: 8, h: 9, type: Collect}
        ]);
      collectActors = [{ai: 1, vis: "enemy-collect-bottom"}, {ai: 2, vis: "enemy-collect-bottom"}];
      offX = -32 / 2;
      offY = -34 / 2;
      case Cashbag | GoldCashbag:/******************************************/
      hp = 1;
      worth = 20;
      dropCoin = 15; // + death()
      updateActors([
          new Actor(0, 0, "enemy-cashbag".visual(type.match(Cashbag) ? 0 : 1))
        ]);
      updateLocate([
          {x: 0, y: 0, w: 16, h: 22, type: type.match(Cashbag) ? Normal : Shield}
        ]);
      offX = -16 / 2;
      offY = -22 / 2;
    }
    if (boss) {
      dwBounds = false;
      explodePower = 20;
      explodeLength = 60;
      hp *= (GI.levelCount == 1 ? 3 : (GI.levelCount == 2 ? 6 : 10));
      worth = GI.levelCount * 10000;
      dropCoin = 70;
    }
    hp = (hp * [0.7, 1.0, 1.4, 2.0][GI.upBadness]).floor().max(1);
    initHp = hp;
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
  var subs:Array<EntityEnemy>;
  var waveOthers:Array<Entity>;
  var playerSight = 0;
  
  override public function spawn(?other:Array<Entity>):Void {
    waveOthers = other;
    if (boss && enemyType.match(Pinball)) {
      bossA = other[0] == this;
      bossOther = cast other[bossA ? 1 : 0];
    }
    
    subs = (switch (enemyType) {
        case ClawA: [new EntityEnemy(ClawB, x + 30, y - 16)];
        case _: null;
      });
    if (subs == null) return;
    for (s in subs) {
      s.owner = this;
      GI.spawn(s);
    }
  }
  
  override public function death():Void {
    if (waveControl && waveOthers != null && waveOthers.length > 1 && !boss) {
      var allDead = true;
      for (o in waveOthers) if (o != this) {
        if (o.hp > 0) {
          allDead = false;
          break;
        }
      }
      if (allDead) {
        GI.score(1000, x, y);
      }
    }
    if (subs != null) for (s in subs) s.hp = 0;
    switch (enemyType) {
      case ClawB: remTimer = 60;
      case Cashbag:
      for (i in 0...(GI.levelCount == 3 ? 0 : 10)) GI.spawn(new EntityCoin(
           x + Choice.nextFloat(-3, 3), y + Choice.nextFloat(-4, 0)
          ,momentumX * .1 + Choice.nextFloat(-2, 2), momentumY * .1 + Choice.nextFloat(-5, -1)
          ,this, Choice.nextBool() ? Large : Medium, true
        ));
      case _:
    }
  }
  
  override public function tick():Void {
    super.tick();
    var player = GI.player;
    if (boss && waveControl) return;
    function towards(tx:Float, ty:Float, lerp:Float, maxSpeed:Float, ?stick:Bool = true):Void {
      if (hp <= 0) return;
      var dx = tx - x;
      var dy = ty - y;
      if (dx.abs() <= maxSpeed && stick) {
        momentumX = 0;
        x = tx;
      } else momentumX = momentumX.lerp(dx.clamp(-maxSpeed, maxSpeed), lerp);
      if (dy.abs() <= maxSpeed && stick) {
        momentumY = 0;
        y = ty;
      } else momentumY = momentumY.lerp(dy.clamp(-maxSpeed, maxSpeed), lerp);
      x += momentumX;
      y += momentumY;
    }
    switch (enemyType) {
      // BOSSES
      case Pool if (boss):
      towards(player.x, player.y, .96, 4, false);
      
      case Pinball if (boss):
      var biasX = bossA ? -4 : 4;
      var otherAlive = !bossOther.rem;
      if (otherAlive) {
        var upper = (phase % 600 < 300) == bossA;
        if (upper) towards(player.x + player.momentumX * 3.0 + biasX, 60, .7, 1);
        else towards(player.x - player.momentumX * 1.0 + biasX, 130, .4, 1.5);
      } else {
        towards(player.x + player.momentumX * 1.0 + biasX, -80 + player.y + player.momentumY * 2.0, .4, 2.5);
      }
      
      var mphase = phase % 20;
      var sight1 = ((x - 12) - player.x).abs();
      var sight2 = ((x + 12) - player.x).abs();
      if (player.hp > 0 && hp > 20 && sight1 < 30 && mphase == 0) shoot(GunI(0), sight1 < 8 ? Large : Medium);
      if (player.hp > 0 && hp > 20 && sight2 < 30 && mphase == 10) shoot(GunI(1), sight2 < 8 ? Large : Medium);
      
      case ClawA:
      var claw = subs[0];
      var distCx = x - claw.x;
      var distCy = y - claw.y;
      var distPx = player.x - claw.x;
      var distPy = player.y - claw.y;
      var cpx = player.x - x;
      momentumX = momentumX.lerp(
          cpx.abs() < 20 ? (
              x < 40 ? .9 :
              x > GSGame.GWIDTH - 40 ? -.9 :
              cpx > 0 ? -.5 : .5
            ) : 0
          ,.9
        );
      x += momentumX;
      x = x.clamp(20, GSGame.GWIDTH - 20);
      var limit = 12 - ((100 - player.y).max(0) * .3);
      var sighted = distPx.abs() <= limit;
      var frame = 0;
      if (!sighted) {
        if (playerSight > 30) Sfx.play("claw_return");
        playerSight = 0;
        if (distCy.abs() < 20) {
          claw.momentumX = claw.momentumX.lerp(distPx.clamp(-2, 2), .93);
          frame = distPx > 0 ? 2 : 1;
        }
        claw.momentumY = claw.momentumY.lerp(distCy.clamp(-5, 1), .93);
      } else {
        playerSight++;
        claw.momentumX = claw.momentumX.lerp(0, .5);
        if (playerSight == 16) Sfx.play("claw_launch");
        if (playerSight > 10) {
          frame = 3;
          claw.momentumY = claw.momentumY.lerp(distPy.clamp(-3, 6), .93);
        }
      }
      actors[0].visual = "enemy-claw-stick".visual(frame);
      
      // REGULAR
      
      case Pop1 | Pop2:
      var vis = (enemyType.match(Pop1) ? "enemy-pop1" : "enemy-pop2");
      var mlen = (30/* - hp*/).max(20); // too hyper!
      var mphase = (phase + 0) % mlen;
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
      case Pool:
      if (Choice.nextFloat() < .05) {
        actors[1].y = Choice.nextBool() ? 4 : 3;
        actors[3].y = 7 - actors[1].y;
      }
      if (Choice.nextFloat() < .05) actors[2].x = 11 + Choice.nextMod(3);
      if (Choice.nextFloat() < .03) actors[4].x = Choice.nextBool() ? 0 : 1;
      if (Choice.nextFloat() < .03) actors[5].x = Choice.nextBool() ? 24 : 25;
      case Pinball:
      var mphase = phase % 20;
      var sight1 = ((x - 12) - player.x).abs();
      var sight2 = ((x + 12) - player.x).abs();
      if (hp > 6 && sight1 < 30 && mphase == 0) shoot(GunI(0), sight1 < 8 ? Large : Medium);
      if (hp > 6 && sight2 < 30 && mphase == 10) shoot(GunI(1), sight2 < 8 ? Large : Medium);
      
      case _:
    }
  }
  
  override public function hpDelta(delta:Int, ?coinHit:Bool = true):Void {
    super.hpDelta(delta);
    if (delta > 0 && coinHit) dropCoin += delta;
  }
  
  override public function collide(other:Entity, zone:ZoneType, otherzone:ZoneType):Void {
    super.collide(other, zone, otherzone);
    switch [enemyType, zone, otherzone] {
      case [Pop2, Shield, Attack]:
      zones.pop();
      wasHit = true;
      actors[0].visual = "enemy-pop2".visual(0);
      other.rem = true;
      case [GoldCashbag, Shield, Attack]:
      if (other.owner == this) return;
      hurtShow = 10;
      for (i in 0...10) GI.spawn(new EntityCoin(
           x + Choice.nextFloat(-3, 3), y + Choice.nextFloat(-4, 0)
          ,momentumX * .1 + Choice.nextFloat(-2, 2), momentumY * .1 + Choice.nextFloat(-5, -1)
          ,this, Choice.nextBool() ? Large : Medium, true
        ));
      other.rem = true;
      case _:
    }
  }
}
