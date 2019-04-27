package game;

enum ZoneType {
  Normal; // normal area, gets hurt by coins
  Attack; // bullets == coins
  Shield; // reflect?
  Collect; // collects coins
  Gun; // shoots coins
  GunI(_:Int);
}
