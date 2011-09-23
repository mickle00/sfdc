trigger Connection_Trigger on Connection__c (before insert) {
	Connection_Class connectionObj = new Connection_Class();
	
	if (trigger.isBefore && trigger.isInsert){
		connectionObj.buildConnectionIntegrationKeys(trigger.New);
	}
}