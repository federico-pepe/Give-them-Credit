/*

 nameCredits Object
 
 June, 2016
 federico@federicopepe.com
 
 */

class nameCredits {
  // -------------------- VARIABLES --------------------------------
  String artistID;
  String artistName;
  ArrayList<Credit> credits = new ArrayList<Credit>();
  // -------------------- CONSTRUCTOR --------------------------------
  nameCredits(String _id, String _name) {
    artistID = _id;
    artistName = _name;
  };
}
