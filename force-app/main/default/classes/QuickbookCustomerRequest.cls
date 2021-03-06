//
//Generated by 
//

public class QuickbookCustomerRequest{
    public String FullyQualifiedName;   //King Groceries
    public cls_PrimaryEmailAddr PrimaryEmailAddr;
    public String DisplayName;  //King's Groceries
    public String Suffix;   //Jr
    public String Title;    //Mr
    public String MiddleName;   //B
    public String Notes;    //Here are other details.
    public String FamilyName;   //King
    public cls_PrimaryPhone PrimaryPhone;
    public String CompanyName;  //King Groceries
    public cls_BillAddr BillAddr;
    public String GivenName;    //James
    class cls_PrimaryEmailAddr {
        public String Address;  //jdrew@myemail.com
    }
    public class cls_PrimaryPhone {
        public String FreeFormNumber;   //(555) 555-5555
    }
    public class cls_BillAddr {
        public String CountrySubDivisionCode;   //CA
        public String City; //Mountain View
        public String PostalCode;   //94042
        public String Line1;    //123 Main Street
        public String Country;  //USA
    }
    /*
    public static QuickbookCustomerRequest parse(String json){
        return (QuickbookCustomerRequest) System.JSON.deserialize(json, QuickbookCustomerRequest.class);
    }

    static testMethod void testParse() {
        String json=        '{'+
        '  "FullyQualifiedName": "King Groceries", '+
        '  "PrimaryEmailAddr": {'+
        '    "Address": "jdrew@myemail.com"'+
        '  }, '+
        '  "DisplayName": "King's Groceries", '+
        '  "Suffix": "Jr", '+
        '  "Title": "Mr", '+
        '  "MiddleName": "B", '+
        '  "Notes": "Here are other details.", '+
        '  "FamilyName": "King", '+
        '  "PrimaryPhone": {'+
        '    "FreeFormNumber": "(555) 555-5555"'+
        '  }, '+
        '  "CompanyName": "King Groceries", '+
        '  "BillAddr": {'+
        '    "CountrySubDivisionCode": "CA", '+
        '    "City": "Mountain View", '+
        '    "PostalCode": "94042", '+
        '    "Line1": "123 Main Street", '+
        '    "Country": "USA"'+
        '  }, '+
        '  "GivenName": "James"'+
        '}';
        QuickbookCustomerRequest obj = parse(json);
        System.assert(obj != null);
    }
    */
}