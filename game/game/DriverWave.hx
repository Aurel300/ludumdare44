package game;

class DriverWave extends Driver {
  public function new() super("wave");
  
  override public function tick(entity:Entity, state:DriverState, update:EntityUpdate):Void {
    switch (state) {
      case Wave(w, pos):
      var tmx = 0.0;
      var tmy = 0.0;
      var tmlerp = .4;
      var rprog:Float = (w.prog - pos * w.spacing);
      switch (w.type) {
        case File(dx, dy, _): tmx = dx; tmy = dy;
        case SineFile(dx, dy, amp, wl, wv, _):
        var ph = rprog * wv;
        var sin = Math.sin(ph / wl) * amp;
        var cos = Math.cos(ph / wl) * amp;
        tmx = dx + dy * sin + dx * cos;
        tmy = dy - dx * sin + dy * cos;
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
        case Loop(loops, radius, rdelta, _):
        var startDist = (w.x - (radius > 0 ? -10 : GSGame.GWIDTH + 10)).abs();
        var loopingStart = startDist / w.speed;
        var loopLength = (radius.abs() * 6.2831) / w.speed;
        var loopingEnd = loopingStart + loops * loopLength;
        if (rprog < loopingStart) {
          tmx = radius > 0 ? 1 : -1;
          tmy = 0;
        } else {
          if (rprog > loopingEnd) rprog = loopingEnd;
          var angle = ((rprog - loopingStart) / loopLength) * 6.2831;
          tmx = Math.cos(angle) + Math.sin(angle) * rdelta;
          if (radius < 0) tmx *= -1;
          tmy = Math.sin(angle) - Math.cos(angle) * rdelta;
        }
        case Points(pts, _):
        var tgt = pts[0];
        for (t in 1...pts.length) if (rprog >= pts[t].at) tgt = pts[t];
        var tgtX = tgt.x + GSGame.GWIDTH / 2;
        tmx = (tgtX - entity.x).clamp(-1, 1);
        if ((tgtX - entity.x).abs() < w.speed) entity.x = tgtX;
        tmy = (tgt.y - entity.y).clamp(-1, 1);
        if ((tgt.y - entity.y).abs() < w.speed) entity.y = tgt.y;
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
