public with sharing class SendEmailWidget {

	//When you know exactly who/what email to send
	public SendEmailWidget (Id relatedToId, Id contactId, List<String> ccAddresses, string fromAddress, Id templateId, string retURL){
		this.relatedToId = relatedToId;
		this.contactId = contactId;
		this.ccAddresses = flattenStringList(ccAddresses);
		this.fromAddress = fromAddress;
		this.templateId = templateId;
		this.retURL = EncodingUtil.urlEncode(retURL, 'UTF-8');
	}	
	
	//OrgWideEmail Determined by User, Template narrowed down to a subset
	public SendEmailWidget (Set<String> emailTemplateFolders, List<Contact> allContacts, id relatedToId, string retURL){
		this.emailTemplateFolders = emailTemplateFolders;		
		this.allContacts = allContacts;
		this.relatedToId = relatedToId;
		this.retURL = EncodingUtil.urlEncode(retURL, 'UTF-8');
	}
	
	// Email Templates & OrgWideEmail determined purely based on user
	public SendEmailWidget (List<Contact> allContacts, id relatedToId, string retURL){	
		this.allContacts = allContacts;
		this.relatedToId = relatedToId;
		this.retURL = EncodingUtil.urlEncode(retURL, 'UTF-8');
	}
		
	public Id relatedToId;
	public Id contactId;
	public string ccAddresses;
	public string fromAddress;
	public Id templateId;
	public string retURL;
	public Set<String> emailTemplateFolders;
	public List<Contact> allContacts;

    public PageReference createEmail(){
		PageReference emailURL = new PageReference ('/email/author/emailauthor.jsp?'
    												+ 'retURL=' + this.retURL // RETURN URL 
    												+ '&p2_lkid=' + this.contactId // ContactID
    												+ '&p3_lkid=' + this.relatedToId // RELATED TO WHATID
    												+ '&p4=' + this.ccAddresses // CC ADDRESS
    												+ '&p26=' + this.fromAddress // FROM ADDRESS
    												+ '&template_id=' + this.templateId
    												); 
    	emailURL.setRedirect(true);
    	return emailURL;   	
	}
	
	public class EmailRecipient{
		public string firstName;
		public string lastName;
		public string role;
		public string email;	
	}
	
	private List<OrgWideEmailAddress> getOrgWideEmails(){
		return [SELECT Id, Address, DisplayName FROM OrgWideEmailAddress];
	}
	
	private List<SelectOption> getTemplates() {
		List<SelectOption> options = new List<SelectOption>();
		options.add(new SelectOption('','-- None -- '));		
						  				   
    	List<EmailTemplate> connectivityEmailTemplates = [SELECT Id 
    										   ,Name
    										   ,Folder.Name
    									   FROM EmailTemplate 
    									  WHERE FolderId IN (SELECT Id 
    									  					   FROM Folder 
    									  					  WHERE Name IN :emailTemplateFolders)
					  				   order by Folder.Name, Name asc];

        
        for (EmailTemplate myTemplate : connectivityEmailTemplates){
        	options.add(new SelectOption(myTemplate.Id,myTemplate.Folder.Name + ': ' + myTemplate.Name));
        }           
        
        return options;
	}
	
	// Turn a list into a semicolon separated string
    private string flattenStringList(List<String> myList){
    	String myStrings = '';
    	if (myList != null){
			for (String myString : myList){
				myStrings = myStrings + myString + '; ';
			}
		}
    	return myStrings;
	}
}