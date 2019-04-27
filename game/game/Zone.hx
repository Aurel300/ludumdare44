package game;

typedef Zone = {
     x:Int
    ,y:Int
    ,w:Int
    ,h:Int
    ,type:ZoneType
  };

enum ZoneType {
  Normal;
  Shield;
  Vulnerable;
  Gun;
  GunI(_:Int);
  Collect;
}
