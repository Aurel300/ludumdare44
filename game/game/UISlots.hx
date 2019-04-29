package game;

class UISlots {
  public static inline final SLOT_COUNT = 3;
  public static inline final SLOT_TYPES = 4;
  public static inline final SLOT_TYPE_HEIGHT = 24.0;
  public static inline final SLOT_LEN = 20;
  public static inline final SLOT_VMIN = 10.0;
  public static inline final SLOT_VIDLE = 0.97;
  public static inline final SLOT_VMAX = 17.3;
  public static inline final SLOT_STICK_DISTANCE = 1.0;
  public static inline final SLOT_TIME = 100;
  
  public static var slotPhase:Int;
  public static var slotPos:Array<Float>;
  public static var slotVelocity:Array<Hyst>;
  public static var slotTypes:Array<Int>;
  public static var slotTypesDecided:Int;
  
  public static var canRoll(get, never):Bool;
  static function get_canRoll():Bool return slotTypesDecided == SLOT_COUNT;
  
  public static function reset():Void {
    slotPhase = 0;
    slotPos = [ for (i in 0...SLOT_COUNT) 0 ];
    slotVelocity = [ for (i in 0...SLOT_COUNT) new Hyst(0, .89, 0) ];
    slotTypes = [ for (i in 0...SLOT_COUNT) 0 ];
    slotTypesDecided = 3;
  }
  
  public static function roll():Void {
    for (i in 0...SLOT_COUNT) {
      slotVelocity[i].setTo(Choice.nextFloat(SLOT_VMIN, SLOT_VMAX));
      slotTypes[i] = -1;
    }
    slotTypesDecided = 0;
    slotPhase = 1;
  }
  
  public static function tick():Void {
    var sticking = 0;
    if (slotPhase != 0) {
      slotPhase++;
      for (i in 0...SLOT_COUNT) {
        var diff = ((i + 1) * SLOT_LEN) - (slotPhase - SLOT_LEN);
        if (diff.within(0, 16)) slotVelocity[i].setTo(SLOT_VIDLE);
        if (diff < 2) sticking = i + 1;
      }
      if (slotPhase >= SLOT_TIME) slotPhase = 0;
    } else {
      sticking = SLOT_COUNT;
    }
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
            Sfx.play("slot_decided");
            if (slotTypesDecided == SLOT_COUNT) GI.slot(slotTypes);
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
  
  public static function render(to:ISurface):Void {
    for (i in 0...SLOT_COUNT) {
      var oy = 0;
      var idx = 0;
      if (DriverPlayer.I.leverCooldown != 0) {
        oy = -1;
        var diff = ((i + 1) * SLOT_LEN) - DriverPlayer.I.sinceLever;
        if (diff < 0) oy = 0;
        else if (diff < 16) idx = [2, 1][diff >> 3];
      }
      "ui-bottom-slot".singletonI('$i', 17 + 26 * i, Main.VHEIGHT - 37 + oy, idx).render(to);
      "ui-slot-icons".singleton(
          17 + 1 + 26 * i, Main.VHEIGHT + 4 - 37 + oy, -1
        ).renderClip(to, 0, 0, 0, (slotPos[i]).floor(), 24, 32);
    }
  }
}
