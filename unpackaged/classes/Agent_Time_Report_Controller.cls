public with sharing class Agent_Time_Report_Controller {
	public List<Work_Time__c> getTopTenWorkTimes(){
		DateTime last7days = system.now().addDays(-7);
		List<Work_Time__c> topTenWorkTimes = [SELECT Id
													,Case__c
													,Case__r.Subject
													,Case__r.CaseNumber
													,Case__r.Priority
													,Total_Agent_Work_Time__c 
											   FROM  Work_Time__c 
											   WHERE Last_Session__c > :last7days
											   order by Time_in_Seconds__c desc limit 10];
		return topTenWorkTimes;
	}
	
	public integer getTotalSupportTime(){
		DateTime last24Hours = system.now().addHours(-24);
		system.debug (last24Hours);
		double runningTotal = 0;
		List<Agent_Work_Time__c> myAgentWorkTimes = [SELECT Id, Time_in_Seconds__c FROM Agent_Work_Time__c WHERE Last_Ping__c > : last24Hours];
		
		for (Agent_Work_Time__c myAgentWorkTime : myAgentWorkTimes){
			if (myAgentWorkTime.Time_in_Seconds__c != null){
				runningTotal = runningTotal + myAgentWorkTime.Time_in_Seconds__c;
			}
		}
		return integer.valueOf(runningTotal)/60;
	}
	
	public static List<AggregateResult> getUserTimes(){
		List<AggregateResult> userTimes = [SELECT CreatedById, CreatedBy.Name ownerName, sum(Time_in_Seconds__c)sum FROM Agent_Work_Time__c GROUP BY CreatedById, CreatedBy.Name ORDER BY sum(Time_in_Seconds__c) desc];
		return userTimes;
	}
}