/*
  Rovi MD5 Signature Generator
  
  Created by Kevin Kohut:
  http://developer.rovicorp.com/forum/read/97479
  
  Edited by Federico Pepe
  federico@federicopepe.com

  April, 2015
*/
import java.math.BigInteger;
import java.util.Date;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

class Signature {
  
  String signature;
  
  String getSignature() {
   try {
      signature = getSig();
    }
    catch (NoSuchAlgorithmException e) {
      println("Error while getting the signature.");
    }   
    return signature;
  }

  String getSig() throws NoSuchAlgorithmException {
    String result = null;
    Date _date = new Date();
    long _secs = 0;
    _secs = _date.getTime() / 1000;
    String _sig = APIKey + APISecret + _secs;
    byte[] hash = MessageDigest.getInstance("MD5").digest(_sig.getBytes());
    BigInteger bi = new BigInteger(1, hash);
    result = bi.toString(16);
    if (result.length() % 2 != 0) {
      result = "0" + result;
    }
    return result;
  }
}

