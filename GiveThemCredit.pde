// Give Them Credit
// Created: 11.04.2015
// Last update: 15.07.2015
import java.net.URLEncoder;
import processing.pdf.*;

//---------- DATA ----------//
String albumID = "Random Access Memories";
String albumArtist;
String albumReleaseYear;

//---------- VARIABLES ----------//
XML rawData;
ArrayList<nameCredits> allNameCredits = new ArrayList<nameCredits>();
ArrayList<Credit> allCredits = new ArrayList<Credit>();
IntDict instruments = new IntDict();

//---------- FONT ----------//
int textSize = 14;
int titleTextSize = 38;

//---------- GUI ----------//
float scroll;

void setup() {
  size(displayWidth, 3000, JAVA2D);
  colorMode(HSB);
  background(0); 
  smooth();
  fill(255);
  getData();
  /*
  //beginRecord(PDF, albumID + ".pdf");
  translate(0, scroll);
  renderAlbumData();
  drawLinks();
  //endRecord();
 */ 
}

void draw() {
  translate(0, scroll);
  renderAlbumData();
  drawLinks();
  drawLinksWithNames();
  //endRecord();
}

void getData() {
  // All the API stuff to get data from ROVI
  String apiKey   = APIKey;  // EDIT Configuration File
  String baseURL  = "http://api.rovicorp.com/data/v1.1/";
  String format   = "xml";
  String duration = "5";
  String count    = "0";
  String offset   = "0";
  // ENDPOINT album/info with &include=all seem more interesting
  String endpoint = "album/credits";
  // Generate Signature and final url
  Signature sig = new Signature();
  //
  // LOAD ALBUM INFO
  //
  String albumUrl = baseURL + "album/info" + "?" + "apikey=" + apiKey + "&sig=" + sig.getSignature() + "&album=" + URLEncoder.encode(albumID) + "&format=" + format;  
  XML xml = loadXML(albumUrl);
  XML[] primaryArtists = xml.getChild("album").getChildren("primaryArtists");
  for(XML element : primaryArtists) {
    albumArtist = element.getChild("AlbumArtist").getChild("name").getContent();
  }
  String[] list = split(xml.getChild("album").getChild("originalReleaseDate").getContent(), "-");
  albumReleaseYear = list[0];
  //
  // LOAD DATA FOR CREDITS
  //
  String url = baseURL + endpoint + "?" + "apikey=" + apiKey + "&sig=" + sig.getSignature() + "&album=" + URLEncoder.encode(albumID) + "&format=" + format + "&duration=" + duration + "&count=" + count + "&offset=" + offset;  
  // Finally Load the data in XML format
  rawData = loadXML(url);
  // Check if we actually got some data to parse
  if (rawData != null) {
    XML[] xmlData = rawData.getChild("credits").getChildren("AlbumCredit");
    for (XML element : xmlData) {
      // Parsing XML File
      String id = element.getChild("id").getContent();
      String name = element.getChild("name").getContent();
      String[] credits = element.getChild("credit").getContent().split(", ");
      // Create nameCredit Object and populate it with data
      nameCredits thisNameCredit;
      thisNameCredit = new nameCredits(id, name);
      for (int i = 0; i < credits.length; i++) {
        Credit thisCredit = new Credit(credits[i]);
        thisNameCredit.credits.add(thisCredit);
        instruments.increment(credits[i]);
      }
      // Add the Object to the ListArray with all the nameCreditsObject
      allNameCredits.add(thisNameCredit);
    }
    // Populate the allCredits ListArray
    instruments.sortValuesReverse();
    for (String k : instruments.keys ()) {
      Credit thisCredit = new Credit(k, instruments.get(k));
      for(int i = 0; i < allNameCredits.size(); i++) {
        for (Credit c : allNameCredits.get (i).credits) {
          if(c.name.equals(k)) {
            thisCredit.artists.add(allNameCredits.get(i).artistName);
          }
        }
      }
      allCredits.add(thisCredit);
    }
  } else {
    println("There was an error while fetching data from ROVI API");
    exit();
  }
}
void renderAlbumData() {
  background(0);
  float margin = 50;
  float textYPos = titleTextSize/2;
  fill(255);
  // DRAW ALBUM INFO AT TOP
  textAlign(CENTER);
  textSize(titleTextSize);
  String albumText = albumID + " - " + albumArtist + " (" + albumReleaseYear + ")";
  text(albumText, width/2, margin + textYPos);
  textSize(textSize);
  textYPos = titleTextSize + 50;
  // DRAW CREDITS AT BOTTOM
  textSize(textSize);
  // Display the credits
  for (int i = 0; i < allCredits.size (); i++) {
    Credit thisCredit = allCredits.get(i);
    // SET POSITION
    thisCredit.pos.x = width/6;
    thisCredit.pos.y = margin + textYPos;
    textAlign(RIGHT);
    text(thisCredit.name, width/6, margin + textYPos);
    textYPos = (textYPos + textSize)+5;
  }
  // Display the names
  textYPos = titleTextSize + 50;
  for (int i = 0; i < allNameCredits.size (); i++) {
    nameCredits thisCredit = allNameCredits.get(i);
    // SET POSITION
    thisCredit.pos.x = width - (width/6);
    thisCredit.pos.y = margin + textYPos;
    textAlign(LEFT);
    text(thisCredit.artistName, width - (width/6), margin + textYPos);
    textYPos = (textYPos + textSize)+5;
  }
}

void drawLinks() {
  for (int i = 0; i < allNameCredits.size (); i++) {
    for (Credit c : allNameCredits.get (i).credits) {
      for (int j = 0; j < allCredits.size (); j++) {
        if (c.name.equals(allCredits.get(j).name)) {
          stroke(255, 100);
          line(allNameCredits.get(i).pos.x - 10, allNameCredits.get(i).pos.y - (textSize/2), allCredits.get(j).pos.x + 10, allCredits.get(j).pos.y - (textSize/2));
        }
      }
    }
  }
}
// Use this function to draw coloured lines from artist (right) to credits (left)
void drawLinkWithColorsArtiststoCredits() {
  for (int i = 0; i < allNameCredits.size (); i++) {
    float c0 = map(i, 0, allNameCredits.size(), 0, 255);
    color c1 = color(c0, 255, 255);
    for (Credit c : allNameCredits.get (i).credits) {
      for (int j = 0; j < allCredits.size (); j++) {
        if (c.name.equals(allCredits.get(j).name)) {
          stroke(c1);
          line(allNameCredits.get(i).pos.x - 10, allNameCredits.get(i).pos.y - (textSize/2), allCredits.get(j).pos.x + 10, allCredits.get(j).pos.y - (textSize/2));
        }
      }
    }
  }
}
// Use this function to draw coloured lines from credits (left) to artists (right)
void drawLinkWithColorsCreditstoArtists() {
  for(int i = 0; i < allCredits.size(); i++) {
    float c0 = map(i, 0, allCredits.size(), 0, 255);
    color c1 = color(c0, 255, 255);  
    for(String n : allCredits.get(i).artists) {
      for(int j = 0; j < allNameCredits.size(); j++) {
        if(n.equals(allNameCredits.get(j).artistName)) {
          stroke(c1);
          line(allNameCredits.get(j).pos.x - 10, allNameCredits.get(j).pos.y - (textSize/2), allCredits.get(i).pos.x + 10, allCredits.get(i).pos.y - (textSize/2));
        }
      }
    }
  }
}
void drawLinksWithNames() {
  // DRAW RED LINES WHEN MOUSE IS OVER NAME OR CREDITS
  if(mouseX >= width/2) {
    for (int i = 0; i < allNameCredits.size (); i++) {
      if(allNameCredits.get(i).mouseOver(allNameCredits.get(i).pos.x, allNameCredits.get(i).pos.y)){
        for (Credit c : allNameCredits.get(i).credits) {
          for (int j = 0; j < allCredits.size(); j++) {
            if (c.name.equals(allCredits.get(j).name)) {
               stroke(255, 255, 255);
               line(allNameCredits.get(i).pos.x - 10, allNameCredits.get(i).pos.y - (textSize/2), allCredits.get(j).pos.x + 10, allCredits.get(j).pos.y - (textSize/2));
            }
          }
        }
      }
    }
  } else {
    for(int i = 0; i < allCredits.size(); i++) {
      if(allCredits.get(i).mouseOver(allCredits.get(i).pos.x, allCredits.get(i).pos.y)){
        for(String n : allCredits.get(i).artists) {
          for(int j = 0; j < allNameCredits.size(); j++) {
            if(n.equals(allNameCredits.get(j).artistName)) {
              stroke(255, 255, 255);
              line(allNameCredits.get(j).pos.x - 10, allNameCredits.get(j).pos.y - (textSize/2), allCredits.get(i).pos.x + 10, allCredits.get(i).pos.y - (textSize/2));
            }
          }
        }
      }
    }
  }
}
/*
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
}*/

// SCROLLING
void mouseWheel(MouseEvent e) {
  scroll += e.getAmount();
}

