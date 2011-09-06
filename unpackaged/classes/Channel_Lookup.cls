@RestResource (urlMapping ='/channel/*')
global class Channel_Lookup {
    @HttpGet
    global static List<Channel__c> doGet(RestRequest req, RestResponse res){
    	String requestURL = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
    	if (isNumber(requestURL)){
    		return getChannelName(requestURL);
    	}else{
    		return getChannelNumber(requestURL);
    	}
    }
        
    @HttpPost
    global static String doPost(RestRequest req, RestResponse res, String name) {
    	return 'OK';
    }    
    
    @HttpPut
    global static String doPut(RestRequest req, RestResponse res) {
        return 'OK';    
    }    
    @HttpPatch
    global static String doPatch(RestRequest req, RestResponse res) {
        return 'OK';
    }
    @HttpDelete
    global static String doDelete(RestRequest req, RestResponse res) {
        return 'OK';
    } 
    
    private static boolean isNumber(string getRequest){
    	return getRequest.contains('1') ||
    		   getRequest.contains('2') ||
    		   getRequest.contains('3') ||
    		   getRequest.contains('4') ||
    		   getRequest.contains('5') ||
    		   getRequest.contains('6') ||
    		   getRequest.contains('7') ||
    		   getRequest.contains('8') ||
    		   getRequest.contains('9') ||
    		   getRequest.contains('0');
    }
    
    private static List<Channel__c> getChannelName(string channelNumber){
    	List<Channel__c> myChannels = [SELECT Id, Name, Channel_Number__c, HD__c FROM Channel__c WHERE Channel_Number__c = :decimal.valueOf(channelNumber) limit 1];
    	return myChannels;
    }
    private static List<Channel__c> getChannelNumber(string channelName){
    	//lolz SOQL injection
    	string queryLike = '%'+channelName+'%';
    	List<Channel__c> myChannels = [SELECT Id, Name, Channel_Number__c, HD__c FROM Channel__c WHERE Name like :queryLike order by HD__c desc, Channel_Number__c asc];
    	return myChannels;
    }
}