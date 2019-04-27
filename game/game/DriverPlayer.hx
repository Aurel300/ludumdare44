package game;

class DriverPlayer extends Driver {
  public static var I:DriverPlayer;
  
  public static inline final DEC = .88;
  public static inline final ACC = .3;
  public static inline final MAX = 3;
  public static inline final CDMAX = 20;
  public static inline final LDMAX = 100;
  
  public static inline final SLOT_COUNT = 3;
  public static inline final SLOT_TYPES = 3;
  public static inline final SLOT_TYPE_HEIGHT = 24.0;
  public static inline final SLOT_LEN = 20;
  public static inline final SLOT_VMIN = 10.0;
  public static inline final SLOT_VIDLE = 0.97;
  public static inline final SLOT_VMAX = 17.3;
  public static inline final SLOT_STICK_DISTANCE = 1.0;
  
  public var sinceShot(get, never):Int;
  private inline function get_sinceShot():Int return CDMAX - cooldown;
  
  public var sinceLever(get, never):Int;
  private inline function get_sinceLever():Int return LDMAX - leverCooldown;
  
  public var cooldown:Int = 0;
  public var leverCooldown:Int = 0;
  public var slotPos:Array<Float> = [ for (i in 0...SLOT_COUNT) 0 ];
  public var slotVelocity:Array<Hyst> = [ for (i in 0...SLOT_COUNT) new Hyst(0, .89, 0) ];
  public var slotTypes:Array<Int> = [ for (i in 0...SLOT_COUNT) -1 ];
  public var slotTypesDecided = 0;
  
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
      if (leverCooldown == 0 && slotTypesDecided == 3) {
        leverCooldown = LDMAX;
        for (i in 0...SLOT_TYPES) {
          slotVelocity[i].setTo(Choice.nextFloat(SLOT_VMIN, SLOT_VMAX));
          slotTypes[i] = -1;
        }
        slotTypesDecided = 0;
      }
    }
    if (cooldown != 0) cooldown--;
    
    var sticking = 0;
    if (leverCooldown != 0) {
      for (i in 0...SLOT_COUNT) {
        var diff = ((i + 1) * DriverPlayer.SLOT_LEN) - DriverPlayer.I.sinceLever;
        if (diff.within(0, 16)) slotVelocity[i].setTo(SLOT_VIDLE);
        if (diff < 2) sticking = i + 1;
      }
      leverCooldown--;
    } else {
      sticking = SLOT_COUNT;
    }
    trace(slotTypesDecided);
    for (i in 0...SLOT_COUNT) {
      if (slotTypes[i] != -1) continue;
      slotPos[i] = (slotPos[i] + slotVelocity[i].tick()) % (SLOT_TYPES * SLOT_TYPE_HEIGHT);
      if (i < sticking) {
        for (t in 0...SLOT_TYPES) {
          var typePos = t * SLOT_TYPE_HEIGHT;
          var dist = (typePos - slotPos[i]).abs().min((SLOT_TYPES * SLOT_TYPE_HEIGHT + typePos - slotPos[i]).abs());
          if (dist < SLOT_STICK_DISTANCE) {
            slotTypes[i] = t;
            slotPos[i] = typePos;
            slotTypesDecided++;
            slotVelocity[i].setTo(0, true);
            break;
          }
        }/* else {
          slotPos[i] = (slotPos[i] + slotTypes[i] * SLOT_TYPE_HEIGHT) / 2;
          if ((slotPos[i] - slotTypes[i] * SLOT_TYPE_HEIGHT).abs() < 0.5) slotPos[i] = slotTypes[i] * SLOT_TYPE_HEIGHT;
        }*/
      }
    }
  }
}
