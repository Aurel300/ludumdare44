package game;

class UIShop {
  public static var showing:Bitween = new Bitween(90);
  static var shopUI:UI;
  static var text:TextFragment;
  static var buyCD:Int;
  static var items:Array<{item:ShopItem, bought:Int}>;
  
  public static function show(on:Bool):Void {
    if (on) {
      var level = GI.levelCount;
      var queue:Array<{item:ShopItem, lvl:Int, minLevel:Int}> = [
           {item: Rapid, lvl: 1, minLevel: 0}
          ,{item: Mega, lvl: 1, minLevel: 0}
          ,{item: Armour, lvl: 1, minLevel: 0}
          ,{item: Collector, lvl: 1, minLevel: 1}
          ,{item: Mega, lvl: 2, minLevel: 1}
          ,{item: Rapid, lvl: 2, minLevel: 0}
          ,{item: Armour, lvl: 2, minLevel: 1}
          ,{item: Collector, lvl: 2, minLevel: 2}
          ,{item: Rapid, lvl: 3, minLevel: 2}
          ,{item: Badder, lvl: -1, minLevel: 3}
          ,{item: Smoler, lvl: -1, minLevel: 3}
          ,{item: Life, lvl: -1, minLevel: 0}
          ,{item: Bomb, lvl: -1, minLevel: 0}
        ];
      if (GI.lives == 0) queue.unshift({item: Life, lvl: -1, minLevel: 0});
      if (GI.bombs == 0) queue.unshift({item: Bomb, lvl: -1, minLevel: 0});
      var types = [];
      items = [];
      for (it in queue) {
        if (level < it.minLevel) continue;
        if (it.lvl != -1 && it.item.currentLevel() >= it.lvl) continue;
        if (!it.item.canBuy(0)) continue;
        if (types.indexOf(it.item) != -1) continue;
        types.push(it.item);
        items.push({item: it.item, bought: 0});
        if (items.length >= 4) break;
      }
    }
    Sfx.play("shop_" + (on ? "open" : "close"));
    showing.setTo(on);
  }
  
  static function buy(item:Int):Void {
    var price = items[item].item.price();
    if (price >= GI.player.hp) {
      Sfx.play("shop_poor");
      UIHP.bounce();
      buyCD = 20;
      return;
    }
    if (!items[item].item.canBuy(items[item].bought)) {
      Sfx.play("shop_poor");
      return;
    }
    Sfx.play("shop_buy");
    GI.player.hpDelta(-price, false);
    items[item].item.buy();
    buyCD = 40;
  }
  
  static function costText(?cost:Int):Void {
    text = new TextFragment(
          '${Tx.normal()}Cost:${Tx.gold()}${Tx.setX(30)}' + (cost != null ? '$cost' : "-")
        + '\n${Tx.setY(13)}${Tx.normal()}Life:${Tx.gold()}${Tx.setX(30)}${GI.player.hp}'
      );
  }
  
  public static function reset():Void {
    if (shopUI == null) {
      shopUI = new UI([
           "button" => Clickable(79, 60 + 86, 27, 27)
          ,"slot0" => Clickable(22     , 36     , 36, 44)
          ,"slot1" => Clickable(22 + 48, 36     , 36, 44)
          ,"slot2" => Clickable(22     , 36 + 56, 36, 44)
          ,"slot3" => Clickable(22 + 48, 36 + 56, 36, 44)
        ]);
      shopUI.click.subscribe(el -> if (showing.isOn && buyCD == 0) switch (el) {
          case "button": show(false); GI.levelStart(true);
          case "slot0" | "slot1" | "slot2" | "slot3": buy(el.charCodeAt(4) - "0".code);
          case _:
        });
      costText();
    }
    items = [];
    buyCD = 0;
    showing.setTo(false, true);
  }
  
  static var topProg:Float;
  static var bottomProg:Float;
  static var topX:Int;
  static var topY:Int;
  
  public static function tick():Void {
    showing.tick();
    topProg = (showing.valueF - .1).min(0.9) * (1 / 0.9);
    bottomProg = (showing.valueF).min(0.9) * (1 / 0.9);
    topX = ((1 - topProg) * -GSGame.GWIDTH + 30).floor();
    topY = 60;
  }
  
  public static function mouse(m:MouseEvent):Bool {
    if (!showing.isOn) return false;
    return shopUI.mouse(m, topX, topY);
  }
  
  public static function render(to:ISurface):Void {
    if (showing.isOff) return;
    
    var bottomX = ((1 - bottomProg) * -GSGame.GWIDTH + 30).floor();
    var bottomY = topY + 86 - 6;
    
    var buttonX = bottomX + 79;
    var buttonY = bottomY + 60;
    
    if (buyCD > 0) buyCD--;
    
    if (shopUI.hoverName != null && shopUI.hoverName.startsWith("slot")) costText(items[shopUI.hoverName.charCodeAt(4) - "0".code].item.price());
    else costText();
    
    "shop-bottom".singleton(bottomX, bottomY).render(to);
    "shop-button".singleton(
        buttonX, buttonY,
        showing.state.match(ToOff(_)) ? 2 :
        shopUI.hoverName == "button" && buyCD == 0 ? 1 : 0
      ).render(to);
    "shop-top".singleton(topX, topY).render(to);
    for (i in 0...items.length) {
      var itX = (i < 2 ? topX : bottomX) + 22 + (i % 2 == 0 ? 0 : 48);
      var itY = i < 2 ? (topY + 36) : (bottomY + 12);
      var itI = items[i].item.raw();
      "shop-item".singletonI('$itI', itX + 4, itY + 4, itI).render(to);
      if (showing.isOn) "shop-slot".singletonI(
          '$i'
          ,itX
          ,itY
          ,!items[i].item.canBuy(items[i].bought) ? 2 :
          shopUI.hoverName == 'slot$i' && buyCD == 0 ? 1 : 0
        ).render(to);
    }
    to.blitAlpha(bottomX + 24, bottomY + 62, text.size(54, 32));
  }
}
