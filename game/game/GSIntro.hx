package game;

class GSIntro extends GameState {
  var stars:Array<{y:Float, vy:Float, act:Actor}>;
  var introText:TextFragment;
  var prog:Int;
  
  public function new() {
    
  }
  
  override public function mouse(e:MouseEvent) {
    if (e.match(Up(_, _))) {
      game.state("title");
    }
  }
  
  override public function to(from:GameState):Void {
    prog = 0;
  }
  
  override public function tick(delta:Float):Void {
    if (introText == null) {
      introText = new TextFragment('In an arcade far, far away...

It is a dark time for the arcades.
Although the regulars still play
every day, newcomers are unheard
of. The arcade machines, whose
lifeforce comes from the coins,
now have to compete with each
other.

So, in the middle of the deepest
nights ... the war has changed.'.split("\n").map(l -> Tx.normal() + l).join("\n"));
      stars = [ for (i in 0...80) {
           y: Choice.nextFloat(0, 300)
          ,vy: Choice.nextFloat(1.5, 2.1)
          ,act: new Actor(-16 + Choice.nextMod(232), 0, "menu-star".visual(Choice.nextElement([4, 3, 2, 2, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 5, 5, 5, 5, 6, 6, 6, 6, 7, 7, 7, 7])))
        } ];
    }
    win.fill(Actor.PAL[12]);
    for (s in stars) {
      s.act.render(win, 0, s.y.floor());
      s.y -= s.vy;
      if (s.y < -16) {
        s.act.x = -16 + Choice.nextMod(232);
        s.y = 300;
        s.vy = Choice.nextFloat(1.5, 2.1);
      }
    }
    "menu-logo".singleton(0, 26).render(win);
    
    win.blitAlpha(2, (300 - (prog >> 1)).max(100), introText.size(200, 200));
    prog++;
    if (prog > 10 * 60) game.state("title");
  }
}
