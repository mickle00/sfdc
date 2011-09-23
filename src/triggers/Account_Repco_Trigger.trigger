trigger Account_Repco_Trigger on Account_Repco__c (before insert, after delete) {
	Account_Repco_Class accountRepcoObj = new Account_Repco_Class();
	
	if (trigger.isBefore && trigger.isInsert){
		accountRepcoObj.indexAccountRepcos(trigger.New);
	}	

	if (trigger.isDelete && trigger.isAfter){
		accountRepcoObj.reIndexAccountRepcos(trigger.Old);
	}		
}