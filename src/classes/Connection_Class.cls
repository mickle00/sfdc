public with sharing class Connection_Class {
	
	// WHAT HAPPENS IF THERE ARE TWO CONNECTIONS OF THE SAME TYPE & PLATFORM FOR AN ACCOUNT
	// SHOULD UPDATE TO ONLY FILTER FOR CONNECTIONS IN THE 'CONNECTED' STATUS
	public void buildConnectionIntegrationKeys(List<Connection__c> myConnections){
		String concatenator = ':'; //hasta la vista, baby
		for (Connection__c myConnection : myConnections){
				myConnection.Integration_Connection_Key__c =  myConnection.PSG_Account_ID__c + concatenator
															+ myConnection.Type__c + concatenator
															+ myConnection.Platform__c;
		}		
	}
	
	public static Connection__c getConnection(Id connectionId){
		Connection__c myConnection = [SELECT Id
									        ,Name
						                    ,Account__c
						                    ,Account__r.Name
						                    ,Account__r.Id
						                    ,Type__c
						                    ,Status__c
						                    ,Platform__c
						                    ,Go_Date__c
						                    ,LastModifiedDate
						                    ,Connectivity_System__c
						                    ,Connectivity_System__r.Connectivity_System_Type__c 
						                    ,Account_Repco__c
						                    ,Account__r.Market_Manager_Email__c
						                    ,Account__r.Market_Manager_Name__c
						                    ,Connectivity_System__r.Connectivity_Vendor__c
						               FROM Connection__c
						              WHERE Id = :connectionId];
    	return myConnection;
	}
	
	public static List<Connection__c> getConnectionsByAccountId (Id accountId){
	    return [SELECT  Id
					   ,Name 
	                   ,Connectivity_System__c
	                   ,Connectivity_System__r.Connectivity_Vendor__r.Name
	                   ,Connectivity_System__r.Connectivity_System_Type__c
	                   ,Type__c
	                   ,Status__c
	                   ,Platform__c
	                   ,Go_Date__c
	                   ,LastModifiedDate
	                   ,LastModifiedBy.FirstName
	                   ,LastModifiedBy.LastName 
	            FROM  Connection__c 
	           WHERE  Account__c = :accountId
	        ORDER BY  LastModifiedDate DESC];
	}
}