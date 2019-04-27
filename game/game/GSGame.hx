package game;

class GSGame extends GameState {
  public static var I:GSGame;
  
  public static function spawn(e:Entity):Void I.entities.push(e);
  public static function particle(x:Float, y:Float, vx:Float, vy:Float):Void {
    var actor = new Actor(x.floor() - 12, y.floor() - 12, null);
    I.particles.push({
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
  
  public static final GX = 0;
  public static final GY = 0;
  public static final GWIDTH = 200;
  public static final GHEIGHT = 300 - 35;
  
  public var cameraX = new Hyst(0, 0.9, 0);
  public var cameraY = new Hyst(0, 0.9, 0);
  
  public var entities:Array<Entity>;
  public var player:Entity;
  public var level:Level;
  public var particles:Array<{actor:Actor, x:Float, y:Float, vx:Int, vy:Int, ovx:Float, ovy:Float, ph:Int}> = [];
  
  public function new() {
    I = this;
    // initialise drivers
    new DriverBounds();
    new DriverConstant();
    new DriverPlayer();
  }
  
  public function reset():Void {
    "ui-slot-icons".singleton(0, 0, -1).bmp = Actor.BMP_SLOT_ICONS;
    entities = [
        player = new EntityPlayer(GWIDTH / 2, GHEIGHT / 2)
      ];
    level = Level.playLevel(0);
  }
  
  override public function to(from:GameState):Void {
    reset();
  }
  
  override public function load():Void {
    //Actor.BMP_SOURCE = 
  }
  
  override public function tick(delta:Float):Void {
    level.tick(delta);
    
    if (Choice.nextFloat() < .02) spawn(new EntityCoin(40, 0, 0, 3, false));
    
    js.Browser.document.getElementById("fps").innerText = 'HP: ${player.hp} ENT: ${entities.length} FPS: ${1000.0 / delta}';
    
    for (entity in entities) entity.tick();
    for (entity in entities) entity.collisions(entities);
    entities = entities.filter(e -> !e.rem);
    
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
    
    //"ui-template".singleton(0, Main.VHEIGHT - 37).render(win);
    "ui-bottom1".singleton(0, Main.VHEIGHT - 37).render(win);
    for (i in 0...DriverPlayer.SLOT_COUNT) {
      var oy = 0;
      var idx = 0;
      if (DriverPlayer.I.leverCooldown != 0) {
        oy = -1;
        var diff = ((i + 1) * DriverPlayer.SLOT_LEN) - DriverPlayer.I.sinceLever;
        if (diff < 0) oy = 0;
        else if (diff < 16) idx = [2, 1][diff >> 3];
      }
      "ui-bottom-slot".singletonI('$i', 17 + 26 * i, Main.VHEIGHT - 37 + oy, idx).render(win);
      "ui-slot-icons".singleton(
          17 + 1 + 26 * i, Main.VHEIGHT + 4 - 37 + oy, -1
        ).renderClip(win, 0, 0, 0, (DriverPlayer.I.slotPos[i]).floor(), 24, 32);
    }
  }
}
