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
        var type:Wave.WaveType = None;
        var enemies:Array<EnemyType> = [];
        var x:Float = GSGame.GWIDTH / 2;
        var y:Float = -10.0;
        var finished:Level->Wave->Void = null;
        var suspend:Bool = false;
        var speed:Float = 1;
        var spacing:Int = 30;
        function handleSpec(s:WaveSpec):Void {
          switch (s) {
            case MW | Wait(_) | At(_): throw '$s only valid at root';
            case Enemy(e): enemies = [e];
            case Enemies(e): enemies = e;
            case Type(st, ss): type = st; handleSpec(ss);
            case LocX(sx, ss): x = GSGame.GWIDTH / 2 + sx; handleSpec(ss);
            case LocY(sy, ss): y = sy; handleSpec(ss);
            case Loc(sx, sy, ss): x = GSGame.GWIDTH / 2 + sx; y = sy; handleSpec(ss);
            case Suspend(ss): suspend = true; handleSpec(ss);
            case Speed(sp, ss): speed = sp; handleSpec(ss);
            case Spacing(sp, ss): spacing = sp; handleSpec(ss);
          }
        }
        handleSpec(spec);
        if (type == null) throw "no type for wave";
        {
           enemies: enemies
          ,spacing: spacing
          ,type: type
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
  
  static var levels:Array<LevelSpec> = {
      var SW = Wait(1);
      inline function HLeft(c:Int) return Wave.WaveType.File(-1, 0, c);
      inline function HRight(c:Int) return Wave.WaveType.File(1, 0, c);
      inline function VDown(c:Int) return Wave.WaveType.File(0, 1, c);
      inline function VUp(c:Int) return Wave.WaveType.File(0, -1, c);
      [
        {
          waves: makeWaves([
            
               LocY(50, Type(HRight(5), Enemy(Pop2)))
              ,Suspend(LocY(80, Type(HLeft(5), Enemy(Pop1))))
              ,MW
              
              ,LocX(-20, Type(VDown(5), Enemy(Pop2))),
                   Suspend(LocX(20, Type(VUp(5), Enemy(Pop1)))),
                        Loc(20, 100, Type(Elbow(-1, 5), Enemy(Pop1)))
              ,Wait(3) ,Loc(-20, 50, Type(Elbow(1, 5), Enemy(Pop1)))
              
              ,Wait(3) ,LocY(60, Speed(.6, Type(HRight(15), Enemy(Pop1))))
              ,LocY(30, Speed(.6, Type(HRight(16), Enemy(Dropper)))),

               Suspend(Loc(-20, 50, Type(Stop, Enemy(ClawA))))
              ,SW, Speed(3, Loc(-40, 130, Type(Upbow(1, 4), Enemy(Dropper))))
              ,SW, Speed(3, Loc(40, 150, Type(Upbow(-1, 4), Enemy(Dropper))))
            
              //Suspend(Loc(-20, 50, Type(Stop, Enemy(ClawA))))
              //LocY(50, Type(HRight(5), Enemy(Pool)))
              //LocY(50, Spacing(70, Type(HRight(5), Enemy(Pinball))))
              //LocY(50, Spacing(100, Type(HRight(5), Enemy(GoldCashbag))))
              //          LocY(100, Speed(10, Type(StopFor(60), Enemy(GoldCashbag))))
              //,Wait(3), Loc(-30, 80, Speed(10, Type(StopFor(50), Enemy(GoldCashbag))))
              //,Wait(3), Loc( 30, 110, Speed(10, Type(StopFor(50), Enemy(GoldCashbag))))
              
              // nice left-right sine lines
              /*
               LocY( 60, Type(SineFile(1, 0, .4, 1.2, 0.04, 5), Enemy(Pop1)))
              ,LocY(100, Type(SineFile(1, 0, .4, 1.2, 0.05, 5), Enemy(Pop1)))
              ,LocY(140, Type(SineFile(1, 0, .4, 1.2, 0.06, 5), Enemy(Pop1)))
              ,Wait(5)
              ,LocY( 60, Type(SineFile(-1, 0, .4, -1.2, 0.04, 5), Enemy(Pop1)))
              ,LocY(100, Type(SineFile(-1, 0, .4, -1.2, 0.05, 5), Enemy(Pop1)))
              ,LocY(140, Type(SineFile(-1, 0, .4, -1.2, 0.06, 5), Enemy(Pop1)))
              */
              
              // LocY(100, Type(Loop(1, 40, 0, 5), Enemy(Pop1)))
              //,LocY(200, Type(Loop(1, -40, 0, 5), Enemy(Pop1)))
              //
              //,Wait(5)
              //
              //,LocY(100, Speed(3, Type(Loop(1, 40, 0, 5), Enemy(Pop1))))
              //,LocY(200, Speed(3, Type(Loop(1, -40, 0, 5), Enemy(Pop1))))
              
              ,Type(Points([
                   {x: -100, y: 100, at: 0}
                  ,{x: -50, y: 100, at: 100}
                  ,{x: -50, y: 200, at: 200}
                  ,{x: 50, y: 200, at: 300}
                  ,{x: 50, y: 100, at: 400}
                  ,{x: 100, y: 100, at: 500}
                  ,{x: 300, y: 100, at: 600}
                ], 5), Enemy(Pop1))
              
              //          LocY(100, Type(SineFile(1, 1, .8, 1.2, 0.05, 5), Enemy(Pop1)))
              //,Wait(5), LocY(100, Type(SineFile(-1, 1, .8, -1.2, 0.05, 5), Enemy(Pop1)))
              //,Wait(5), LocX(-20, Type(SineFile(0, -1, .8, 1.2, 0.05, 5), Enemy(Pop1)))
              //,Wait(5), LocX(20, Type(SineFile(0, -1, .8, -1.2, 0.05, 5), Enemy(Pop1)))
            ])
        }
      ];
    };
  
  public static function playLevel(n:Int):Level return new Level(levels[n]);
  
  public var waves:Array<Wave>;
  public var activeWaves:Array<Wave> = [];
  public var prog:Float;
  
  private function new(spec:LevelSpec) {
    waves = spec.waves.copy();
    prog = 0.0;
  }
  
  function tickWave(w:Wave):Bool { // true = wave complete
    inline function enemy(?ox:Float, ?oy:Float):Void {
      if (ox == null) ox = w.x;
      if (oy == null) oy = w.y;
      //trace(ox, oy);
      var wpos = w.entities.length;
      var en = new EntityEnemy(w.enemies[wpos % w.enemies.length], ox, oy, Wave(w, wpos));
      w.entities.push(en);
    }
    inline function spawn():Void {
      GI.spawn(w.entities[w.spawned++]);
    }
    function findStart(cx:Float, cy:Float, dx:Float, dy:Float):{x:Float, y:Float} {
      var minX = -400;
      var maxX = 400;
      var minY = -400;
      var maxY = 400;
      if (dx != 0) {
        if (dx < 0) maxX = GSGame.GWIDTH + 10;
        if (dx > 0) minX = -10;
      }
      if (dy != 0) {
        if (dy < 0) maxY = GSGame.GHEIGHT + 10;
        if (dy > 0) minY = -10;
      }
      while (cx.within(minX, maxX) && cy.within(minY, maxY)) {
        // disgusting
        cx -= dx * 3.0;
        cy -= dy * 3.0;
      }
      return {x: cx, y: cy};
    }
    function closestEdge(cx:Float, cy:Float):{x:Float, y:Float} {
      var leftDist = (cx - (-10)).abs();
      var rightDist = (cx - (GSGame.GWIDTH + 10)).abs();
      var topDist = (cy - (-10)).abs();
      if (leftDist == rightDist) return {x: cx, y: -10};
      if (leftDist < rightDist && leftDist < topDist) return {x: -10, y: cy};
      if (rightDist < topDist) return {x: GSGame.GWIDTH + 10, y: cy};
      return {x: cx, y: -10};
    }
    if (w.prog == 0) {
      switch (w.type) {
        case None: enemy();
        case File(dx, dy, count) | SineFile(dx, dy, _, _, _, count):
        var start = findStart(w.x, w.y, dx, dy);
        for (i in 0...count) enemy(start.x, start.y);
        case Elbow(_, count): for (i in 0...count) enemy(w.x, -10);
        case Upbow(_, count): for (i in 0...count) enemy(w.x, GSGame.GHEIGHT - 10);
        case Stop | StopFor(_): var start = closestEdge(w.x, w.y); enemy(start.x, start.y);
        case Loop(_, radius, _, count):
        var dx = radius > 0 ? 1 : -1;
        var start = findStart(w.x, w.y - radius.abs(), dx, 0);
        for (i in 0...count) enemy(start.x, start.y);
        case Points(pts, count): for (i in 0...count) enemy(pts[0].x + GSGame.GWIDTH / 2, pts[0].y);
        case _:
      }
    }
    switch (w.type) {
      case None | Stop | StopFor(_) if (w.prog == 0): spawn();
      case File(_, _, count) | SineFile(_, _, _, _, _, count) | Elbow(_, count)
        | Upbow(_, count) | Loop(_, _, _, count) | Points(_, count) if (w.prog % w.spacing == 0 && w.spawned < count): spawn();
      case _:
    }
    return (switch (w.type) {
      case _: w.entities.filter(e -> !e.rem).length == 0;
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
    var rangeMax = prog + (1 / 60); // + delta;
    var nextProg = rangeMax;
    while (waves.length > 0 && waves[0].at >= rangeMin && waves[0].at <= rangeMax) {
      var w = waves.shift();
      w.prog = 0;
      w.entities = [];
      w.spawned = 0;
      activeWaves.push(w);
      if (w.suspend) {
        rangeMax = nextProg = w.at;
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
  Enemy(_:EnemyType);
  Enemies(_:Array<EnemyType>);
  Type(wt:Wave.WaveType, s:WaveSpec);
  LocX(x:Float, s:WaveSpec);
  LocY(y:Float, s:WaveSpec);
  Loc(x:Float, y:Float, s:WaveSpec);
  Suspend(s:WaveSpec);
  Speed(sp:Float, s:WaveSpec);
  Spacing(sp:Int, s:WaveSpec);
}
