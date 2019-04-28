package game;

class Driver {
  public static var DRIVERS:Map<String, Driver> = [];
  
  public var id:String;
  
  private function new(id:String) {
    this.id = id;
    DRIVERS[id] = this;
  }
  
  public function initState(entity:Entity):DriverState {
    // override
    return null;
  }
  
  public function tick(entity:Entity, state:DriverState, update:EntityUpdate):Void {
    // override
  }
  
  public function collide(entity:Entity, other:Entity, zone:ZoneType, otherzone:ZoneType, state:DriverState, update:EntityUpdate):Void {
    // override
  }
}
