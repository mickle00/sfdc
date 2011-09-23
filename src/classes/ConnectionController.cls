public class ConnectionController{
  
    public Connection__c myConnection {get; set;}
    public Connection__c myConnectionOld; // SHOULD REMOVE AND PUT LOGIC IN CONNECTION_CLASS
    public Case myCase {get; set;}
    public Note myNote {get; set;}
    public Rollout_Step__c myConnectivityRollout {get; set;}
    public List<Rollout_Step__c> myConnectivityRollouts {get; set;}    
    public List<Connection__c> accountConnections{get; set;}
    public List<Note> allNotes{get; set;}
    public boolean isCreatingNewConnection {get; set;}   
    public boolean renderConnectionDetails {get; set;}
    public final id originalCaseId{get; set;}
    public integer numberAdditionalRolloutSteps{get;set;}
    public Id rolloutStepToDelete{get;set;}
    public Id connectionIdToEdit {get; set;}
    public EmailWidgetWrapper myEmailWidget{get; set;}
    
    public ConnectionController(ApexPages.StandardController stdController){
    	this.myConnection = (Connection__c)stdController.getRecord();
    	renderConnectionDetails = false;
    	numberAdditionalRolloutSteps = 0;    	
        if (ApexPages.currentPage().getParameters().containsKey('CaseID')){           
           renderConnectionDetails = false;
           if (ApexPages.currentPage().getParameters().containsKey('new'))renderConnectionDetails = true;
           originalCaseId = ApexPages.currentPage().getParameters().get('CaseID');
           this.NewConnectionFromCase();
        }
        if(ApexPages.currentPage().getParameters().containsKey('Id')){
        	this.ExistingConnection(ApexPages.currentPage().getParameters().get('Id'));        	
        	myEmailWidget = new EmailWidgetWrapper(myConnection, originalCaseId);
        }    
        myNote = new Note();        
        this.buildAccountConnections();
        
        if(myConnection.Account__c == null){
            this.noAccount();
        }       
    }
    
    public string getTitle(){
        if (isCreatingNewConnection == true) return 'New Connection';        
        return 'Edit Connection';
    }
    
    // Have to grab the account name this way, as on new connections myConnection.Account__r.Name doesn't work
    public string accountName {
        get{
            if (accountName == null){
                try {
                    Account myAccount = [SELECT Name FROM Account WHERE Id = :myConnection.Account__c];
                    this.accountName = myAccount.Name;
                    }
                catch (Exception e){
                    system.debug(e);
                }
            }
            return accountName;            
        }
        set;
    }
    
    public PageReference newConnection(){
        renderConnectionDetails = true;        
        Case myCase = getCase(originalCaseId);
        myConnection = new Connection__c(Account__c = myCase.AccountId, Status__c = 'Connecting');
        return null;
    }
   	
    public PageReference editConnection(){
        PageReference editConnectionPage = new PageReference ('/apex/ManageConnection?Id=' + connectionIdToEdit +'&'+ getCaseQueryString());
        editConnectionPage.setRedirect(true); 
        this.ExistingConnection(connectionIdToEdit);
        return editConnectionPage;
    }
        
    public boolean getRenderExistingConnections(){
        return accountConnections.size() > 0 && accountName != null;
    }
    
    public List<Account_Repco__c> getAccountRepcos(){    	
    	return AccountRepcoClass.getAccountRepcosByAccountId(myConnection.Account__c);
    }
    
    public integer getAccountRepcoSize(){
    	return getAccountRepcos().size();
    }
    
	public List<selectOption> getAvailableAccountRepcos() {
		List<selectOption> options = new List<selectOption>(); 
		options.add(new selectOption('', '- None -')); 
		//add the first option of '- None -' in case the user doesn't want to select a value or in 
		//case no values are returned from query below
		
		for (Account_Repco__c myAccountRepco : getAccountRepcos()) { 
			options.add(new selectOption(myAccountRepco.Id, myAccountRepco.Repco__r.Name)); 
		}
		return options;
	}
	
    public void addRolloutStage(){
        Rollout_Step__c newConnectivityRollout = new Rollout_Step__c(Case__c = originalCaseId, Connection__c = myConnection.Id, Completed_Date__c = system.now());
        numberAdditionalRolloutSteps++;
        myConnectivityRollouts.add(newConnectivityRollout);
    }
    
    public void removeRolloutStage(){
    	numberAdditionalRolloutSteps--;       
        myConnectivityRollouts.remove(myConnectivityRollouts.size()-1);
    }
    
    public void deleteRolloutStep(){
    	Rollout_Step__c rolloutToDelete = RolloutStepClass.getRolloutStepById(rolloutStepToDelete);
    	delete rolloutToDelete;
    	rolloutStepToDelete = null;
   		myConnectivityRollouts = RolloutStepClass.getRolloutStepsByConnectionId(myConnection.Id);
          if (myConnectivityRollouts.size() == 0){
              this.buildConnectivityRollouts();
          }
    }

    public PageReference Save(){
    	// TODO CHECK FOR UPDATES BEFORE UPSERTING
        try{
            this.updateConnection(myConnection, myConnectionOld);
            this.insertNote();
            RolloutStepClass.insertNewRolloutSteps(myConnectivityRollouts);
            myConnection = Connection_Class.getConnection(myConnection.Id);
            allNotes = getNotes(myConnection.Id);
            this.refreshData();
            return null;
        }catch (Exception e){
        	system.debug('THERE BE AN EXCEPTION' + e);
            return null;
        }           
    }
    
    public PageReference createNewConnection(){
        PageReference newConnectionURL = new PageReference('/apex/ManageConnection?CaseID='+myCase.Id+'&new=true');
        newConnectionURL.setRedirect(true); // clear the viewstate
        return newConnectionURL;
    }
  
  	public PageReference Cancel(){
  		PageReference refreshPage = ApexPages.currentPage();
  		refreshPage.setRedirect(true);
  		return refreshPage;
  	}
  
    public PageReference returnToCase(){
    	if (originalCaseId != null){
        	PageReference caseURL = new PageReference('/'+originalCaseId);
        	return caseURL;
    	}else{
    		PageReference homeURL = new PageReference('/');
    		return homeURL;
    	}
    }
    
    public string getCaseQueryString(){
    	return getCaseQueryString(originalCaseId);
    }
    
    public static string getCaseQueryString(Id myCaseId){
    	String caseQueryString = '';
    	if (myCaseId != null) caseQueryString = 'CaseID=' + myCaseId;
    	return caseQueryString;
    }
    
    private void refreshData(){
    	this.buildAccountConnections();
    }
    
    
    // MOVE TO CONNECTION CLASS
    private void updateConnection(Connection__c newConnection, Connection__c oldConnection){
    	/**
    	boolean isUpdated = false;
    	Map<String,Schema.SObjectField> connectionFieldMap = Connection__c.sObjectType.getDescribe().fields.getMap();

		for (String fieldName : connectionFieldMap.keySet()){
			if (newConnection.get(fieldName) != oldConnection.get(fieldName)) isUpdated = true;
			//system.debug(fieldName);
			//system.debug(connectionFieldMap.get(fieldName));
			
		}
		if (isUpdated) upsert newConnection;
		**/
		upsert newConnection;
    } 
        
    private void NewConnectionFromCase(){
        isCreatingNewConnection = true;
        myCase = getCase(originalCaseId);
                  
        if (myCase.AccountId == null){
            ApexPages.Message myError = new ApexPages.Message(ApexPages.Severity.FATAL, 'Warning - Case has no associated account, please update the case prior to creating a connection.');
            ApexPages.addMessage(myError);
        }
        myConnection = new Connection__c(Account__c = myCase.AccountId, Status__c = 'Connecting');
        this.buildConnectivityRollouts();
    }
    
    private void ExistingConnection(Id existingConnectionId){
        renderConnectionDetails = true;
        isCreatingNewConnection = false;        
        myConnection = new Connection__c();
        try{
        	myConnection = Connection_Class.getConnection(existingConnectionId);
        	myConnectionOld = myConnection.clone(true, true);
        }catch (Exception e){
        	system.debug('ConnectionController ExistingConnection Exception' + e);
        }                       
       
       try{
           allNotes = getNotes(myConnection.Id);   		  
   		   myConnectivityRollouts = RolloutStepClass.getRolloutStepsByConnectionId(myConnection.Id);
   		  
          if (myConnectivityRollouts.size() == 0){
              this.buildConnectivityRollouts();
          }
      } catch (Exception e){
          this.buildConnectivityRollouts();
      }
                         
    }
    
    public void buildAccountConnections(){
        // catch Accounts that do not have any existing connections
        try{
            accountConnections = Connection_Class.getConnectionsByAccountId(myConnection.Account__c);
                        
        }catch (Exception e) {
            system.debug ('Error: ' + e);
            accountConnections = new List<Connection__c>();
        }
    
    }
    
    private void buildConnectivityRollouts(){
          myConnectivityRollouts = new List<Rollout_Step__c>();
          myConnectivityRollout = new Rollout_Step__c(Case__c = originalCaseId, Connection__c = myConnection.Id, Completed_Date__c = system.now());
          myConnectivityRollouts.add(myConnectivityRollout);
    }
   
    private void noAccount(){  
        ApexPages.Message myError = new ApexPages.Message(ApexPages.Severity.FATAL, 'Warning - Case has no associated account, please update the case prior to creating a connection.');
        ApexPages.addMessage(myError);
    }    
    
    // ADD TO CASE CLASS??
   	private Case getCase(Id myCaseId){
    	Case myCase = [SELECT Id 
    						 ,AccountId    						 
    						 ,CaseNumber
    					 FROM Case 
    					WHERE Id = :myCaseId];
    	return myCase;    	
    }
    
    // ADD TO NOTE CLASS
    private void insertNote(){
        if (myNote.body != null || myNote.title != null){
            if (myNote.title == null) myNote.title = '(NONE)';
            myNote.ParentId = myConnection.Id;
            insert myNote;
        }
        myNote = new Note();
    }
    private List<Note> getNotes(Id myConnectionId){
    	List<Note> myNotes = [SELECT Title
    								,Body
    								,Owner.Name
    								,CreatedDate 
    						    FROM Note 
    						   WHERE ParentId = :myConnection.Id 
    						order by CreatedDate desc];
    	return myNotes; 
    }
    
    // ADD TO TASK CLASS   
    public List<Task> getAllEmails(){
    	List<Task> allEmails = new List<Task>();
    	allEmails = [SELECT Id
    					   ,Subject
    					   ,Description
    					   ,ActivityDate 
    				   FROM Task 
    				  WHERE WhatId = :myConnection.Id 
    				    AND Subject like 'Email%'
    			   order by ActivityDate desc];
    				    
    	return allEmails;
    } 
}