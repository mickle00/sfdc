trigger RolloutStepTrigger on Rollout_Step__c (after insert) {
    Map<Id, String> connectionStatusMap = new Map<Id, String>();
    Map<Id, Integer> mappingChasers = new Map<Id, Integer>();
    Map<Id, Integer> enrollmentChasers = new Map<Id, Integer>();
    
    for (Rollout_Step__c rolloutStep : trigger.New){
        connectionStatusMap.put(rolloutStep.Connection__c, rolloutStep.Rollout_Step__c);
        if(rolloutStep.Rollout_Step__c.contains('Mapping Chaser')){
            mappingChasers.put(rolloutStep.Connection__c, 1);
        }
        if(rolloutStep.Rollout_Step__c.contains('Enrollment Chaser')){
            enrollmentChasers.put(rolloutStep.Connection__c, 1);
        }
    }

    List<Connection__c> myConnections = [SELECT Id
                                               ,Status__c
                                               ,Number_of_Enrollment_Chasers__c
                                               ,Number_of_Mapping_Chasers__c 
                                           FROM Connection__c 
                                          WHERE Id In :connectionStatusMap.keySet()];
    
    for (Connection__c myConnection : myConnections){
        myConnection.Status__c = connectionStatusMap.get(myConnection.Id);
        if (enrollmentChasers.containsKey(myConnection.Id)){
            myConnection.Number_of_Enrollment_Chasers__c = myConnection.Number_of_Enrollment_Chasers__c + enrollmentChasers.get(myConnection.Id);
            myConnection.Last_Interaction__c = system.now();
        }  
        if (mappingChasers.containsKey(myConnection.Id)){
            myConnection.Number_of_Mapping_Chasers__c = myConnection.Number_of_Mapping_Chasers__c + mappingChasers.get(myConnection.Id);
            myConnection.Last_Interaction__c = system.now();
        }
        if (myConnection.Status__c == 'Enrollment Form Sent' || myConnection.Status__c == 'Mapping Information Sent' ){
            myConnection.Last_Interaction__c = system.now();
        }  
    }
    update myConnections;
    
    //TODO BEFORE DELETE
}