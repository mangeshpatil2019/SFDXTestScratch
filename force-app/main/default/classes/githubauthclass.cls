public class githubauthclass{

     public string authtoken{get;set;}
     public string refereshtoken{get;set;}
     public string bodyprint{get;set;}

//Settings needed on the google cloud console.One can store this securely in custom settings or an object.

     public static final string CLIENT_SECRET='e4f4a30d711bf5456fd0cb33c59643a32cff636c';//Fill as per your registered app settings in google console
     public static final string CLIENT_ID='dc114947c3370abb5e3b';//Fill as per your registered app settings in google console
     //public static final string REDIRECT_URL='https://developer.intuit.com/v2/OAuth2Playground/RedirectUrl';
     public static final string REDIRECT_URL='https://c.ap8.visual.force.com/apex/QuickBookOauth';

     //public static final string OAUTH_TOKEN_URL='https://appcenter.intuit.com/connect/oauth2';
     public static final string OAUTH_TOKEN_URL='https://github.com/login/oauth/access_token';
     public static final string OAUTH_CODE_END_POINT_URL='https://github.com/login/oauth/authorize';

     public static final string GRANT_TYPE='grant_type=authorization_code';

//Scope URL as per oauth 2.0 guide of the google 
     public static final string SCOPE='user:email,repo,gist';
     public static final string STATE='=PlaygroundAuth#/Authorize/123146282221224';

//Approval Prompt Constant
public static final string APPROVAL_PROMPT='force';




   public pagereference connect(){
   
     String x=OAUTH_CODE_END_POINT_URL+'?scope='+EncodingUtil.urlEncode(SCOPE,'UTF-8')+'&client_id='+CLIENT_ID; 

     
     pagereference p=new pagereference(x);
     return p;
     
   }
   
    public pagereference showtoken(){
   
   string codeparam=apexpages.currentpage().getparameters().get('code');
   //string realmID=apexpages.currentpage().getparameters().get('realmId');
      
            // Instantiate a new http object
    Http h = new Http();
    
    //String body='code='+codeparam+'&client_id='+CLIENT_ID+'&client_secret='+CLIENT_SECRET+'&redirect_uri='+REDIRECT_URL+'&'+GRANT_TYPE+'&response_type=code&scope='+SCOPE+'&state='+STATE;
    String body='code='+codeparam+'&client_id='+CLIENT_ID+'&client_secret='+CLIENT_SECRET; //+'&redirect_uri='+REDIRECT_URL+'&'+GRANT_TYPE+'&response_type=code&scope='+SCOPE+'&state='+STATE;
    
// Instantiate a new HTTP request, specify the method (GET) as well as the endpoint
    HttpRequest req = new HttpRequest();
    req.setEndpoint(OAUTH_TOKEN_URL);
    //req.setHeader('Content-Type',' application/x-www-form-urlencoded');
    //Blob beforeblob = Blob.valueOf(CLIENT_ID+ ':' + CLIENT_SECRET);
    //string abc=EncodingUtil.base64Encode(beforeblob);
    //req.setHeader('Basic ' ,  abc);
    req.setMethod('POST');
    req.setHeader('accept','application/json');
    req.setBody(body);
    
    system.debug('REQUEST BODY'+body);

// Send the request, and return a response
    HttpResponse res = h.send(req);
    
    system.debug('body'+res.getbody());
    bodyprint=res.getbody();
    /*
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
    */
    
    
    
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
    
    /*
http h=new http();
        HttpRequest req = new HttpRequest();
        req.setEndPoint('https://api.github.com/repos/mangeshpatil2019/TestCICI/git/refs/heads?token=7bd0e160434288a0b4e6e9bd00015ab4d2f3bc26');
        req.setHeader('accept','application/json');
        req.setMethod('GET');
        //req.setHeader('Content-Type','application/x-www-form-urlencoded');        
        //req.setHeader('Authorization' ,  'Basic '+abc);
        //req.setBody(body);
        //System.debug('The request is----> ' + body);
        HttpResponse res = h.send(req);
        system.debug('The response is --->' + res.getBody());
  */
        /*
        http h=new http();
        HttpRequest req = new HttpRequest();        
        req.setEndPoint('https://api.github.com/repos/mangeshpatil2019/TestCICI/git/refs');
        string body='{"ref":"refs/heads/featureA","sha":"72e485966f4a47c64cb333b96fd9adf002394437"}';
        //req.setHeader('accept','application/json');
        req.setMethod('POST');
        //req.setHeader('Content-Type','application/x-www-form-urlencoded');        
        req.setHeader('Authorization' ,  'token 73eae5abd7224d79ffa16c4b8fdb4606cde1d1dc');
        req.setBody(body);
        //System.debug('The request is----> ' + body);
        HttpResponse res = h.send(req);
        system.debug('The response is --->' + res.getBody());
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