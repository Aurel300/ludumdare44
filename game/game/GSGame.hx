package game;

class GSGame extends GameState {
  public static var I:GSGame;
  
  public static function spawn(e:Entity):Void I.entities.push(e);
  
  public static final GX = 0;
  public static final GY = 0;
  public static final GWIDTH = 200;
  public static final GHEIGHT = 300;
  
  public var cameraX = new Hyst(0, 0.9, 0);
  public var cameraY = new Hyst(0, 0.9, 0);
  
  public var entities:Array<Entity>;
  public var player:Entity;
  public var level:Level;
  
  public function new() {
    I = this;
    // initialise drivers
    new DriverBounds();
    new DriverConstant();
    new DriverPlayer();
  }
  
  public function reset():Void {
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
  }
}
