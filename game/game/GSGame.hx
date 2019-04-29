package game;

class GSGame extends GameState {
  public static var I:GSGame;
  
  public static final GX = 0;
  public static final GY = 0;
  public static final GWIDTH = 200 - 24;
  public static final GHEIGHT = 300 - 35;
  public static final MAXLIVES = 6;
  public static final MAXBOMBS = 6;
  
  public function playerDeath():Void {
    if (playerAlive) {
      Sfx.play("player_death");
      lives--;
      player.hp = 0;
      playerAlive = false;
    }
  }
  public function slot(types:Array<Int>):Void {
    var tcount = [ for (i in 0...UISlots.SLOT_TYPES) 0 ];
    var highest = 0;
    for (t in types) {
      tcount[t]++;
      highest = highest.max(tcount[t]);
    }
    if (highest == types.length) {
      switch (types[0]) {
        case 0: DriverPlayer.powerup(MegaShot); // cherry
        case 1: DriverPlayer.powerup(RapidFire); // seven
        case 2: lives++; // life
        case 3: bombs++; // bomb
      }
    } else {
      score([0, 50, 500][highest]);
    }
  }
  public function spawn(e:Entity):Void {
    entities.push(e);
    e.spawn();
  }
  public function score(add:Float, ?x:Float, ?y:Float):Void {
    scoreCount += add * [.6, .8, 1.0, 1.2, 1.4][upBadness];
    // TODO: bonus announce
  }
  public function particle(x:Float, y:Float, vx:Float, vy:Float):Void {
    var actor = new Actor(x.floor() - 12, y.floor() - 12, null);
    particles.push({
         actor: actor
        ,x: x
        ,y: y
        ,vx: vx.floor().clamp(-4, 4)
        ,vy: vy.floor().clamp(-3, 3)
        ,ovx: vx * .3
        ,ovy: vy * .3
        ,ph: 0
      });
  }
  
  public var cameraX = new Hyst(0, 0.9, 0);
  public var cameraY = new Hyst(0, 0.9, 0);
  
  public var entities:Array<Entity>;
  public var player:EntityPlayer;
  public var level:Level;
  public var particles:Array<{actor:Actor, x:Float, y:Float, vx:Int, vy:Int, ovx:Float, ovy:Float, ph:Int}>;
  public var scoreCount:Float;
  public var playerAlive:Bool;
  
  // stats and upgrades
  public var lives:Int;
  public var bombs:Int;
  public var upRapid:Int;
  public var upMega:Int;
  public var upArmour:Int;
  public var upBadness:Int;
  public var upCollector:Int;
  
  public function new() {
    I = this;
    // initialise drivers
    new DriverBounds();
    new DriverConstant();
    new DriverGravity();
    new DriverPlayer();
    new DriverWave();
  }
  
  public function reset():Void {
    lives = 3;
    bombs = 2;
    upRapid = 0;
    upMega = 0;
    upArmour = 0;
    upBadness = 0;
    upCollector = 0;
    
    "ui-slot-icons".singleton(0, 0, -1).bmp = Actor.BMP_SLOT_ICONS;
    entities = [
        player = new EntityPlayer(GWIDTH / 2, GHEIGHT / 2)
      ];
    //level = Level.playLevel(0);
    particles = [];
    scoreCount = 0;
    playerAlive = true;
    
    UIHP.reset(player);
    UIShop.reset();
    UISlots.reset();
    UITop.reset();
    UIShop.show(true, 1);
  }
  
  override public function to(from:GameState):Void {
    reset();
  }
  
  override public function load():Void {
    
  }
  
  override public function mouse(e:MouseEvent):Void UIShop.mouse(e);
  
  override public function tick(delta:Float):Void {
    if (level != null) level.tick(delta);
    
    js.Browser.document.getElementById("fps").innerText = 'HP: ${player.hp} ENT: ${entities.length} FPS: ${1000.0 / delta}';
    
    for (entity in entities) entity.tick();
    for (entity in entities) entity.collisions(entities);
    entities = entities.filter(e -> {
        if (e.hpExplode && e.hp <= 0 && e.explodePhase < e.explodeLength) true;
        else !e.rem;
      });
    
    win.fill(Colour.fromARGB32(0xFFAA0000));
    for (entity in entities) entity.render(win, GX + cameraX.tick(), GY + cameraY.tick());
    
    particles = [ for (p in particles) {
        p.actor.particle(p.vx, p.vy, p.ph >> 1).render(win);
        p.x += p.ovx;
        p.y += p.ovy;
        p.actor.x = p.x.floor() - 12;
        p.actor.y = p.y.floor() - 12;
        if (++p.ph >= 32) continue;
        p;
      } ];
    
    Sfx.tick();
    UIHP.tick();
    UIShop.tick();
    UISlots.tick();
    UITop.tick();
    
    //"ui-template".singleton(0, Main.VHEIGHT - 37).render(win);
    UIShop.render(win);
    UIHP.render(win);
    UITop.render(win);
    "ui-bottom1".singleton(0, Main.VHEIGHT - 37).render(win);
    UISlots.render(win);
  }
}
