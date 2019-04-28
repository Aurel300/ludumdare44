package game;

class DriverPlayer extends Driver {
  public static var I:DriverPlayer;
  
  public static inline final DEC = .05;
  public static inline final ACC = 3;
  public static inline final MAX = 1.9;
  public static var CDMAX = 20;
  public static inline final LDMAX = 100;
  
  public static function powerup(type:Powerup):Void {
    I.powerups.push({len: 300, type: type});
  }
  
  public var powerups:Array<{len:Int, type:Powerup}> = [];
  
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
    var shotType = CoinType.Normal;
    var shotCD = CDMAX;
    powerups = [ for (p in powerups) {
        switch (p.type) {
          case MegaShot: shotType = Large;
          case RapidFire: shotCD = 7;
        }
        p.len--;
        if (p.len == 0) continue;
        p;
      } ];
    
    inline function control(original:Float, neg:Bool, pos:Bool):Float {
      return (original * DEC + (entity.hp > 0 ? ACC.negpos(neg, pos) : 0)).clamp(-MAX, MAX);
    }
    entity.momentumX = control(entity.momentumX, inputs.keysHeld[ArrowLeft], inputs.keysHeld[ArrowRight]);
    entity.momentumY = control(entity.momentumY, inputs.keysHeld[ArrowUp], inputs.keysHeld[ArrowDown]);
    update.vx = entity.momentumX;
    update.vy = entity.momentumY;
    if (entity.hp > 0 && inputs.keysHeld[Space] && cooldown == 0) {
      cooldown = shotCD;
      UIHP.drop(1);
      entity.shoot(Gun, shotType, Normal);
      if (leverCooldown == 0 && UISlots.canRoll) {
        leverCooldown = LDMAX;
        UISlots.roll();
      }
    }
    if (cooldown != 0) cooldown--;
    if (leverCooldown != 0) leverCooldown--;
  }
}
