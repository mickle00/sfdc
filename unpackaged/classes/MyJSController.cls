global class MyJSController {
    public String browserURL {
    	get{
    		return browserURL;
    	} set{
    		browserURL = ApexPages.currentPage().getParameters().get('browserURL');
	 	}
    }  
    public MyJSController() {
    	this.browserURL = ApexPages.currentPage().getParameters().get('browserURL');
	}
	
	/**
	public string myLastName {get; set;}
	     
    public void doString() {
    	string lastName = Apexpages.currentPage().getParameters().get('lastName');
    	Lead myLead = new Lead(LastName = 'didntwork', Company='TEST3'+lastName, Status='OPEN');
    	insert myLead;
    }
    **/
    
    @RemoteAction
    global static string printSystemDebug(string testString){
    	system.debug('PRINTING SYSTEM DEBUG');
    	return 'worked';
    }
    
	@RemoteAction
    global static string startAgentWorkingTime(string myCaseId, string myURL) {
    	system.debug ('startAgentWorkingTime myCaseId is: ' + myCaseId);
    	system.debug ('startAgentWorkingTime myURL is: ' + myURL);
    	Case myCase = getCase(myCaseId);
    	if (logTime(myCase)){
    		Work_Time__c myWorkTime = getWorkTime(myCase);
    		Agent_Work_Time__c myAgentWorkTime;
    		try{
    			myAgentWorkTime = [SELECT Id
    									 ,Work_Time__c
    									 ,Start_Time__c
    									 ,Stop_Time__c
    									 ,CreatedById
    									 ,Type__c
    									 ,URL__c
    									 ,Session_Count__c 
    								FROM Agent_Work_Time__c 
    							   WHERE Work_Time__c = :myWorkTime.Id 
    							     AND Type__c = :getUrlContext(myURL, myCaseId)
    							     AND CreatedById = :UserInfo.getUserId()
    							     AND Stop_Time__c = null];
		     	myAgentWorkTime.Session_Count__c = myAgentWorkTime.Session_Count__c + 1;
    		} catch (Exception e){
	        	myAgentWorkTime = new Agent_Work_Time__c(Work_Time__c = myWorkTime.Id
        															   ,Start_Time__c = system.now()
        															   ,Type__c = getUrlContext(myURL, myCaseId)
        															   ,Session_Count__c = 1
        															   ,URL__c = myURL
        															   ,During_Case_Status__c = myCase.Status);
    		}    		
	        upsert myAgentWorkTime;
	        return myAgentWorkTime.Id;
    	}
    	return null;
    }
    
    @RemoteAction
    global static string stopAgentWorkingTime(string agentWorkingId) {
    	system.debug ('stopAgentWorkingTime agentWorkingId is: ' + agentWorkingId);
        Agent_Work_Time__c myAgentWorkTime = [SELECT Id, Start_Time__c, Stop_Time__c, Session_Count__c FROM Agent_Work_Time__c WHERE Id = :agentWorkingId];
        if (myAgentWorkTime.Session_Count__c > 1){
        	system.debug('THERE IS ALREADY ANOTHER SESSION. MOST LIKELY ANOTHER TAB OPEN');
        } else{
        	myAgentWorkTime.Stop_Time__c = system.now();
        	myAgentWorkTime.Time_In_Seconds__c = (myAgentWorkTime.Stop_Time__c.getTime() - myAgentWorkTime.Start_Time__c.getTime()) / 1000; // returns milliseconds; convert to seconds
        }
        myAgentWorkTime.Session_Count__c = myAgentWorkTime.Session_Count__c - 1;
        update myAgentWorkTime;
        return myAgentWorkTime.Id;
    }
    
    public void stopTime() {
    	string agentWorkingId = Apexpages.currentPage().getParameters().get('agentWorkingTimeId');
    	
    	if (agentWorkingId != ''){
	    	system.debug ('stopAgentWorkingTime agentWorkingId is: ' + agentWorkingId);
	        Agent_Work_Time__c myAgentWorkTime = [SELECT Id, Start_Time__c, Stop_Time__c, Session_Count__c FROM Agent_Work_Time__c WHERE Id = :agentWorkingId];
	        if (myAgentWorkTime.Session_Count__c > 1){
	        	system.debug('THERE IS ALREADY ANOTHER SESSION. MOST LIKELY ANOTHER TAB OPEN');
	        } else{
	        	myAgentWorkTime.Stop_Time__c = system.now();
	        	myAgentWorkTime.Time_In_Seconds__c = (myAgentWorkTime.Stop_Time__c.getTime() - myAgentWorkTime.Start_Time__c.getTime()) / 1000; // returns milliseconds; convert to seconds
	        }
	        myAgentWorkTime.Session_Count__c = myAgentWorkTime.Session_Count__c - 1;
	        update myAgentWorkTime;
    	} else{
    		system.debug('THERE IS NO AGENT WORKING TIME');
    	}
    }
      
    @RemoteAction
    global static string isRelatedToCase(string myURL){
    	system.debug ('isRelatedToCase myURL is: ' + myURL);
    	// double slash to escape \w
    	// looking for 15 or 18 digit ID, minus the initial 500
    	String caseIdRegex = '(500\\w{12,15}?)';   	
    	Pattern MyPattern = Pattern.compile(caseIdRegex);

		// Then instantiate a new Matcher object "MyMatcher"
		Matcher MyMatcher = MyPattern.matcher(myURL);
				
		if (MyMatcher.find()) {
			// always returns 18 digit ID, even if regex only matches 15
			return MyMatcher.group();
		} else{
			// URLs that might be related to a Case, but do not contain the Case ID
			system.debug('CHECKING TO SEE IF URL IS POSSIBLY RELATED TO A CASE THAT DOESNT CONTAIN CASE ID');
        	if (isViewingCaseEmailMessage(myURL) != null){
        		 return isViewingCaseEmailMessage(myURL);
        	}  	
		}
		//couldn't find a caseID in the URL
		system.debug ('NOT RELATED TO A CASE');
    	return null;
    }
    
    
    private static string isViewingCaseEmailMessage(string myURL){
    	system.debug('in isViewingEmailMessage');
    	if (myURL.toLowerCase().contains('/02s')){
    		String emailIdRegex = '(02s\\w{12,15}?)';   	
    		Pattern MyPattern = Pattern.compile(emailIdRegex);
    		Matcher MyMatcher = MyPattern.matcher(myURL);
    		if (MyMatcher.find()){
    			Id emailId = MyMatcher.group();
    			system.debug(emailId);
    			try{
    				Id myCaseId = [SELECT ParentId FROM EmailMessage WHERE Id = :emailId].ParentId;
    				return myCaseId;
    			} catch (Exception e){
    				system.debug('isViewingEmailMessage Exception: ' + e);
    			}
    		}		    	
		}
		return null;		
    }
    
    global static string getUrlContext(string myURL, string myCaseId){    	
        system.debug('myURL: ' + myURL);
        system.debug('myCaseId: ' + string.valueOf(myCaseId).substring(0,15));
        //String sfdcURL = URL.getSalesforceBaseUrl().toExternalForm() + '/';
        String sfdcURL = 'https://na12.salesforce.com/';
        //String sfdcURL = sfdcUrl();
        String lowercaseCaseId = string.valueOf(myCaseId).substring(0,15).toLowerCase();
        system.debug('SALESFORCE URL: ' + sfdcURL);        
        
        if (myURL.toLowerCase().equals(sfdcURL.toLowerCase() + lowercaseCaseId)) return 'Viewing the Case';
        if (myURL.toLowerCase().contains(sfdcURL.toLowerCase() + lowercaseCaseId + '/e?')) return 'Editing the Case';
        if (myURL.toLowerCase().contains(sfdcURL.toLowerCase() + lowercaseCaseId + '/s?')) return 'Closing the Case';
        if (myURL.toLowerCase().contains('emailauthor?')) return 'Sending an Email';
        if (myURL.toLowerCase().contains('/02s')) return 'Viewing an Email';
        if (myURL.toLowerCase().contains('/00a/')) return 'Adding Case Comments';
        if (myURL.toLowerCase().contains('noteattach?')) return 'Adding Notes & Attachments';
        if (myURL.toLowerCase().contains('/00t/')) return 'Adding a Tasks';
        
        return myURL;
    }
    
	private static String sfdcUrl(){
		String myURL = URL.getSalesforceBaseUrl().toExternalForm() + '/';
		system.debug('SYSTEMURLIS: ' + myURL);
		System.debug('Host: ' + URL.getSalesforceBaseUrl().getHost()); 
		if (myURL.contains('-api')){
			myURL = myURL.replaceFirst('-api', '');
		}
		return myURL;
	}
    
    private static Case getCase(string myCaseId){
    	system.debug('myCaseId is: ' + myCaseId);
    	Case myCase = [SELECT Id
    						 ,CaseNumber
    						 ,Status
    						 ,isClosed
    						 ,CreatedDate
					    FROM Case
					   WHERE Id = :myCaseId];
	   
	   return myCase;    	
    }
    
    private static Work_Time__c getWorkTime(Case myCase){
    	Work_Time__c myWorkTime;
    	try{
    		myWorkTime = [SELECT Id FROM Work_Time__c WHERE Case__c = :myCase.Id];
    	}catch (Exception e){
    		Double timeSinceCaseCreated = (system.now().getTime() - myCase.CreatedDate.getTime()) / 1000;
    		myWorkTime = new Work_Time__c(Case__c = myCase.Id, Time_to_First_View_Seconds__c = timeSinceCaseCreated);
    		insert myWorkTime;
    	}
    	return myWorkTime;    	
    }
    
    private static boolean logTime(Case myCase){
    	// REMOVED FOR TESTING 
    	// Profile adminProfile = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
    	// if (UserInfo.getProfileId() == adminProfile.Id) return false;
    	// if (myCase.IsClosed == true) return false;
    	return true;
    }      
}