public class googleauthclass{

     public string authtoken{get;set;}
     public string refereshtoken{get;set;}
     public string bodyprint{get;set;}

//Settings needed on the google cloud console.One can store this securely in custom settings or an object.

     public static final string CLIENT_SECRET='1knLQsNFjHKV3QNCT8HWJD0Je1vTkVwx5YFi9vqZ';//Fill as per your registered app settings in google console
     public static final string CLIENT_ID='Q0QGknRMJYGBcbYHO1MoGQq1flZ5NVms81lu4JYgpftnkCoqTy';//Fill as per your registered app settings in google console
     //public static final string REDIRECT_URL='https://developer.intuit.com/v2/OAuth2Playground/RedirectUrl';
     public static final string REDIRECT_URL='https://c.ap8.visual.force.com/apex/QuickBookOauth';

     //public static final string OAUTH_TOKEN_URL='https://appcenter.intuit.com/connect/oauth2';
     public static final string OAUTH_TOKEN_URL='https://oauth.platform.intuit.com/oauth2/v1/tokens/bearer';
     public static final string OAUTH_CODE_END_POINT_URL='https://appcenter.intuit.com/connect/oauth2';

     public static final string GRANT_TYPE='grant_type=authorization_code';

//Scope URL as per oauth 2.0 guide of the google 
     public static final string SCOPE='com.intuit.quickbooks.accounting';
     public static final string STATE='=PlaygroundAuth#/Authorize/123146282221224';

//Approval Prompt Constant
public static final string APPROVAL_PROMPT='force';




   public pagereference connect(){
   
     String x=OAUTH_CODE_END_POINT_URL+'?scope='+EncodingUtil.urlEncode(SCOPE,'UTF-8')+'&state='+EncodingUtil.urlEncode(STATE,'UTF-8')+'&redirect_uri='+EncodingUtil.urlEncode(REDIRECT_URL,'UTF-8')+'&response_type=code&client_id='+CLIENT_ID; 
//     '&approval_prompt='+APPROVAL_PROMPT;
     
     pagereference p=new pagereference(x);
     return p;
     
   }
   
    public pagereference showtoken(){
   
   string codeparam=apexpages.currentpage().getparameters().get('code');
   //string realmID=apexpages.currentpage().getparameters().get('realmId');
      
            // Instantiate a new http object
    Http h = new Http();
    
    String body='code='+codeparam+'&client_id='+CLIENT_ID+'&client_secret='+CLIENT_SECRET+'&redirect_uri='+REDIRECT_URL+'&'+GRANT_TYPE+'&response_type=code&scope='+SCOPE+'&state='+STATE;
    
// Instantiate a new HTTP request, specify the method (GET) as well as the endpoint
    HttpRequest req = new HttpRequest();
    req.setEndpoint(OAUTH_TOKEN_URL);
    req.setHeader('Content-Type',' application/x-www-form-urlencoded');
    Blob beforeblob = Blob.valueOf(CLIENT_ID+ ':' + CLIENT_SECRET);
    string abc=EncodingUtil.base64Encode(beforeblob);
    //req.setHeader('Basic ' ,  abc);
    req.setMethod('POST');
    req.setHeader('accept','application/json');
    req.setBody(body);
    
    system.debug('REQUEST BODY'+body);

// Send the request, and return a response
    HttpResponse res = h.send(req);
    
    system.debug('body'+res.getbody());
    
    if(res!=null && res.getBody()!=null){
        QBaccessToken aToken=(QBaccessToken)JSON.deserializeStrict(res.getBody(),QBaccessToken.class);
        List<QuickbookConfig__c> lQBs=[Select accessToken__c,refreshToken__c from QuickbookConfig__c limit 1];
        QuickbookConfig__c qb=null;
        if(!lQbs.isEmpty()){            
            qb=lQbs[0];
        }else{
            qb=new QuickbookConfig__c();
        }
        qb.accessToken__c=aToken.access_token;
        qb.refreshToken__c =aToken.refresh_token;
        
        upsert qb;
        
    }    
    
    
    
    
    /*
    req = new HttpRequest();
    req.setEndPoint('https://sandbox-quickbooks.api.intuit.com/v3/company/123146282221224/companyinfo/123146282221224/?minorversion=12');
    req.setHeader('authorization','Bearer '+ aToken.access_token);
    req.setHeader('accept','application/json');
    req.setMethod('GET');
    res = h.send(req);
//    bodyprint=res.getbody();    
    
    req = new HttpRequest();
    req.setEndPoint('https://sandbox-quickbooks.api.intuit.com/v3/company/123146282221224/account');
    req.setHeader('authorization','Bearer '+ aToken.access_token);
    req.setHeader('accept','application/json');
    req.setMethod('POST');
    req.setHeader('Content-Type','application/json');
    body='{"Name": "MyJobs_test1234","AccountType": "Accounts Receivable"}';
    req.setBody(body);
    res = h.send(req);
    bodyprint=res.getbody();    
    
    */
    return null;
   
   }
   
   public class QBaccessToken{
   
       public string expires_in{get;set;}
       public integer x_refresh_token_expires_in{get;set;}
       public string refresh_token{get;set;}
       public string access_token{get;set;}
       public string token_type{get;set;}
   
   }
   
  
}