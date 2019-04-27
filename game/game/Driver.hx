package game;

class Driver {
  public static var DRIVERS:Map<String, Driver> = [];
  
  private function new(id:String) {
    DRIVERS[id] = this;
  }
  
  public function initState(entity:Entity):DriverState {
    // override
    return null;
  }
  
  public function tick(entity:Entity, state:DriverState, update:EntityUpdate):Void {
    // override
  }
  
  public function collide(entity:Entity, other:Entity, zone:Zone, state:DriverState, update:EntityUpdate):Void {
    // override
  }
}
