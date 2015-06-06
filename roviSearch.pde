/*

 RoviSearch Class
 
 May, 2015
 federico@federicopepe.com
 
 All datas taken from Rovi Metadata & Search APIs
 link: http://developer.rovicorp.com
 
 */

public class RoviSearch {
  String apiKey   = APIKey;  // EDIT Configuration File
  String baseURL  = "http://api.rovicorp.com/data/v1.1/";
  String format   = "xml";
  String duration = "10080";
  String count    = "0";
  String offset   = "0";

  import java.net.URLEncoder;

  // -------------------- CONSTRUCTOR --------------------------------
  RoviSearch() {
  }

  String q = "Rick Rubin";
  String endpoint = "name/musiccredits";

  RoviSearch(String _query, String _endpoint) {
    q = _query;
    endpoint = _endpoint;
  } 
  /*
  *  Search Functions - Returns roviSearchResult
   */
  RoviSearchResult doSearch() {
    RoviSearchResult result = new RoviSearchResult();
    String url = constructURL();
    XML xml = loadXML(url);
    result.processResult(xml, endpoint);
    return result;
  } 

  /*
  *  URL Construction
   */
  String constructURL() {
    // GENERATE MD5 SIGNATURE FROM CLASS 'Signature' TO ACCESS API DATA
    Signature sig = new Signature();
    String url = baseURL + getEndpoint() + "?" + "apikey=" + apiKey + "&sig=" + sig.getSignature() + "&" + getQuery() + "&format=" + format + "&duration=" + duration + "&count=" + count + "&offset=" + offset;
    return url;
  }

  String getEndpoint() {
    return endpoint;
  }

  String getQuery () {
    if (endpoint == "album/credits") {
      return "albumid=" + URLEncoder.encode(q);
    } else if (endpoint == "name/musiccredits") {
      return "name=" + URLEncoder.encode(q);
    } else {
      println("Error while getQuery");
      return "";
    }
  }
}

