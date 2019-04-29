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
        ,Sfx.load()
      ]) for (sub in cat) sub ];
  }
  
  override public function tick(delta:Float):Void {
    win.fill(Colour.fromARGB32(0xFFE8E7DA));
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
      loadText.text = "Click to launch game";
      if (Debug.autostart) game.state("intro");
    }
    if (TextFragment.fonts != null) {
      win.blitAlpha(4, Main.VHEIGHT - 16, loadText.size(292, 16));
    }
  }
  
  override public function mouse(e:plu.event.MouseEvent):Void switch (e) {
    case Up(_, _, _):
    if (loader != null && loader.length == 0) game.state("intro");
    case _:
  }
}
