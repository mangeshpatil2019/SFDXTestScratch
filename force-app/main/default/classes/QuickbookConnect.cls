public class QuickbookConnect{

    @future(Callout=true)
    public static void createAccount(id actID){
        
        QuickBookEventLog__c el;
        try{
            Account act=[Select name,QC_Account_Id__C from Account where id=:actId];
            //string body='{"Name": '+ act.name +',"AccountType": "Accounts Receivable"}';
            string body =null; //'{"Name": "syntel123","AccountType": "Accounts Receivable"}';
            quickBookAccount qac=new quickBookAccount();
            qac.Name=act.name;
            qac.AccountType='Accounts Receivable';
            body=JSON.serialize(qac,true);
            QBRefreshAccessToken qbRAccTk= checkExpiredAccessToken();
            HttpResponse res =sendHttpRequest(body,'account',qbRAccTk.accessToken);
            if(null!=res && res.getstatusCode()==200){
                QuickbookAccountResponse actRes;
                string resBody=res.getbody();
                if(!resBody.contains('Fault')){
                
                    actRes=(QuickbookAccountResponse)JSON.deserialize(res.getBody(),QuickbookAccountResponse.class);
                    System.debug('The clss deserialize is---> ' + actRes);
                    
                }
                            
            
                system.debug('The response is ---> ' + res);
                el=new QuickBookEventLog__c();
                el.Account__c=actId;
                el.ResponseBody__c=res.getbody();
                insert el;
                
                act.QC_Account_Id__C=Decimal.valueOf(actRes.Account.Id);
                update act;
                
                if(qbRAccTk.isExpired){
                    List<QuickbookConfig__c> lQBs=[Select UpdatedDateTime__c,accessToken__c,refreshToken__c from QuickbookConfig__c limit 1];
                    lQBs[0].accessToken__c=qbRAccTk.accessToken;
                    update lQBs[0];
                }

                
            }
        }catch(Exception exp){
            el=new QuickBookEventLog__c();
            system.debug('The response is ---> ' + exp.getMessage());
            el.Account__c=actId;
            el.ResponseBody__c=exp.getMessage();
            insert el;
        }
    }


    @future(Callout=true)
    public static void createCustomer(id cntId){
        
        QuickBookEventLog__c el;
        try{
            Contact cnt=[Select account.name, name,firstname,lastname,Salutation,title, QC_Contact_Id__c from Contact where id=:cntId];
            //string body='{"Name": '+ act.name +',"AccountType": "Accounts Receivable"}';
            string body =null; //'{"Name": "syntel123","AccountType": "Accounts Receivable"}';
            QuickbookCustomerRequest qac=new QuickbookCustomerRequest();
            qac.GivenName=cnt.firstName;
            qac.FamilyName=cnt.lastName;
            qac.CompanyName=cnt.Account.name;
            qac.title=cnt.title;
            qac.Suffix=cnt.Salutation;
            body=JSON.serialize(qac,true);
            QBRefreshAccessToken qbRAccTk= checkExpiredAccessToken();
            HttpResponse res =sendHttpRequest(body,'customer',qbRAccTk.accessToken);
            if(null!=res && res.getstatusCode()==200){
                QuickbookCustomerResponse custRes;
                string resBody=res.getbody();
                if(!resBody.contains('Fault')){
                
                    custRes=(QuickbookCustomerResponse )JSON.deserialize(res.getBody(),QuickbookCustomerResponse .class);
                    System.debug('The clss deserialize is---> ' + custRes);
                    
                }
                            
            
                system.debug('The response is ---> ' + res);
                el=new QuickBookEventLog__c();
                el.Contact__c=cntId;
                el.ResponseBody__c=res.getbody();
                insert el;
                
                cnt.QC_Contact_Id__c=Decimal.valueOf(custRes.Customer.Id);
                update cnt;
                
                if(qbRAccTk.isExpired){
                    List<QuickbookConfig__c> lQBs=[Select UpdatedDateTime__c,accessToken__c,refreshToken__c from QuickbookConfig__c limit 1];
                    lQBs[0].accessToken__c=qbRAccTk.accessToken;
                    update lQBs[0];
                }
                
            }
        }catch(Exception exp){
            system.debug('The response is ---> ' + exp.getMessage());
            el.Contact__c=cntId;
            el.ResponseBody__c=exp.getMessage();
            insert el;
        }
    }
    
    public static QBRefreshAccessToken  checkExpiredAccessToken(){
        
        List<QuickbookConfig__c> lQBs=[Select UpdatedDateTime__c,accessToken__c,refreshToken__c from QuickbookConfig__c limit 1];
        Long dt1Long = lQBs[0].UpdatedDateTime__c.getTime();
        Long dt2Long = DateTime.now().getTime();
        Long milliseconds = dt2Long - dt1Long;
        Long seconds = milliseconds / 1000;
        Long minutes = seconds / 60;
        //Long hours = minutes / 60;
        //Long days = hours / 24;
        System.debug('the time is-----> ' + minutes);
        QBRefreshAccessToken QBRAToken=new QBRefreshAccessToken();
        if(minutes>=59){  //token has expired
            System.debug('Inside expired token logic');
            QBRAToken.isExpired=true;
            QBaccessToken tk=getAccessToken(lQBs[0]);
            QBRAToken.accessToken=tk.access_token;
            QBRAToken.refreshToken=tk.refresh_token;
        }else{        
        
            QBRAToken.isExpired=false;
            QBRAToken.accessToken=lQBs[0].accessToken__c;
            //QBRAToken.refreshToken=tk.refresh_token;
        
        }
        
        return QBRAToken;
        
        
        //return '';
    }

    public static QBaccessToken  getAccessToken(QuickbookConfig__c qbCnfg){
        
        System.debug('Inside for getting new access token with refresh token');
        string CLIENT_SECRET='1knLQsNFjHKV3QNCT8HWJD0Je1vTkVwx5YFi9vqZ';
        string CLIENT_ID='Q0QGknRMJYGBcbYHO1MoGQq1flZ5NVms81lu4JYgpftnkCoqTy';
        Blob beforeblob = Blob.valueOf(CLIENT_ID+ ':' + CLIENT_SECRET);
        string abc=EncodingUtil.base64Encode(beforeblob); 
        
        QBaccessToken aToken;        
        string body='grant_type=refresh_token&refresh_token='+qbCnfg.refreshToken__c;
        http h=new http();
        HttpRequest req = new HttpRequest();
        req.setEndPoint('https://oauth.platform.intuit.com/oauth2/v1/tokens/bearer');
        req.setHeader('accept','application/json');
        req.setMethod('POST');
        req.setHeader('Content-Type','application/x-www-form-urlencoded');    
        req.setHeader('Authorization' ,  'Basic '+abc);    
        req.setBody(body);
        System.debug('The request is----> ' + body);
        HttpResponse res = h.send(req);
        
        if(res!=null && res.getBody()!=null){
            aToken=(QBaccessToken)JSON.deserializeStrict(res.getBody(),QBaccessToken.class);            
           System.debug('The new token is--->' + aToken);
        }
        
        return aToken;
    }
    private static HttpResponse sendHttpRequest(string body,string type,string accessToken){
    
        
        http h=new http();
        HttpRequest req = new HttpRequest();
        req.setEndPoint('https://sandbox-quickbooks.api.intuit.com/v3/company/123146282221224/'+type);
        req.setHeader('authorization','Bearer '+ accessToken);
        req.setHeader('accept','application/json');
        req.setMethod('POST');
        req.setHeader('Content-Type','application/json');        
        req.setBody(body);
        HttpResponse res = h.send(req);
        return res;
    
    }


    public class quickBookAccount{
        public string Name{get;set;}
        public string AccountType{get;set;}
    
    }

    public class QBRefreshAccessToken{
        public boolean isExpired{get;set;}
        public string accessToken{get;set;}
        public string refreshToken{get;set;}
    
    }

     public class QBaccessToken{
   
       public string expires_in{get;set;}
       public integer x_refresh_token_expires_in{get;set;}
       public string refresh_token{get;set;}
       public string access_token{get;set;}
       public string token_type{get;set;}
   
   }


}