/*

 nameCredits Object
 
 June, 2015
 federico@federicopepe.com
 
 */

class nameCredits {
  // -------------------- VARIABLES --------------------------------
  String artistID;
  String artistName;
  ArrayList<Credit> credits = new ArrayList<Credit>();
  PVector pos = new PVector(0, 0);
  
  // -------------------- CONSTRUCTOR --------------------------------
  nameCredits(String _id, String _name) {
    artistID = _id;
    artistName = _name;
  };
  
  nameCredits(String _name) {
    artistName = _name;
  };
  
  // -------------------- FUNCTIONS --------------------------------
  boolean mouseOver(float _x, float _y) {
    if ((mouseX >= _x) && (mouseY >= ((_y - textSize/2)+scroll)) && (mouseY <= (_y)+scroll)) {
      return true;
    } else {
      return false;
    }
  }  
}  

