package game;

class DriverPlayer extends Driver {
  public static var I:DriverPlayer;
  
  public static inline final DEC = .05;
  public static inline final ACC = 3;
  public static inline final MAX = 1.9;
  public static var CDMAX = 20;
  public static inline final LDMAX = 100;
  
  public static inline function cdMax():Int return [20, 17, 13, 9][GI.upRapid];
  
  public static function powerup(type:Powerup):Void {
    Sfx.play("powerup");
    I.powerups.push({len: 300, type: type});
  }
  
  public var powerups:Array<{len:Int, type:Powerup}> = [];
  
  public var sinceShot(get, never):Int;
  private inline function get_sinceShot():Int return cdMax() - cooldown;
  
  public var sinceLever(get, never):Int;
  private inline function get_sinceLever():Int return LDMAX - leverCooldown;
  
  public var cooldown:Int = 0;
  public var leverCooldown:Int = 0;
  
  public function new() {
    super("player");
    I = this;
  }
  
  override public function tick(entity:Entity, state:DriverState, update:EntityUpdate):Void {
    var canControl = entity.hp > 0 && UIShop.showing.isOff;
    
    var shotType = [CoinType.Normal, CoinType.Medium, CoinType.Large][GI.upMega];
    var shotCD = cdMax();
    powerups = [ for (p in powerups) {
        switch (p.type) {
          case MegaShot: shotType = CoinType.Large;
          case RapidFire: shotCD = (cdMax() - 10).max(3);
        }
        if (canControl) p.len--;
        if (p.len == 0) continue;
        p;
      } ];
    
    
    inline function control(original:Float, neg:Bool, pos:Bool):Float {
      return (original * DEC + (canControl ? ACC.negpos(neg, pos) : 0)).clamp(-MAX, MAX);
    }
    if (!UIShop.showing.isOff) {
      var funnelX = 130;
      var funnelY = 56;
      var dx = funnelX - entity.x;
      var dy = funnelY - entity.y;
      entity.momentumX = dx.clamp(-3, 3);
      if (dx.abs() < 3) {
        entity.x = funnelX;
        entity.momentumX = 0;
      }
      entity.momentumY = dy.clamp(-3, 3);
      if (dy.abs() < 3) {
        entity.y = funnelY;
        entity.momentumY = 0;
      }
    } else {
      entity.momentumX = control(entity.momentumX, inputs.keysHeld[ArrowLeft], inputs.keysHeld[ArrowRight]);
      entity.momentumY = control(entity.momentumY, inputs.keysHeld[ArrowUp], inputs.keysHeld[ArrowDown]);
    }
    update.vx = entity.momentumX;
    update.vy = entity.momentumY;
    if (canControl && inputs.keysHeld[Space] && cooldown == 0) {
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
