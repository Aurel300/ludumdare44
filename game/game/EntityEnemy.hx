package game;

class EntityEnemy extends Entity {
  public var enemyType:EnemyType;
  
  public function new(type:EnemyType, x:Float, y:Float) {
    super("enemy", Enemy);
    enemyType = type;
    this.driveWith(["constant", "bounds"]);
    momentumX = 0;
    momentumY = 2;
    switch (type) {
      case Pop1:
      hp = 1;
      actors = [
          new Actor(0, 0, "enemy-pop1".visual())
        ];
      updateLocate([
          {x: 0, y: 0, w: 13, h: 17, type: Normal}
        ]);
      offX = -13 / 2;
      offY = -17 / 2;
    }
    this.moveTo(x + offX, y + offY);
  }
}
