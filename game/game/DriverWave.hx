package game;

class DriverWave extends Driver {
  public function new() super("wave");
  
  override public function tick(entity:Entity, state:DriverState, update:EntityUpdate):Void {
    switch (state) {
      case Wave(w, pos):
      var tmx = 0.0;
      var tmy = 0.0;
      var tmlerp = .4;
      switch (w.type) {
        case File(dx, dy, _): tmx = dx; tmy = dy;
        case Elbow(dx, _):
        tmlerp = .95;
        if (entity.y < w.y) tmy = 1;
        else tmx = dx;
        case Upbow(dx, _):
        tmlerp = .95;
        if (entity.y > w.y) tmy = -1;
        else tmx = dx;
        case Stop:
        tmlerp = 0;
        tmx = (w.x - entity.x).clamp(-1, 1);
        tmy = (w.y - entity.y).clamp(-1, 1);
        if (tmx.abs() < w.speed && tmy.abs() < w.speed) entity.driveNext();
        case StopFor(time):
        tmlerp = 0;
        if (w.prog >= time) tmy = 1;
        else {
          tmx = (w.x - entity.x).clamp(-1, 1);
          if ((w.x - entity.x).abs() < w.speed) entity.x = w.x;
          tmy = (w.y - entity.y).clamp(-1, 1);
          if ((w.y - entity.y).abs() < w.speed) entity.y = w.y;
        }
        case _: tmy = 1;
      }
      entity.momentumX = entity.momentumX.lerp(tmx * w.speed, tmlerp);
      entity.momentumY = entity.momentumY.lerp(tmy * w.speed, tmlerp);
      case _:
    }
    update.vx = entity.momentumX;
    update.vy = entity.momentumY;
  }
}
