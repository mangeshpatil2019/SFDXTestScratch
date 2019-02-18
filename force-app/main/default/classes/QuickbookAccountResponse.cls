public class QuickbookAccountResponse{
    public cls_Account Account;
    //public String time; //2019-01-24T02:50:37.740-08:00
    public class cls_Account {
        public String Name; //syntel123
        public boolean SubAccount;
        public String FullyQualifiedName;   //syntel123
        public boolean Active;
        public String Classification;   //Asset
        public String AccountType;  //Accounts Receivable
        public String AccountSubType;   //AccountsReceivable
        public Integer CurrentBalance;  //0
        public Integer CurrentBalanceWithSubAccounts;   //0
        public cls_CurrencyRef CurrencyRef;
        public String domain;   //QBO
        public boolean sparse;
        public String Id;   //93
        public String SyncToken;    //0
        public cls_MetaData MetaData;
    }
    public class cls_CurrencyRef {
        public String value;    //USD
        public String name; //United States Dollar
    }
    public class cls_MetaData {
        public String CreateTime;   //2019-01-24T02:50:37-08:00
        public String LastUpdatedTime;  //2019-01-24T02:50:37-08:00
    }
    public static QuickbookAccountResponse parse(String json){
        return (QuickbookAccountResponse) System.JSON.deserialize(json, QuickbookAccountResponse.class);
    }
    /*
    static testMethod void testParse() {
        String json=        '{"Account":{"Name":"syntel123","SubAccount":false,"FullyQualifiedName":"syntel123","Active":true,"Classification":"Asset","AccountType":"Accounts Receivable","AccountSubType":"AccountsReceivable","CurrentBalance":0,"CurrentBalanceWithSubAccounts":0,"CurrencyRef":{"value":"USD","name":"United States Dollar"},"domain":"QBO","sparse":false,"Id":"93","SyncToken":"0","MetaData":{"CreateTime":"2019-01-24T02:50:37-08:00","LastUpdatedTime":"2019-01-24T02:50:37-08:00"}},"time":"2019-01-24T02:50:37.740-08:00"}';
        QuickbookAccountResponse obj = parse(json);
        System.assert(obj != null);
    }
    */
}