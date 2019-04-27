package game;

class Level {
  static function makeWaves(waveSpecs:Array<WaveSpec>):Array<Wave> {
    var pos = 0.0;
    var out = [ for (spec in waveSpecs) {
        switch (spec) {
          case MW: pos += 0.01; continue;
          case Wait(secs): pos += secs; continue;
          case At(secs): pos = secs; continue;
          case _:
        }
        var type:Null<Wave.WaveType> = null;
        var x:Float = GSGame.GWIDTH / 2;
        var y:Float = -10.0;
        var finished:Level->Wave->Void = null;
        var suspend:Null<Bool> = null;
        var speed:Null<Float> = null;
        function handleSpec(s:WaveSpec):Void {
          switch (s) {
            case MW | Wait(_) | At(_): throw '$s only valid at root';
            case Type(st): type = st;
            case LocX(sx, ss): x = GSGame.GWIDTH / 2 + sx; handleSpec(ss);
            case LocY(sy, ss): y = sy; handleSpec(ss);
            case Loc(sx, sy, ss): x = sx; y = sy; handleSpec(ss);
            case Suspend(ss): suspend = true; handleSpec(ss);
            case Speed(sp, ss): speed = sp; handleSpec(ss);
          }
        }
        handleSpec(spec);
        if (type == null) throw "no type for wave";
        {
           type: type
          ,x: x
          ,y: y
          ,at: pos
          ,finished: finished
          ,suspend: suspend
          ,speed: speed
        }
      } ];
    out.sort((a, b) -> a.at < b.at ? -1 : 1);
    return out;
  }
  
  static var levels:Array<LevelSpec> = [
      {
        waves: makeWaves([
             Suspend(Type(Single(Pop1)))
            ,MW, Suspend(LocX(-20, Type(Single(Pop1))))
            ,MW, Suspend(LocX(20, Type(Single(Pop1))))
            ,MW, Suspend(Type(Single(Pop1)))
          ])
      }
    ];
  
  public static function playLevel(n:Int):Level return new Level(levels[n]);
  
  public var waves:Array<Wave>;
  public var activeWaves:Array<Wave> = [];
  public var prog:Float;
  
  private function new(spec:LevelSpec) {
    waves = spec.waves.copy();
    prog = 0.0;
  }
  
  function tickWave(w:Wave):Bool { // true = wave complete
    return (switch (w.type) {
      case Single(t):
      if (w.prog == 0) {
        w.entities = [new EntityEnemy(t, w.x, w.y)];
        w.entities.map(GSGame.spawn);
      }
      w.entities.filter(e -> !e.rem).length == 0;
      case _: throw 'unknown wave type ${w.type}';
    });
  }
  
  public function tick(delta:Float):Void {
    var suspended = false;
    activeWaves = [ for (w in activeWaves) {
        if (w.suspend) suspended = true;
        if (tickWave(w)) continue;
        w.prog++;
        w;
      } ];
    if (suspended) return;
    var rangeMin = prog;
    var rangeMax = prog + (1000 / 60); // + delta;
    var nextProg = rangeMax;
    while (waves.length > 0 && waves[0].at >= rangeMin && waves[0].at <= rangeMax) {
      var w = waves.shift();
      w.prog = 0;
      w.entities = [];
      activeWaves.push(w);
      if (w.suspend) {
        nextProg = w.at;
        break;
      }
    }
    prog = nextProg;
  }
}

typedef LevelSpec = {
    waves:Array<Wave>
  };

enum WaveSpec {
  MW;
  Wait(secs:Float);
  At(secs:Float);
  Type(type:Wave.WaveType);
  LocX(x:Float, s:WaveSpec);
  LocY(y:Float, s:WaveSpec);
  Loc(x:Float, y:Float, s:WaveSpec);
  Suspend(s:WaveSpec);
  Speed(sp:Float, s:WaveSpec);
}
