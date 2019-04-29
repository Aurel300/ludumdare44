package game;

class GSTitle extends GameState {
  var introShow:Int = -10;
  var introText:TextFragment;
  var ui:UI;
  var drawBG:Bool = false; //true;
  var gameOverScreen:Bool = false;
  var scoreBest:Int = -1;
  
  public function gameOver(score:Int, win:Bool):Void {
    introShow = -10;
    drawBG = false;
    gameOverScreen = true;
    var newBest = score > scoreBest;
    scoreBest = scoreBest.max(score);
    introText.text = '${Tx.bold()}${win ? "Victory!" : "Game Over!"}

${Tx.normal()}Final score:
${Tx.gold()}${score}${newBest? " ( NEW BEST! )" : ""}

${Tx.normal()}Click to continue ...';
  }
  
  public function new() {
    introText = new TextFragment("");
    ui = new UI([
         "new"   => Clickable(13, 147 + 0 * 16, 200 - 26, 16)
        ,"sound" => Clickable(13, 147 + 1 * 16, 200 - 26, 16)
        ,"music" => Clickable(13, 147 + 2 * 16, 200 - 26, 16)
        ,"intro" => Clickable(13, 147 + 3 * 16, 200 - 26, 16)
        ,"games" => Clickable(13, 147 + 4 * 16, 200 - 26, 16)
      ]);
    ui.click.subscribe(function(el):Void switch (el) {
        case "new": game.state("game");
        case "sound": Sfx.toggleSound();
        case "music": Sfx.toggleMusic();
        case "intro": game.state("intro");
        case "games": js.Browser.window.open("http://www.thenet.sk");
      });
  }
  
  override public function mouse(e:MouseEvent) {
    if (gameOverScreen) {
      if (e.match(Up(_, _))) {
        gameOverScreen = false;
      }
      return;
    }
    ui.mouse(e);
  }
  
  override public function tick(delta:Float):Void {
    if (drawBG) win.fill(Actor.PAL[5]);
    "menu-title".singleton(introShow * 20, 0).render(win);
    if (introShow < 0) {
      introShow++;
      if (introShow == 0) {} // SFX!
    }
    if (!gameOverScreen) introText.text = '${Tx.normal()}by ${Tx.bold()}Aurel Bílý${Tx.normal()} and ${Tx.bold()}eidovolta
${Tx.normal()}for ${Tx.bold()}Ludum Dare 44

${Tx.gold()}${ui.hoverName == "new" ? " " : ""}> New game
${Tx.gold()}${ui.hoverName == "sound" ? " " : ""}> Sound: ${Sfx.enableSound ? "ON" : "OFF"}
${Tx.gold()}${ui.hoverName == "music" ? " " : ""}> Music: ${Sfx.enableMusic ? "ON" : "OFF"}
${Tx.gold()}${ui.hoverName == "intro" ? " " : ""}> Intro
${Tx.gold()}${ui.hoverName == "games" ? " " : ""}> More games by Aurel

${Tx.normal()}Your high score:
${Tx.gold()}' + (scoreBest == -1 ? "( never played! )" : '$scoreBest');
    win.blitAlpha(introShow * 20 + 10, 100, introText.size(190, 200));
  }
}
