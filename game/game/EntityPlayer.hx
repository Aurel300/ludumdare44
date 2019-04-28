package game;

class EntityPlayer extends Entity {
  public function new(x:Float, y:Float) {
    super("player", Player);
    this.moveTo(x, y);
    this.driveWith(["player"]);
    hp = 90;
    hpRem = false;
    explodePower = 16;
    forwardY = -4.0;
    updateActors([
         new Actor(-20, -20, "player-body".visual())
        ,new Actor(8, -6, "player-collect".visual())
        ,new Actor(-12, -15, "player-gun1".visual())
        ,new Actor(-21, -20, "player-lever".visual())
      ]);
    hurtActors = [0];
    collectActors = [{ai: 1, vis: "player-collect"}];
    updateLocate([
         {x: -9, y: -8, w: 17, h: 20, type: Normal}
        ,{x: 8, y: -3, w: 8, h: 11, type: Collect}
        ,{x: 0, y: -14, w: 1, h: 1, type: Gun}
      ]);
  }
  
  override public function hpDelta(delta:Int):Void {
    super.hpDelta(delta);
    if (delta > 0) {
      GI.score(4 + delta);
      UIHP.add(delta, Normal);
    } else UIHP.drop(-delta);
  }
  
  override public function render(to:ISurface, ox:Float, oy:Float):Void {
    if (hp > 0) {
      // collect animation
      actors[1].y = -6 + ((collectShift >> 1) - 4).max(0);
      // gun animation
      actors[2].visual = "player-gun1".visual(
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
