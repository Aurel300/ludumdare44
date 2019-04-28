package game;

class GSLoad extends GameState {
  public function new() {}
  
  var loader:Loader;
  var loadText = new TextFragment("");
  var hooks = false;
  
  override public function load():Void {
    loader = [ for (cat in [
         TextFragment.load()
        ,Actor.load()
      ]) for (sub in cat) sub ];
  }
  
  override public function tick(delta:Float):Void {
    win.fill(Colour.fromARGB32(0xFF0C0421));
    if (loader == null) return;
    if (loader.length > 0) {
      if (TextFragment.fonts != null) {
        loadText.text = loader[0].desc != null ? loader[0].desc : "Loading ...";
      }
      if (loader[0].run()) loader.shift();
    }
    if (loader != null && loader.length == 0 && TextFragment.fonts != null) {
      if (!hooks) {
        for (hook in [
            Actor.hook()
          ]) {
          for (alias => cb in hook) Platform.assets.fbitmaps[alias].then(c -> cb());
        }
        hooks = true;
      }
      loadText.text = "Click to start game";
      if (Debug.autostart) game.state("game");
    }
    if (TextFragment.fonts != null) {
      win.fillRect(0, Main.VHEIGHT - 20, 300, 20, Colour.fromARGB32(0xFFE3CCA8));
      win.blitAlpha(4, Main.VHEIGHT - 16, loadText.size(292, 16));
    }
  }
  
  override public function mouse(e:plu.event.MouseEvent):Void switch (e) {
    case Up(_, _, _):
    if (loader != null && loader.length == 0) game.state("game");
    case _:
  }
}
