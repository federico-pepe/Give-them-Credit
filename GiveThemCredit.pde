// Give Them Credit
// Created: 11.04.2015
// Last update: 18.07.2015
import java.net.URLEncoder;
import processing.pdf.*;

//---------- DATA ----------//
String albumID = "Random Access Memories";
String albumArtist;
String albumReleaseYear;
String albumTitle;

//---------- VARIABLES ----------//
JSONObject json;
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
  String format   = "json";
  String endpoint = "album/info";
  // Generate Signature and final url
  Signature sig = new Signature();
  // LOAD DATA
  // Check if json file exist in data/album folder.
  // If not, load the data from the API and save a new json file.
  File f = new File(dataPath("data/album/" + albumID + ".json"));
  if (f.exists()) {
    json = loadJSONObject("data/album/" + albumID + ".json");
  } else {
    String albumUrl = baseURL + endpoint + "?" + "apikey=" + apiKey + "&sig=" + sig.getSignature() + "&album=" + URLEncoder.encode(albumID) + "&include=all&format=" + format;  
    json = loadJSONObject(albumUrl);
    albumID = json.getJSONObject("album").getJSONObject("ids").getString("albumId");
    saveJSONObject(json, "data/album/" + albumID + ".json");
  }
  if (json != null) {
    JSONArray primaryArtist = json.getJSONObject("album").getJSONArray("primaryArtists");
    albumArtist = primaryArtist.getJSONObject(0).getString("name");
    String[] originalReleaseDate = split(json.getJSONObject("album").getString("originalReleaseDate"), "-");
    albumReleaseYear = originalReleaseDate[0];
    albumTitle = json.getJSONObject("album").getString("title");
    // LOAD DATA FOR CREDITS
    JSONArray credits = json.getJSONObject("album").getJSONArray("credits");
    for (int i = 0; i < credits.size (); i++) {
      JSONObject thisObject = credits.getJSONObject(i);
      String artistID = thisObject.getString("id");
      String artistName = thisObject.getString("name");
      String[] artistCredits = split(thisObject.getString("credit"), ", ");
      nameCredits thisNameCredit;
      thisNameCredit = new nameCredits(artistID, artistName);

      for (int j = 0; j < artistCredits.length; j++) {
        Credit thisCredit = new Credit(artistCredits[j]);
        thisNameCredit.credits.add(thisCredit);
        instruments.increment(artistCredits[j]);
      }
      allNameCredits.add(thisNameCredit);
    }
    // Populate the allCredits ListArray
    instruments.sortValuesReverse();
    for (String k : instruments.keys ()) {
      Credit thisCredit = new Credit(k, instruments.get(k));
      for (int i = 0; i < allNameCredits.size (); i++) {
        for (Credit c : allNameCredits.get (i).credits) {
          if (c.name.equals(k)) {
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
  String albumText = albumTitle + " - " + albumArtist + " (" + albumReleaseYear + ")";
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
  for (int i = 0; i < allCredits.size (); i++) {
    float c0 = map(i, 0, allCredits.size(), 0, 255);
    color c1 = color(c0, 255, 255);  
    for (String n : allCredits.get (i).artists) {
      for (int j = 0; j < allNameCredits.size (); j++) {
        if (n.equals(allNameCredits.get(j).artistName)) {
          stroke(c1);
          line(allNameCredits.get(j).pos.x - 10, allNameCredits.get(j).pos.y - (textSize/2), allCredits.get(i).pos.x + 10, allCredits.get(i).pos.y - (textSize/2));
        }
      }
    }
  }
}
void drawLinksWithNames() {
  // DRAW RED LINES WHEN MOUSE IS OVER NAME OR CREDITS
  if (mouseX >= width/2) {
    for (int i = 0; i < allNameCredits.size (); i++) {
      if (allNameCredits.get(i).mouseOver(allNameCredits.get(i).pos.x, allNameCredits.get(i).pos.y)) {
        for (Credit c : allNameCredits.get (i).credits) {
          for (int j = 0; j < allCredits.size (); j++) {
            if (c.name.equals(allCredits.get(j).name)) {
              stroke(255, 255, 255);
              line(allNameCredits.get(i).pos.x - 10, allNameCredits.get(i).pos.y - (textSize/2), allCredits.get(j).pos.x + 10, allCredits.get(j).pos.y - (textSize/2));
            }
          }
        }
      }
    }
  } else {
    for (int i = 0; i < allCredits.size (); i++) {
      if (allCredits.get(i).mouseOver(allCredits.get(i).pos.x, allCredits.get(i).pos.y)) {
        for (String n : allCredits.get (i).artists) {
          for (int j = 0; j < allNameCredits.size (); j++) {
            if (n.equals(allNameCredits.get(j).artistName)) {
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

