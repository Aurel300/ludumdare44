package game;

class EntityPlayer extends Entity {
  public function new() {
    super("player", Player);
    this.driveWith(["player"]);
    hpRem = false;
    explodePower = 16;
    forwardY = -4.0;
    respawn();
    hurtActors = [0];
    collectActors = [
         {ai: 1, vis: 'player-collect${GI.upCollector}-right'}
        ,{ai: 3, vis: 'player-collect${GI.upCollector}-left'}
      ];
    updateLocate([
         {x: -9, y: -8, w: 17, h: 20, type: Normal}
        ,{x: 8, y: -3, w: [8, 10, 12][GI.upCollector], h: 11, type: Collect}
        ,{x: -25 - [0, 2, 4][GI.upCollector], y: -3, w: [8, 10, 12][GI.upCollector], h: 11, type: Collect}
        ,{x: 0, y: -14, w: 1, h: 1, type: Gun}
      ]);
  }
  
  var armourChance = 0.0;
  
  public function respawn():Void {
    hp = 50;
    iframes = 80;
    this.moveTo(GSGame.GWIDTH / 2, GSGame.GHEIGHT * .75);
    updateActors([
         new Actor(-12, -10, "player-body".visual(GI.upArmour))
        ,new Actor(8, -3, 'player-collect${GI.upCollector}-right'.visual())
        ,new Actor(-8, -15, 'player-gun${GI.upMega}'.visual())
        ,new Actor(-25, -3, 'player-collect${GI.upCollector}-left'.visual())
        ,new Actor(-21, -20, "player-lever".visual())
      ]);
  }
  
  public function requip():Void {
    armourChance = [0, 0.2, 0.4][GI.upArmour];
    actors[0].visual = "player-body".visual(GI.upArmour);
    actors[1].visual = 'player-collect${GI.upCollector}-right'.visual();
    actors[3].visual = 'player-collect${GI.upCollector}-left'.visual();
    actors[2].visual = 'player-gun${GI.upMega}'.visual();
    collectActors = [
         {ai: 1, vis: 'player-collect${GI.upCollector}-right'}
        ,{ai: 3, vis: 'player-collect${GI.upCollector}-left'}
      ];
    updateLocate([
         {x: -9, y: -8, w: 17, h: 20, type: Normal}
        ,{x: 8, y: -3, w: [8, 10, 12][GI.upCollector], h: 11, type: Collect}
        ,{x: -25 - [0, 2, 4][GI.upCollector], y: -3, w: [8, 10, 12][GI.upCollector], h: 11, type: Collect}
        ,{x: 0, y: -14, w: 1, h: 1, type: Gun}
      ]);
  }
  
  override public function hpDelta(delta:Int, ?coinHit:Bool = true):Void {
    if (coinHit && armourChance != 0 && Choice.nextFloat() < armourChance) {
      Sfx.play("side_coin");
      return;
    }
    super.hpDelta(delta, coinHit);
    if (delta > 0) {
      Sfx.play("player_collect");
      GI.score(4 + delta);
      UIHP.add(delta, Normal);
    } else UIHP.drop(-delta);
  }
  
  override public function shoot(from:ZoneType, subtype:CoinType, ?hurtFor:CoinType):Void {
    super.shoot(from, subtype, hurtFor);
    Sfx.play("player_shoot" + (switch (subtype) {
        case Large: "L";
        case Medium: "M";
        case Normal | _: "S";
      }));
  }
  
  override public function render(to:ISurface, ox:Float, oy:Float):Void {
    if (hp > 0) {
      // collect animation
      actors[1].y = actors[3].y = -3 + ((collectShift >> 1) - 4).max(0);
      // gun animation
      actors[2].visual = 'player-gun${GI.upMega}'.visual(
          DriverPlayer.I.sinceShot < 8 ? [1, 1, 2, 2, 2, 3, 3, 1][DriverPlayer.I.sinceShot] :
          0
        );
      // lever animation
      actors[3].visual = "player-lever".visual(
          DriverPlayer.I.sinceLever < 32 ? [1, 1, 1, 1, 2, 2, 2, 3, 3, 3, 4, 4, 4, 5, 5, 5][DriverPlayer.I.sinceLever >> 1] :
          !UISlots.canRoll ? 6 :
          0
        );
      explodePhase = 0;
    }
    super.render(to, ox, oy);
  }
  
  override public function collisions(ent:Array<Entity>):Void {
    super.collisions(ent);
    x = x.clamp(20, GSGame.GWIDTH - 20);
    y = y.clamp(20, GSGame.GHEIGHT - 20);
  }
}
