package game;

typedef Wave = {
     type:WaveType
    ,x:Float
    ,y:Float
    ,at:Float
    ,?finished:Level->Wave->Void
    ,?suspend:Bool
    ,?speed:Float
    ,?prog:Int
    ,?entities:Array<Entity>
  };

enum WaveType {
  Single(t:EnemyType);
}
