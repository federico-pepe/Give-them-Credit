/*

 RoviSearchResult Class
 
 May, 2015
 federico@federicopepe.com
 
 */

public class RoviSearchResult {
  // -------------------- VARIABLES --------------------------------
  ArrayList<NameMusicCreditObject> n = new ArrayList<NameMusicCreditObject>();

  NameMusicCreditObject[] results;

  // -------------------- CONSTRUCTOR --------------------------------
  RoviSearchResult() {
  }
  
  // -------------------- FUNCTIONS --------------------------------
  void processResult(XML o, String _endpoint) {

    if (_endpoint == "name/musiccredits") {

      XML[] NameMusicCreditXML = o.getChild("credits").getChildren("NameMusicCredit");

      results = new NameMusicCreditObject[NameMusicCreditXML.length];
      println("Results: " + NameMusicCreditXML.length);
      String[] names;
      String[] ids;
      names = new String[NameMusicCreditXML.length];
      ids = new String[NameMusicCreditXML.length];
      int idx = 0;

      // DEBUG printArray(NameMusicCredit);
      // DEBUG println(NameMusicCredit[0].getChild("id").getContent());

      for (XML element : NameMusicCreditXML) {
        if (element.getChild("primaryartists").getChild("CreditArtist").getChild("name").getContent() != "")
        {
          results[idx] = new NameMusicCreditObject();
          results[idx].artistName = element
            .getChild("primaryartists")
            .getChild("CreditArtist")
              .getChild("name")
                .getContent();
        }

        names[idx] = element
          .getChild("primaryartists")
          .getChild("CreditArtist")
            .getChild("name")
              .getContent();

        ids[idx] = element
          .getChild("primaryartists")
          .getChild("CreditArtist")
            .getChild("id")
              .getContent();

        idx++;
      }
    } else {
      // DEBUG
      println("Currently I can't process this endpoint: " + _endpoint);
    }
  }
}

