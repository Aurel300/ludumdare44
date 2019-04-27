package game;

typedef ActorVisual = {x:Int, y:Int, w:Int, h:Int, ?post:Array<ActorPost>};

enum abstract ActorPost(String) {
  var FlipH;
  var FlipV;
}
