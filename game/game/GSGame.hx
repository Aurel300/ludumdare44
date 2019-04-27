package game;

class GSGame extends GameState {
  public static final GX = 0;
  public static final GY = 0;
  public static final GWIDTH = 200;
  public static final GHEIGHT = 300;
  
  public var cameraX = new Hyst(0, 0.9, 0);
  public var cameraY = new Hyst(0, 0.9, 0);
  
  public var entities:Array<Entity>;
  public var player:Entity;
  
  public function new() {
    // initialise drivers
    new DriverPlayer();
  }
  
  public function reset():Void {
    entities = [
        player = new EntityPlayer(GWIDTH / 2, GHEIGHT / 2)
      ];
  }
  
  override public function to(from:GameState):Void {
    reset();
  }
  
  override public function load():Void {
    //Actor.BMP_SOURCE = 
  }
  
  override public function tick(delta:Float):Void {
    js.Browser.document.getElementById("fps").innerText = '${1000.0 / delta}';
    
    for (entity in entities) entity.tick();
    
    win.fill(Colour.fromARGB32(0xFFAA0000));
    for (entity in entities) entity.render(win, GX + cameraX.tick(), GY + cameraY.tick());
  }
}
