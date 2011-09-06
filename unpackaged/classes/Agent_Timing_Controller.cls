public class Agent_Timing_Controller {
	
	// the top window URL. Can't use the URL from the Visualforce page in the iframe.
	// Passing from home page iframe to visualforce page via querystring
	public final String browserURL;
    public final Id myCaseId;    
    public final DateTime timeLoaded;
    public Case myCase;
    public Id myAgentWorkingTimeId;
    public Integer pingCount = 0;
    

	// Can't do DML in constructor so instead using jquery onLoad/unLoad
    public Agent_Timing_Controller() {
    	timeLoaded = system.now();
    	browserURL = ApexPages.currentPage().getParameters().get('browserURL');
    	myCaseId   = isRelatedToCase(browserURL);    	    	
	}
	    
    // Can't do DML in Constructor. Calling this from javascript window.onload
    // Visualforce page in iframe
    public void startTimeController(){
    	system.debug('ENTERING startTimeController');
    	if (myCaseId != null && browserURL != null){
    		myAgentWorkingTimeId = startAgentWorkingTime(myCaseId, browserURL);
    	}
    	cleanupTimeouts();
    	system.debug('EXITING startTimeController');
    }
    // used in javascript window.onbeforeunload 
    public void stopTimeController() {
    	system.debug('ENTERING stopTimeController');
		if (myAgentWorkingTimeId != null){
			stopAgentWorkingTime(myAgentWorkingTimeId);		
		}
		system.debug('EXITING stopTimeController');
    } 
    
    public string getWatchingYou(){
    	system.debug('ENTERING getWatchingYou');
   		if(myCaseId != null){
			Case myCase = getCase(myCaseId);
			if (logTime(myCase)){
				return myCase.CaseNumber;
			}   			
		}
		system.debug('EXITING getWatchingYou');
    	return null;
    }
    public string getLoggingStatus(){
    	system.debug('ENTERING/EXITING getLoggingStatus');
		return getUrlContext(browserURL, myCaseId);
    }
    
    public boolean getRelatedToCase(){
    	system.debug('ENTERING/EXITING getRenderWatchingYou');
    	if (getWatchingYou() == null) return false;
    	return true; 
    }
    
	public PageReference pingWorkTime() {
		pingCount++;
		pingTime();
		return null;
	}
	public Integer getPingCount() {
		return pingCount;
	}

	private void pingTime(){
		if (myAgentWorkingTimeId != null){
			Agent_Work_Time__c myAgentWorkTime = [SELECT  Id
														 ,Last_Ping__c
														 ,Time_In_Seconds__c
														 ,Start_Time__c
												    FROM  Agent_Work_Time__c 
											       WHERE  Id = :myAgentWorkingTimeId];
			myAgentWorkTime.Last_Ping__c = system.now();
			myAgentWorkTime.Time_In_Seconds__c = (myAgentWorkTime.Last_Ping__c.getTime() - myAgentWorkTime.Start_Time__c.getTime()) / 1000;
			update myAgentWorkTime;
		}
	}
    
    private Id startAgentWorkingTime(Id myCaseId, string myURL) {
    	system.debug('ENTERING startAgentWorkingTime');
    	Case myCase = getCase(myCaseId);
    	if (logTime(myCase)){
    		Work_Time__c myWorkTime = getWorkTime(myCase);
    		Agent_Work_Time__c myAgentWorkTime = getAgentWorkTime(myWorkTime, myCase, myURL);    		  		
	        upsert myAgentWorkTime;
	        return myAgentWorkTime.Id;
    	}
    	system.debug('EXITING startAgentWorkingTime');
    	return null;
    }
    
    private Id stopAgentWorkingTime(Id agentWorkingId) {
    	system.debug('ENTERING stopAgentWorkingTime');
    	system.debug ('stopAgentWorkingTime agentWorkingId is: ' + agentWorkingId);
        Agent_Work_Time__c myAgentWorkTime = getAgentWorkTime(agentWorkingId);
        if (myAgentWorkTime.Session_Count__c > 1){
        	system.debug('SESSION COUNT IS: ' + myAgentWorkTime.Session_Count__c);
        } else{
        	myAgentWorkTime.Stop_Time__c = system.now();
        	myAgentWorkTime.Time_In_Seconds__c = (myAgentWorkTime.Stop_Time__c.getTime() - myAgentWorkTime.Start_Time__c.getTime()) / 1000; // returns milliseconds; convert to seconds
        }
        myAgentWorkTime.Session_Count__c = myAgentWorkTime.Session_Count__c - 1;
        update myAgentWorkTime;
        system.debug('EXITING stopAgentWorkingTime');
        return myAgentWorkTime.Id;
    }

    private Id isRelatedToCase(string myURL){
    	system.debug('ENTERING isRelatedToCase');	
    	// looking for 15 or 18 digit ID, minus the initial 500
    	String caseIdRegex = '(500\\w{12,15}?)'; // double slash to escape \w
    	Pattern MyPattern = Pattern.compile(caseIdRegex);
		Matcher MyMatcher = MyPattern.matcher(myURL);
				
		if (MyMatcher.find()) {
			// always returns 18 digit ID, even if regex only matches 15
			return MyMatcher.group();
		} else{
			// URLs that might be related to a Case, but do not contain the Case ID
        	if (isViewingCaseEmailMessage(myURL) != null) return isViewingCaseEmailMessage(myURL);
		}
		system.debug ('URL: ' + myURL + ' IS NOT RELATED TO A CASE');
		system.debug('EXITING isRelatedToCase');	
    	return null;
    }    
    
    private Id isViewingCaseEmailMessage(string myURL){
    	system.debug('ENTERING isViewingCaseEmailMessage');
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
		system.debug('EXITING isViewingCaseEmailMessage');
		return null;		
    }
    
    private string getUrlContext(string myURL, string myCaseId){
    	system.debug('ENTERING getUrlContext');    	
        //String sfdcURL = URL.getSalesforceBaseUrl().toExternalForm() + '/';
        String sfdcURL = 'https://na12.salesforce.com/';
        String fullLowercaseCaseId = string.valueOf(myCaseId).toLowerCase();
        String lowercaseCaseId = string.valueOf(myCaseId).substring(0,15).toLowerCase();       
        
        if (myURL.toLowerCase().equals(sfdcURL.toLowerCase() + lowercaseCaseId)) return 'Viewing the Case';
        if (myURL.toLowerCase().equals(sfdcURL.toLowerCase() + fullLowercaseCaseId)) return 'Viewing the Case'; // hack to also look for 18 digit ID
        if (myURL.toLowerCase().contains('def_parent_id')) return 'Creating a Child Case';
        if (myURL.toLowerCase().contains('cloneparent')) return 'Creating a Child Case';
        if (myURL.toLowerCase().contains('clone')) return 'Cloning the Case';
        if (myURL.toLowerCase().contains(sfdcURL.toLowerCase() + lowercaseCaseId + '/e?')) return 'Editing the Case';
        if (myURL.toLowerCase().contains(sfdcURL.toLowerCase() + lowercaseCaseId + '/s?')) return 'Closing the Case';
        if (myURL.toLowerCase().contains('emailauthor?')) return 'Sending an Email';
        if (myURL.toLowerCase().contains('/02s')) return 'Viewing an Email';
        if (myURL.toLowerCase().contains('/00a/')) return 'Adding Case Comments';
        if (myURL.toLowerCase().contains('noteattach?')) return 'Adding Notes & Attachments';
        if (myURL.toLowerCase().contains('/00t/')) return 'Adding a Task';
        if (myURL.toLowerCase().contains('/00u/')) return 'Adding an Event';
        if (myURL.toLowerCase().contains('solutionsearch')) return 'Searching for a Solution';
        if (myURL.toLowerCase().contains('solutionsuggestion')) return 'Viewing Suggested Solutions';
        
        system.debug('EXITING getUrlContext');
        return myURL;
    }
    
    // run to cleanup AgentWorkTime sessions that were previously pinging
	// but the window.onbeforeunload never fired (seems to happen ~5% of the time)
	// don't know the best time to implement this.
	private void cleanupTimeouts(){
		DateTime oneMinuteAgo = system.now().addMinutes(-1);
		List <Agent_Work_Time__c> agentWorkTimeouts = [SELECT  Id
															  ,Last_Ping__c
															  ,Start_Time__c
															  ,Stop_Time__c
															  ,Session_Count__c
															  ,Time_In_Seconds__c 
													     FROM  Agent_Work_Time__c 
													    WHERE  Stop_Time__c = null 
													      AND  Last_Ping__c < :oneMinuteAgo];
		for (Agent_Work_Time__c agentWorkTimeout : agentWorkTimeouts){
			agentWorkTimeout.Stop_Time__c       = agentWorkTimeout.Last_Ping__c;
			agentWorkTimeout.Session_Count__c   = 0;
			agentWorkTimeout.Time_In_Seconds__c = (agentWorkTimeout.Last_Ping__c.getTime() - agentWorkTimeout.Start_Time__c.getTime()) / 1000; // returns milliseconds; convert to seconds			
		}
		update agentWorkTimeouts;		
	}
	
    private Case getCase(string myCaseId){
    	system.debug('ENTERING getCase');
    	if(myCase == null){
	    	myCase = [SELECT  Id
	    					 ,CaseNumber
	    					 ,Status
	    					 ,isClosed
	    					 ,CreatedDate
					    FROM  Case
					   WHERE  Id = :myCaseId];
    	}
	   system.debug('EXITING getCase');
	   return myCase;    	
    }
    
    private Work_Time__c getWorkTime(Case myCase){
    	system.debug('ENTERING getWorkTime');
    	Work_Time__c myWorkTime;
    	try{
    		myWorkTime = [SELECT Id FROM Work_Time__c WHERE Case__c = :myCase.Id limit 1];
    	}catch (Exception e){
    		Double timeSinceCaseCreated = (timeLoaded.getTime() - myCase.CreatedDate.getTime()) / 1000; // returns milliseconds
    		myWorkTime = new Work_Time__c(Case__c = myCase.Id, Time_to_First_View_Seconds__c = timeSinceCaseCreated);
    		insert myWorkTime;
    	}
    	system.debug('EXITING getWorkTime');
    	return myWorkTime;    	
    }
    
    private Agent_Work_Time__c getAgentWorkTime(Work_Time__c myWorkTime, Case myCase, string myURL){
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
    						      AND Type__c = :getUrlContext(myURL, myCase.Id)
    						      AND CreatedById = :UserInfo.getUserId()
    						      AND Stop_Time__c = null];
		    myAgentWorkTime.Session_Count__c = myAgentWorkTime.Session_Count__c + 1;
		}catch (Exception e){
    		system.debug('DOESNT HAVE A SESSION ALREADY OPEN, CREATING NEW AGENT WORK TIME');
	       	myAgentWorkTime = new Agent_Work_Time__c(Work_Time__c = myWorkTime.Id
        														   ,Start_Time__c = timeLoaded
        														   ,Type__c = getUrlContext(myURL, myCase.Id)
        														   ,Session_Count__c = 1
        														   ,URL__c = myURL
        														   ,During_Case_Status__c = myCase.Status);
		}
		return myAgentWorkTime;
    }
    
    private Agent_Work_Time__c getAgentWorkTime(Id myAgentWorkTimeId){
    	Agent_Work_Time__c myAgentWorkTime = [SELECT  Id
    												 ,Start_Time__c
    												 ,Stop_Time__c
    												 ,Session_Count__c 
												FROM  Agent_Work_Time__c 
											   WHERE  Id = :myAgentWorkTimeId];
		return myAgentWorkTime;
    }  
    
    private boolean logTime(Case myCase){
    	system.debug('ENTERING logTime');
    	// REMOVED FOR TESTING 
    	// Profile adminProfile = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
    	// if (UserInfo.getProfileId() == adminProfile.Id) return false;
    	if (myCase.IsClosed == true) return false;
    	system.debug('EXITING logTime');
    	return true;
    }
}