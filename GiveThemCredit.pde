/*

 Give Them Credit
 federico@federicopepe.com
 
 Created: 11.04.2015
 Last update: 06.06.2015
 
 */

void setup() {
  size(680, 680);
  background(0);
  textSize(20);
  smooth();
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
}

