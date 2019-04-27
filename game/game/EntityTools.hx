package game;

class EntityTools {
  public static function moveTo(entity:Entity, x:Float, y:Float):Entity {
    entity.x = x;
    entity.y = y;
    return entity;
  }
  
  public static function driveNext(entity:Entity):Void {
    if (entity.nextDrivers == null) {
      entity.nextDrivers = entity.nextDrivers.copy();
      entity.nextStates = entity.nextStates.copy();
    }
    entity.nextDrivers.shift();
    entity.nextStates.shift();
  }
  
  public static function driveWith(entity:Entity, drivers:Array<String>):Entity {
    entity.nextDrivers = drivers.map(Driver.DRIVERS.get);
    entity.nextStates = entity.nextDrivers.map(driver -> driver.initState(entity));
    return entity;
  }
}
