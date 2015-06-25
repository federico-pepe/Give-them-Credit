// Give Them Credit
// Created: 11.04.201
// Last update: 25.06.2015
import java.net.URLEncoder;

XML rawData;
ArrayList<nameCredits> allNameCredits = new ArrayList<nameCredits>();
ArrayList<Credit> allCredits = new ArrayList<Credit>();

void setup() {
  getData();
}

void draw() {
}

void getData() {
  // All the API stuff to get data from ROVI
  String apiKey   = APIKey;  // EDIT Configuration File
  String baseURL  = "http://api.rovicorp.com/data/v1.1/";
  String format   = "xml";
  String duration = "10080";
  String count    = "0";
  String offset   = "0";

  String albumID = "MW0002521619";   // Random Access Memories by Daft Punk
  String endpoint = "album/credits";

  Signature sig = new Signature();
  String url = baseURL + endpoint + "?" + "apikey=" + apiKey + "&sig=" + sig.getSignature() + "&albumid=" + URLEncoder.encode(albumID) + "&format=" + format + "&duration=" + duration + "&count=" + count + "&offset=" + offset;  
  // Finally Load the data in XML format
  rawData = loadXML(url);
  XML[] xmlData = rawData.getChild("credits").getChildren("AlbumCredit");
 
  for (XML element : xmlData) {
    String id = element.getChild("id").getContent();
    String name = element.getChild("name").getContent();
    String[] credits = element.getChild("credit").getContent().split(", ");
    
    nameCredits thisNameCredit;
    thisNameCredit = new nameCredits(id, name);
    
    for (int i = 0; i < credits.length; i++) {
      Credit thisCredit = new Credit(credits[i]);
      thisNameCredit.credits.add(thisCredit);
      allCredits.add(thisCredit);
    }
    allNameCredits.add(thisNameCredit);
  }
  println(allNameCredits.size() + " : " + allCredits.size());
}

