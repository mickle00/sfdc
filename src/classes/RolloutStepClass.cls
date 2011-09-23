public with sharing class RolloutStepClass {
	
	public static List<Rollout_Step__c> getRolloutStepsByConnectionId(Id connectionId){
		return [SELECT Id
                      ,Rollout_Step__c
                      ,OwnerId
                      ,Completed_Date__c
                      ,Case__c
                      ,Owner.Name
                 FROM  Rollout_Step__c
                WHERE  Connection__c = :connectionId
             order by Completed_Date__c asc nulls last];
	}
	
	public static Rollout_Step__c getRolloutStepById(Id rolloutStepId){
		return [SELECT Id
				  FROM Rollout_Step__c
				 WHERE Id = :rolloutStepId];
	}
	
    //Upsering a list touches even unchanged records. This simply pulls out the new steps and inserts them.
    public static void insertNewRolloutSteps(List<Rollout_Step__c> myRolloutSteps){
    	List<Rollout_Step__c> rolloutStepsToInsert = new List<Rollout_Step__c>();
    	for (Rollout_Step__c myRolloutStep : myRolloutSteps){
    		if (myRolloutStep.Id == null){
    			rolloutStepsToInsert.add(myRolloutStep);
    		}
    	}
    	if (rolloutStepsToInsert.size() > 0) insert rolloutStepsToInsert;    	
    }

}