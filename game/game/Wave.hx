package game;

typedef Wave = {
     type:WaveType
    ,enemies:Array<EnemyType>
    ,x:Float
    ,y:Float
    ,at:Float
    ,spacing:Int
    ,suspend:Bool
    ,bossWave:Bool
    ,speed:Float
    //,?finished:Level->Wave->Void
    ,?prog:Int
    ,?entities:Array<Entity>
    ,?spawned:Int
  };

enum WaveType {
  None;
  File(dx:Float, dy:Float, count:Int);
  SineFile(dx:Float, dy:Float, amp:Float, wl:Float, wv:Float, count:Int);
  Elbow(dx:Float, count:Int);
  Upbow(dx:Float, count:Int);
  Loop(loops:Float, radius:Float, rdelta:Float, count:Int);
  Points(pts:Array<{x:Float, y:Float, at:Int}>, count:Int);
  Stop;
  StopN(count:Int);
  StopFor(time:Int);
}
