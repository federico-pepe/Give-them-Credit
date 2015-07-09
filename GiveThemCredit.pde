// Give Them Credit
// Created: 11.04.2015
// Last update: 08.07.2015
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
}

void draw() {
  renderData();
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
  String albumID = "MW0000392118";
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
        instruments.increment(credits[i]);
      }
      allNameCredits.add(thisNameCredit);
    }
    // Populate the allCredits ListArray
    // I NEED TO FIX THIS
    instruments.sortValuesReverse();
    for(String k : instruments.keys ()) {
      Credit thisCredit = new Credit(k, instruments.get(k));
      allCredits.add(thisCredit);
    }
    // END FIX THIS.
  } else {
    println("There was an error while fetching data from ROVI API");
    exit();
  }
}
void renderData() {
  background(0);
  int textSize = 14;
  float margin = 50;
  float textYPos = 0;
  float maxValue = allCredits.get(0).value*10;
  fill(127);
  // Display the credits
  for(int i = 0; i < allCredits.size(); i++) {
    textAlign(RIGHT);
    textSize(textSize);
    text(allCredits.get(i).name, margin + 250, margin + textYPos);
    rect((margin + 260), margin + textYPos - textSize, 10*allCredits.get(i).value, textSize);
    textYPos = (textYPos + textSize)+5;
  }
  // Display the names
  textYPos = 0;
  for (int i = 0; i < allNameCredits.size(); i++) {
    textAlign(LEFT);
    textSize(textSize);
    text(allNameCredits.get(i).artistName, width - (margin + 250), margin + textYPos);
    textYPos = (textYPos + textSize)+5;
  }
}
void renderData_2() {
  // This was an attempt to draw data in Circles
  // but the visualization was too clumsy
  /*
  float xPos = 100 + max(instruments.valueArray());
  float yPos = 100 + max(instruments.valueArray());
  int counter = 0;
  float multiplier = 10;
  float textYPos = (yPos + max(instruments.valueArray()) * (multiplier/1.5));

  for (String k : instruments.keys ()) {
    
    //println("Key: " + k + " value: " + instruments.get(k));
    float diameter = instruments.get(k)*multiplier;
    fill(255);
    ellipse(xPos, yPos, diameter, diameter);
    fill(0);
    textAlign(CENTER);
    textSize(14);
    fill(127);
    text(k, xPos, textYPos);
    counter++;
   
    if (diameter < textWidth(k)) {
      xPos = xPos + (textWidth(k)+ 25);
    } else {
      xPos = xPos + (diameter + 25);
    }
    if(xPos >= width) {
      yPos = yPos + (100 + diameter*2);
      textYPos = (yPos + diameter*2);
      xPos = 100 + max(instruments.valueArray());
    }
  }
  /*
  * This below was the first attempt to draw data
  * All the names were putted
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

