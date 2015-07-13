/*

 Credit Object
 
 June, 2016
 federico@federicopepe.com
 
 */
class Credit {
  // -------------------- VARIABLES --------------------------------
  String name;
  int value;
  PVector pos = new PVector(0, 0);
  // -------------------- CONSTRUCTOR --------------------------------
  Credit(String _name, int _value) {
    name = _name;
    value = _value;
  }
  // -------------------- CONSTRUCTOR --------------------------------
  Credit(String _name) {
    name = _name;
  }
}

