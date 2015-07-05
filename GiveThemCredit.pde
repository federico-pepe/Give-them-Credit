// Give Them Credit
// Created: 11.04.201
// Last update: 25.06.2015
import java.net.URLEncoder;

XML rawData;
ArrayList<nameCredits> allNameCredits = new ArrayList<nameCredits>();
ArrayList<Credit> allCredits = new ArrayList<Credit>();

IntDict instruments = new IntDict();

float delta;
float radius;

void setup() {
  size(displayWidth, displayHeight);
  background(0); 
  fill(255); 
  getData();
  renderData();
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
  /* SOME STARTING DATA to TEST THE SCRIPT:
   MW0002521619     // Random Access Memories by Daft Punk
   MW0000192938     // Abbey Road by The Beatles
   MW0000626129     // The Rise and Fall of Ziggy Stardust by David Bowie
   MW0000392118     // The Nightfly by Donald Fagen
   */
  String albumID = "MW0000192938";
  String endpoint = "album/credits";

  Signature sig = new Signature();
  String url = baseURL + endpoint + "?" + "apikey=" + apiKey + "&sig=" + sig.getSignature() + "&albumid=" + URLEncoder.encode(albumID) + "&format=" + format + "&duration=" + duration + "&count=" + count + "&offset=" + offset;  
  // Finally Load the data in XML format
  rawData = loadXML(url);
  if (rawData != null) {
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
        instruments.increment(credits[i]);
      }
      allNameCredits.add(thisNameCredit);
    }
    //println(allNameCredits.size() + " : " + allCredits.size());
    instruments.sortValuesReverse();
    //printArray(instruments);
  }
}

void renderData() {

  float xPos = 100 + max(instruments.valueArray());
  float yPos = 100 + max(instruments.valueArray());
  int counter = 0;
  float multiplier = 10;
  float textYPos = (yPos + max(instruments.valueArray()) * (multiplier/1.5));

  for (String k : instruments.keys ()) {
    
    //println("Key: " + k + " value: " + instruments.get(k));
    float diameter = instruments.get(k)*multiplier;
    ellipse(xPos, yPos, diameter, diameter);
    fill(0);
    textAlign(CENTER);
    textSize(14);
    fill(127);
    text(k, xPos, textYPos);
    counter++;
    if (diameter <= textWidth(k)) {
      xPos = xPos + (textWidth(k)+ 25);
    } else {
      xPos = xPos + (diameter + 25);
    }
    fill(255);
    if(xPos >= width) {
      yPos = yPos + (100 + diameter*2);
      textYPos = (yPos + diameter*2);
      xPos = 100 + max(instruments.valueArray());
    }
  }
  /*
  * DISPLAY NAMES IN CIRCLE 
   delta = TWO_PI / allNameCredits.size();
   radius = allNameCredits.size()*2;
   textSize(12);
   // Display all the artist's name in circle
   for (int i = 0; i < allNameCredits.size (); i++) { 
   float xPos = width/2+radius * cos(i* delta); 
   float yPos = height/2+radius * sin(i* delta);
   pushMatrix();
   translate(xPos, yPos);
   rotate(delta * i);
   text(allNameCredits.get(i).artistName, 0, 0);
   popMatrix();
   }
   */
}

