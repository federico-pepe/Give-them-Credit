/*

 RoviSearchResult Class
 
 May, 2015
 federico@federicopepe.com
 
 */

public class RoviSearchResult {

  // -------------------- CONSTRUCTOR --------------------------------
  RoviSearchResult() {
    println("RoviSearchResult");
  }

  void processResult(XML o) {
    XML[] NameMusicCredit = o.getChild("credits").getChildren("NameMusicCredit");
    String[] names;
    String[] ids;
    names = new String[NameMusicCredit.length];
    ids = new String[NameMusicCredit.length];
    int idx = 0;

    // DEBUG printArray(NameMusicCredit);
    // DEBUG println(NameMusicCredit[0].getChild("id").getContent());

    for (XML element : NameMusicCredit) {

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
    // DEBUG 
    println(names[0]);
  }
}

