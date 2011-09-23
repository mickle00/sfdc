public with sharing class EmailWidgetWrapper {
	
	public EmailWidgetWrapper (Connection__c myConnection, id myCaseId){
		this.myConnection = myConnection;
		this.templates = getTemplates();
		this.hotelContacts = getHotelContacts();
		this.vendorContacts = getVendorContacts();
		this.systemContacts = getSystemContacts();
		this.marketManagers = getMarketManagers();
		this.accountTeamMembers = getAccountTeamMembers();
		this.myCaseId = myCaseId;
	}
	
	public List<SelectOption> templates {get; set;}
	public List<SelectOption> hotelContacts {get; set;}
	public List<SelectOption> vendorContacts {get; set;}
	public List<SelectOption> systemContacts {get; set;}
	public List<SelectOption> marketManagers {get; set;}
	public List<SelectOption> accountTeamMembers {get; set;}
	public Connection__c myConnection {get; set;}
	public string hotelContact{get; set;}
	public id myCaseId{get; set;}
	
    public List<String> selectedVendorContacts{
		get{
			if (selectedVendorContacts == null) selectedVendorContacts = new List<String>();
			return selectedVendorContacts;
		} set;
	}
    public List<String> selectedSystemContacts{
		get{
			if (selectedSystemContacts == null) selectedSystemContacts = new List<String>();
			return selectedSystemContacts;
		} set;
	}
    public List<String> selectedMarketManagers{
		get{
			if (selectedMarketManagers == null) selectedMarketManagers = new List<String>();
			return selectedMarketManagers;
		} set;
	}
    public List<String> selectedAccountTeamMembers{
		get{
			if (selectedAccountTeamMembers == null) selectedAccountTeamMembers = new List<String>();
			return selectedAccountTeamMembers;
		} set;
	}
	
	public string template {
		get{
			if (template == null) return '';
			return template;							
		}set;
	}
	
    public PageReference sendConnectivityEmail(){
    	String fromEmailAddress = 'connect.eqc@3b49lbjwy8aaythyiuc5i84z4.m9grhmay.m.apex.sandbox.salesforce.com';
    	String retURL = EncodingUtil.urlEncode('/apex/ManageConnection?Id=' + this.myConnection.Id + '&' + ConnectionController.getCaseQueryString(this.myCaseId), 'UTF-8');
    	
    	PageReference emailURL = new PageReference ('/email/author/emailauthor.jsp?'
    												+ 'retURL=' + retURL // RETURN URL 
    												+ '&p2_lkid=' + this.hotelContact // ContactID
    												+ '&p3_lkid=' + myConnection.Id // RELATED TO WHATID
    												//+ '&p2=' + '' // TO: (CONTACT NAME)									
    												//+ '&p24=' + ccAddresses() // ADDITIONAL TO
    												+ '&p4=' + ccAddresses() // CC ADDRESS
    												+ '&p26=' + fromEmailAddress // FROM ADDRESS
    												+ '&template_id=' + this.template
    												); 
    	emailURL.setRedirect(true);
    	return emailURL;   	
	}
	
	// PRIVATE METHODS
	
	private string ccAddresses(){
		string ccAddresses = '';		
		ccAddresses += flattenStringList(this.selectedVendorContacts);		
		ccAddresses += flattenStringList(this.selectedSystemContacts);
		ccAddresses += flattenStringList(this.selectedAccountTeamMembers);
		return ccAddresses;
	}
	
    private string flattenStringList(List<String> myList){
    	String myStrings = '';
    	if (myList != null){
			for (String myString : myList){
				myStrings = myStrings + myString + '; ';
			}
		}
    	return myStrings;
	}
	
	private List<SelectOption> getTemplates() {
    	List<EmailTemplate> templates = [SELECT Id 
    										   ,Name 
    									   FROM EmailTemplate 
    									  WHERE FolderId IN (SELECT Id 
    									  					   FROM Folder 
    									  					  WHERE Name = 'Connectivity')
					  				   order by Name asc];
    									  					  
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','-- None -- '));
        for (EmailTemplate myTemplate : templates){        
        	options.add(new SelectOption(myTemplate.Id,myTemplate.Name));
        }
        return options;
	}

    private List<SelectOption> getHotelContacts() {
        List<SelectOption> options = new List<SelectOption>();      
        List<Account_Contact__c> hotelContacts = [SELECT Id
        												,Contact__c
        												,Contact__r.Email
        												,Contact__r.FirstName
        												,Contact__r.LastName 
        										    FROM Account_Contact__c 
        										   WHERE Account__c = :myConnection.Account__c];
        for (Account_Contact__c hotelContact : hotelContacts){
        	options.add(new SelectOption(hotelContact.Contact__c,hotelContact.Contact__r.FirstName + ' ' + hotelContact.Contact__r.LastName));
        }
        options.add(new SelectOption('','-- None -- '));
        return options;
    } 

    private List<SelectOption> getVendorContacts() {
        List<SelectOption> options = new List<SelectOption>();        
    	List<Account_Contact__c> vendorContacts = [SELECT Id
        												,Contact__r.Email
        												,Contact__r.FirstName
        												,Contact__r.LastName 
        										    FROM Account_Contact__c 
        										   WHERE Account__c = :myConnection.Connectivity_System__r.Connectivity_Vendor__c];
        for (Account_Contact__c vendorContact : vendorContacts){
        	options.add(new SelectOption(vendorContact.Contact__r.Email,vendorContact.Contact__r.FirstName + ' ' + vendorContact.Contact__r.LastName));
        }
        return options;
    } 
 
    private List<SelectOption> getSystemContacts() {
        List<SelectOption> options = new List<SelectOption>();
        
        List<Connectivity_System_Contact__c> systemContacts = [SELECT Id
        															  ,Contact__r.Email
        															  ,Contact__r.FirstName
        															  ,Contact__r.LastName 
        										    			  FROM Connectivity_System_Contact__c 
        										   				 WHERE Connectivity_System__c = :myConnection.Connectivity_System__c];       
        for (Connectivity_System_Contact__c systemContact : systemContacts){
        	options.add(new SelectOption(systemContact.Contact__r.Email,systemContact.Contact__r.FirstName + ' ' + systemContact.Contact__r.LastName));
        }
        return options;
    }

    private List<SelectOption> getMarketManagers() {
        List<SelectOption> options = new List<SelectOption>(); 
        if (myConnection.Account__r.Market_Manager_Email__c != null && myConnection.Account__r.Market_Manager_Name__c != null){       
        	options.add(new SelectOption(myConnection.Account__r.Market_Manager_Email__c, myConnection.Account__r.Market_Manager_Name__c));
        }
        return options;
    }
    private List<SelectOption> getAccountTeamMembers() {
        List<SelectOption> options = new List<SelectOption>(); 	        
        List<PSG_User_Role__c> accountTeamMembers = PSGUserRoleClass.findByAccount(myConnection.Account__c);
        										   
        for (PSG_User_Role__c accountTeamMember : accountTeamMembers){
        	options.add(new SelectOption(accountTeamMember.PSG_User__r.Email__c,accountTeamMember.PSG_User__r.Name + ' (' + accountTeamMember.Role__c + ')'));
        }	        
        return options;
    }     	
}