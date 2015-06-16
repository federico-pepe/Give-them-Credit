/*

 Give Them Credit
 federico@federicopepe.com
 
 Created: 11.04.201
 Last update: 06.06.2015
 
 */

void setup() {
}

void draw() {
}

void mousePressed() {
  println("NO DATA TO DISPLAY. Press L or B to load data.");
}

void keyPressed() {
  RoviSearch rovi;

  // PRESS "L" TO LOAD DATA
  if (key == 'l') {
    rovi = new RoviSearch("The Beatles", "name/musiccredits");
    rovi.doSearch();
  }
  if (key == 'b') {
    rovi = new RoviSearch("Rick Rubin", "name/musiccredits");
    rovi.doSearch();
  }
  if (key == 'a') {
    rovi = new RoviSearch("MW0002610366", "album/credits");
    rovi.doSearch();
  }
}

