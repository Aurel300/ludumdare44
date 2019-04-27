package game;

enum EntityType {
  // receive collisions
  Player;
  Enemy;
  
  // trigger collisions
  Coin(player:Bool);
  
  //
  //// trigger collisions
  //PlayerCoin;
  //EnemyCoin;
  //Powerup;
}
