package game;

class UITop {
  public static var score:Int;
  public static var lives:Int;
  public static var bombs:Int;
  static var fragScore:TextFragment;
  static var lifeActors:Array<Actor>;
  static var bombActors:Array<Actor>;
  static var lifeChange:{phase:Int, adding:Bool};
  static var bombChange:{phase:Int, adding:Bool};
  
  public static function reset():Void {
    if (fragScore == null) {
      fragScore = new TextFragment("");
      lifeActors = [ for (i in 0...GSGame.MAXLIVES) {
          new Actor(GSGame.GWIDTH - 16 - i * 13, -16, "ui-life".visual());
        } ];
      bombActors = [ for (i in 0...GSGame.MAXBOMBS) {
          new Actor(GSGame.GWIDTH - 16 - i * 13, -16, "ui-bomb".visual());
        } ];
    }
    score = 0;
    lives = 0;
    bombs = 0;
    lifeChange = {
         phase: 0
        ,adding: true
      };
    bombChange = {
         phase: 0
        ,adding: true
      };
  }
  
  public static function tick():Void {
    fragScore.text = '${Tx.gold()}Score: ' + '$score'.lpad("0", 8);
    if (score != GI.scoreCount) {
      var dabs = (score - GI.scoreCount).abs();
      for (sig in [
           10000000
          ,1000000
          ,100000
          ,10000
          ,1000
          ,100
          ,10
          ,1
        ]) {
        if (dabs >= sig) {
          if (score > GI.scoreCount) score -= sig;
          else score += sig;
        }
      }
    }
    function counter(cur:Int, target:Int, change:{phase:Int, adding:Bool}, vis:String, shift:Int, actors:Array<Actor>):Int {
      if (cur != target && change.phase == 0) {
        change.phase++;
        change.adding = (target > cur);
      }
      if (change.phase != 0) {
        var mod = (change.adding ? cur : cur - 1);
        if (mod.withinIE(0, actors.length)) {
          actors[mod].y = change.adding ? -16 + (change.phase >> shift) : -(change.phase >> shift);
          actors[mod].visual = vis.visual(change.adding ? 0 : 1);
          change.phase++;
          if (change.phase == 32) {
            change.phase = 0;
            return change.adding ? 1 : -1;
          }
        }
      }
      return 0;
    }
    lives += counter(lives, GI.lives, lifeChange, "ui-life", 1, lifeActors);
    bombs += counter(bombs, GI.bombs, bombChange, "ui-bomb", 0, bombActors);
  }
  
  public static function render(to:ISurface):Void {
    to.blitAlpha(1, 2, fragScore.size(100, 20));
    for (a in bombActors) a.render(to);
    for (a in lifeActors) a.render(to);
  }
}
