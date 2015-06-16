/*

 RoviSearchResult Class
 
 May, 2015
 federico@federicopepe.com
 
 */

public class RoviSearchResult {
  // -------------------- VARIABLES --------------------------------
  ArrayList<NameMusicCreditObject> allNames = new ArrayList<NameMusicCreditObject>();

  // -------------------- CONSTRUCTOR --------------------------------
  RoviSearchResult() {
  }

  // -------------------- FUNCTIONS --------------------------------
  void processResult(XML o, String _endpoint) {

    if (_endpoint == "name/musiccredits") {

      XML[] NameMusicCreditXML = o.getChild("credits").getChildren("NameMusicCredit");

      for (XML element : NameMusicCreditXML) {

        NameMusicCreditObject n = new NameMusicCreditObject();

        n.albumID = element.getChild("id").getContent();
        n.albumTitle = element.getChild("title").getContent();
        n.artistID = element.getChild("primaryartists").getChild("CreditArtist").getChild("id").getContent();
        n.artistName = element.getChild("primaryartists").getChild("CreditArtist").getChild("name").getContent();
        n.year = int(element.getChild("year").getContent());
        n.credit = element.getChild("credit").getContent();

        allNames.add(n);
      }
      background(40);
      for (NameMusicCreditObject n : allNames) {
        n.display();
      }
    } else {
      // DEBUG
      println("Currently I can't process this endpoint: " + _endpoint);
    }
  }
}

