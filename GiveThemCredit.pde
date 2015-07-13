// Give Them Credit
// Created: 11.04.2015
// Last update: 13.07.2015
import java.net.URLEncoder;

//---------- DATA ----------//
XML rawData;
ArrayList<nameCredits> allNameCredits = new ArrayList<nameCredits>();
ArrayList<Credit> allCredits = new ArrayList<Credit>();

IntDict instruments = new IntDict();

//---------- FONT ----------//
int textSize = 14;

//---------- GUI ----------//
float scroll;
boolean displayLinks;

void setup() {
  size(displayWidth, 3000);
  background(0); 
  fill(255); 
  getData();
}

void draw() {
  translate(0, scroll);
  renderAlbumData();
  drawLinks();
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
    for (String k : instruments.keys ()) {
      Credit thisCredit = new Credit(k, instruments.get(k));
      allCredits.add(thisCredit);
    }
    // END FIX THIS.
  } else {
    println("There was an error while fetching data from ROVI API");
    exit();
  }
}
void renderAlbumData() {
  background(0);
  float margin = 50;
  float textYPos = 0;
  fill(255);
  // Display the credits
  for (int i = 0; i < allCredits.size (); i++) {
    Credit thisCredit = allCredits.get(i);
    // SET POSITION
    thisCredit.pos.x = margin + 250;
    thisCredit.pos.y = margin + textYPos;
    textAlign(RIGHT);
    textSize(textSize);
    text(thisCredit.name, margin + 250, margin + textYPos);
    textYPos = (textYPos + textSize)+5;
  }
  // Display the names
  textYPos = 0;
  for (int i = 0; i < allNameCredits.size (); i++) {
    nameCredits thisCredit = allNameCredits.get(i);
    // SET POSITION
    thisCredit.pos.x = width - (margin + 250);
    thisCredit.pos.y = margin + textYPos;
    textAlign(LEFT);
    textSize(textSize);
    text(thisCredit.artistName, width - (margin + 250), margin + textYPos);
    textYPos = (textYPos + textSize)+5;
  }
}

void drawLinks() {
  for (int i = 0; i < allNameCredits.size (); i++) {
    for (Credit c : allNameCredits.get (i).credits) {
      for (int j = 0; j < allCredits.size (); j++) {
        if (c.name.equals(allCredits.get(j).name)) {
          if (mouseY >= ((allNameCredits.get (i).pos.y - textSize/2)+scroll) && mouseY <= (allNameCredits.get(i).pos.y)+scroll) {
            stroke(255, 0, 0);
          } else {
            stroke(255, 100);
          }
          line(allNameCredits.get(i).pos.x - 10, allNameCredits.get(i).pos.y - (textSize/2), allCredits.get(j).pos.x + 10, allCredits.get(j).pos.y - (textSize/2));
        }
      }
    }
  }
}

void mouseClicked() {
  // Need to implement X position as well
  if (mouseX <= width/2) {
    for (Credit c : allCredits) {
      if (mouseY >= ((c.pos.y - textSize/2)+scroll) && mouseY <= (c.pos.y+scroll)) {
        println(c.name);
      }
    }
  } else {
    for (nameCredits n : allNameCredits) {
      if (mouseY >= ((n.pos.y - textSize/2)+scroll) && mouseY <= (n.pos.y+scroll)) {
        println(n.artistName);
      }
    }
  }
}

// SCROLLING
void mouseWheel(MouseEvent e) {
  scroll += e.getAmount();
}
// KEYPRESSED CURRENTLY NOT IMPLEMENTED
void keyPressed() {
  if (key == 'l' || key == 'L') {
    displayLinks = !displayLinks;
  }
}

