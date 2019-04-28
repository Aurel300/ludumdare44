package game;

typedef Wave = {
     type:WaveType
    ,enemies:Array<EnemyType>
    ,x:Float
    ,y:Float
    ,at:Float
    ,?finished:Level->Wave->Void
    ,?suspend:Bool
    ,?speed:Float
    ,?prog:Int
    ,?entities:Array<Entity>
    ,?spawned:Int
  };

enum WaveType {
  None;
  File(dx:Float, dy:Float, count:Int);
  Elbow(dx:Float, count:Int);
}
