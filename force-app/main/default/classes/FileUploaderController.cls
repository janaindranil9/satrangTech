public with sharing class FileUploaderController {
    @AuraEnabled
    public static Map<String, String> uploadFileToGoogleDrive(String fileName, String base64Data) {
        String key = '610111723717-es1ijtrh1rnvn0t7s15r141609j78cq6.apps.googleusercontent.com';
   		String secert = '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';
    	String redirect_uri = 'https://developers.google.com/oauthplayground';
        String accesstoken;
    	String refreshToken = '1//04zuZctSZ6WYnCgYIARAAGAQSNwF-L9IrOS8TqbrG5Qh4lo_G4vPGULcdEYK47CkLeMQDSEko9LL_I1y_lp9MA3mu2W7bTTLFk7M';
        HttpRequest req2 = new HttpRequest();
        req2.setMethod('POST');
        req2.setEndpoint('https://www.googleapis.com/oauth2/v4/token');
        req2.setHeader('content-type', 'application/x-www-form-urlencoded');
        String messageBody = 'client_id=' + key + '&client_secret=' + secert + '&refresh_token='+refreshtoken+'&redirect_uri=' + redirect_uri + '&grant_type=refresh_token';
        req2.setHeader('Content-length', String.valueOf(messageBody.length()));
        req2.setBody(messageBody);
        req2.setTimeout(60 * 1000);
        Http h2 = new Http();
        String resp2;
        HttpResponse res2 = h2.send(req2);
        resp2 = res2.getBody();
        System.debug('resp2-->>'+res2.getStatusCode());
        JSONParser parser = JSON.createParser(resp2);
		while (parser.nextToken() != null) {
    	if ((parser.getCurrentToken() == JSONToken.FIELD_NAME)) {
    	String fieldName = parser.getText();
    	parser.nextToken();
    	if (fieldName == 'access_token') {
    	accesstoken = parser.getText();
    	} else if (fieldName == 'expires_in') {
     	Integer expiresIn = parser.getIntegerValue();
    	} else if (fieldname == 'token_type') {
     	String tokentype = parser.getText();
    	}
    	}
        }
        String base64Content = EncodingUtil.Base64Encode( Blob.valueOf(base64Data)) ;
        Blob blobContent = EncodingUtil.base64Decode(base64Content);
        String url = 'https://www.googleapis.com/upload/drive/v2/files?uploadType=media';
        string authorizationHeader = 'Bearer ' + accesstoken;
        Integer contentSize = blobContent.size();
        HttpRequest req1 = new HttpRequest();
        req1.setheader('Authorization',authorizationHeader);
        req1.setheader('Content-Length',String.valueOf(contentSize));
        req1.setheader('Content-Type','application/'+'PDF');
        req1.setMethod('POST'); 
        req1.setEndpoint(url); 
        req1.setBodyAsBlob(blobContent);
        req1.setHeader('Content-Disposition', 'attachment; filename=' + fileName);
        Http h1 = new Http(); 
      
        Httpresponse resp1 = h1.send(req1);
        Map<String, String> result = new Map<String, String>();
        if (resp1.getStatusCode() == 200) {
            Map<String, Object> jsonResponse = (Map<String, Object>) JSON.deserializeUntyped(resp1.getBody());
            result.put('fileId', (String) jsonResponse.get('fileId'));
        }
        System.debug('response is'+result);
        System.debug('response is code'+resp1.getStatusCode());
        return result;
    }
    @AuraEnabled
    public static void createChildRecord(String parentId, String fileId) {
        CustomChildObject__c childRecord = new CustomChildObject__c();
        childRecord.Parent__c = parentId;
        childRecord.FileId__c = fileId;
        insert childRecord;
    }
}