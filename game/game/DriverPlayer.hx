package game;

class DriverPlayer extends Driver {
  public static var I:DriverPlayer;
  
  public static inline final DEC = .88;
  public static inline final ACC = .3;
  public static inline final MAX = 3;
  public static inline final CDMAX = 20;
  public static inline final LDMAX = 80;
  
  public var sinceShot(get, never):Int;
  private inline function get_sinceShot():Int return CDMAX - cooldown;
  
  public var sinceLever(get, never):Int;
  private inline function get_sinceLever():Int return LDMAX - leverCooldown;
  
  public var cooldown:Int = 0;
  public var leverCooldown:Int = 0;
  
  public function new() {
    super("player");
    I = this;
  }
  
  override public function tick(entity:Entity, state:DriverState, update:EntityUpdate):Void {
    entity.momentumX = (entity.momentumX * DEC + ACC.negpos(inputs.keysHeld[ArrowLeft], inputs.keysHeld[ArrowRight])).clamp(-MAX, MAX);
    entity.momentumY = (entity.momentumY * DEC + ACC.negpos(inputs.keysHeld[ArrowUp], inputs.keysHeld[ArrowDown])).clamp(-MAX, MAX);
    update.vx = entity.momentumX;
    update.vy = entity.momentumY;
    if (inputs.keysHeld[Space] && cooldown == 0) {
      cooldown = CDMAX;
      entity.hp--;
      var loc = entity.locate[ZoneType.Gun];
      GSGame.spawn(new EntityCoin(entity.x + loc.x, entity.y + loc.y, entity.momentumX * .1, entity.momentumY * .1 - 4, true));
      if (leverCooldown == 0) {
        leverCooldown = LDMAX;
      }
    }
    if (cooldown != 0) cooldown--;
    if (leverCooldown != 0) leverCooldown--;
  }
}
