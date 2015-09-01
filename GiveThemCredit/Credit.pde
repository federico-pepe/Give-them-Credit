/*

 Credit Object
 
 June, 2015
 federico@federicopepe.com
 
 */
class Credit {
  // -------------------- VARIABLES --------------------------------
  String name;
  int value;
  PVector pos = new PVector(0, 0);
  ArrayList<String> artists = new ArrayList<String>();

  // -------------------- CONSTRUCTOR --------------------------------
  Credit(String _name, int _value) {
    name = _name;
    value = _value;
  }
  // -------------------- CONSTRUCTOR --------------------------------
  Credit(String _name) {
    name = _name;
  }
  
  // -------------------- FUNCTIONS --------------------------------
  boolean mouseOver(float _x, float _y) {
    if ((mouseX <= _x) && (mouseY >= ((_y - textSize/2)+scroll)) && (mouseY <= (_y)+scroll)) {
      return true;
    } else {
      return false;
    }
  }
  
}

