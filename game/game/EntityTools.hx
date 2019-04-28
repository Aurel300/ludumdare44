package game;

class EntityTools {
  public static function moveTo(entity:Entity, x:Float, y:Float):Entity {
    entity.x = x;
    entity.y = y;
    return entity;
  }
  
  public static function driveNext(entity:Entity):Void {
    if (entity.nextDrivers == null) {
      entity.nextDrivers = entity.drivers.copy();
      entity.nextStates = entity.states.copy();
    }
    entity.nextDrivers.shift();
    entity.nextStates.shift();
  }
  
  public static function driveWith(entity:Entity, drivers:Array<String>, ?states:Array<DriverState>):Entity {
    entity.nextDrivers = drivers.map(Driver.DRIVERS.get);
    entity.nextStates = [ for (i in 0...entity.nextDrivers.length) {
        if (states != null && i < states.length && states[i] != null) states[i];
        else entity.nextDrivers[i].initState(entity);
      } ];
    return entity;
  }
}
