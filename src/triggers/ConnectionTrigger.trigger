trigger ConnectionTrigger on Connection__c (before insert) {
    ConnectionClass connectionObj = new ConnectionClass();
    
    if (trigger.isBefore && trigger.isInsert){
        connectionObj.buildConnectionIntegrationKeys(trigger.New);
    }
}