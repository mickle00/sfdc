@RestResource (urlMapping ='/myTest/*')
global class MyRestResource {
    @HttpGet
    global static List<Id> getString(RestRequest req, RestResponse res){
        List<Case> myCases = [SELECT Id FROM Case];
        List<Id> myIds = new List<Id>();
        for (Case myCase : myCases){
        	myIds.add(myCase.Id);
        }
        return myIds;
    }    
    @HttpPost
    global static Account doPost(RestRequest req, RestResponse res, String name) {
        Account account = new Account();
        account.Name = name;
        insert account;
        return account;
    }    
	@HttpPut
    global static String doPut(RestRequest req, RestResponse res) {
    	return sendEmail();		
    }    
   	@HttpPatch
    global static String doPatch(RestRequest req, RestResponse res, string name) {
		return 'You asked for a \'patch\'' + name;
    }
    @HttpDelete
    global static String doDelete(RestRequest req, RestResponse res) {
		return 'You asked for a \'delete\'';
    } 
    
    private static string sendEmail(){
    	Messaging.SingleEmailMessage myMessage = new Messaging.SingleEmailMessage();
    	myMessage.setSubject('TEST SUBJECT FROM REST');
    	myMessage.setplainTextBody('My body goes here');
    	myMessage.setToAddresses(new string[] { 'blog@michaelpatrickstewart.com' });
    	OrgWideEmailAddress myOrgWideEmail = [SELECT Id FROM OrgWideEmailAddress WHERE Address = 'mike@michaelpatrickstewart.com'];
    	myMessage.setOrgWideEmailAddressId(myOrgWideEmail.Id);
    	Messaging.sendEmail(new Messaging.SingleEmailMessage[] { myMessage });    	
    	return 'sent';
    } 
}