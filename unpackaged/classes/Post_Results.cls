@RestResource (urlMapping ='/bruteforce/*')
global class Post_Results {
       
    @HttpPost
    global static String doPost(RestRequest req, RestResponse res, Integer wins, Integer losses, Integer ties) {
        Result_Set__c myResultSet = new Result_Set__c(Win__c = wins, Loss__c = losses, Tie__c = ties);
        insert myResultSet;
        
        return 'OK';
    }    
    
    @HttpPut
    global static Map<String, Decimal> doPut(RestRequest req, RestResponse res, Integer wins, Integer losses, Integer ties) {
        Summation__c mySummation = [SELECT Id, Total_Wins__c, Total_Losses__c, Total_Ties__c, Win_Ratio__c, Total_Games__c FROM Summation__c LIMIT 1];
        Result_Set__c myResultSet = new Result_Set__c(Summation__c = mySummation.Id, Win__c = wins, Loss__c = losses, Tie__c = ties);
        insert myResultSet;
        Map<String, Decimal> myMap = new Map<String, Decimal>();
        
        
        myMap.put('wins', mySummation.Total_Wins__c);
        myMap.put('losses', mySummation.Total_Losses__c);
        myMap.put('ties', mySummation.Total_Ties__c);
        myMap.put('Win Ratio', mySummation.Win_Ratio__c);
        myMap.put('total games', mySummation.Total_Games__c);
        return myMap;
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