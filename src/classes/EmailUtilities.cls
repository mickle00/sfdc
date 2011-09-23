public with sharing class EmailUtilities {
  
  public EmailUtilities() {}
    
  public static Set<String> getEmailContactKeys(Case[] cases){
    Set<String> emailContactKeys = new Set<String>();
    String firstName = '';
    String lastName = '';
    List<String> parsedSuppliedName = new List<String>();
    
    for(Case myCase : cases) {
      parsedSuppliedName = EmailUtilities.parseSuppliedName(myCase.suppliedName);
            
      if(parsedSuppliedName.size() == 1) {
            lastName = parsedSuppliedName[0];
          }
      else {
        firstName = parsedSuppliedName[0];
        lastName = parsedSuppliedName[1];
      }
      
      emailContactKeys.add(Utilities.generateIntegrationContactKey(myCase.suppliedEmail,firstName,lastName));
    }
    
    return emailContactkeys;
  }
  
  public static List<String> parseSuppliedName(String suppliedName){
    List<String> parsedName = new List<String>();
    
    system.debug('>>>> EmailUtilities.parseSuppliedName(String suppliedName = ' + suppliedName + ')');
    if (suppliedName != NULL && suppliedName != '') {
      List<String> nameparts = suppliedName.split(' ', 2);
      
      for(String namepart : nameparts) {
        parsedName.add(namepart);
      }
    }
    else {
      parsedName.add('NoName');
    }
    return parsedName;    
  }
  
  public static void sendSingleEmailMessage(String[] toAddresses, String[] ccAddresses, String replyTo, 
    String senderDisplayName, String plainTextBody, String subject, Id orgWideEmailAddressId){
     // First, reserve email capacity for the current Apex transaction to ensure  
    // that we won't exceed our daily email limits when sending email after  
    // the current transaction is committed.  
    //Messaging.reserveSingleEmailCapacity(2);
    // Processes and actions involved in the Apex transaction occur next,  
    // which conclude with sending a single email.  
    // Now create a new single email message object  
    // that will send out a single email to the addresses in the To, CC & BCC list.  
    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    // Strings to hold the email addresses to which you are sending the email.  
    
    system.debug('Email Util toAddresses=' + toAddresses);
    // Assign the addresses for the To and CC lists to the mail object.  
    mail.setToAddresses(toAddresses);
    if (ccAddresses.size() > 0) mail.setCcAddresses(ccAddresses);
    
    Map<String,Id> orgWideEmailAddressToIdMap = getOrgWideEmailAddressToId();
    
    if (orgWideEmailAddressToIdMap.containsKey(replyTo)) {
      mail.setOrgWideEmailAddressId(orgWideEmailAddressToIdMap.get(replyTo));
    }
    else {
      // Specify the address used when the recipients reply to the email.   
      mail.setReplyTo(replyTo);
      // Specify the name used as the display name.  
      mail.setSenderDisplayName(senderDisplayName);
    }
    // Specify the subject line for your email address.  
    mail.setSubject(subject);
    // Set to True if you want to BCC yourself on the email.  
    //mail.setBccSender(false);
    // Optionally append the salesforce.com email signature to the email.  
    // The email address of the user executing the Apex Code will be used.  
    mail.setUseSignature(false);
    // Specify the text content of the email.  
    mail.setPlainTextBody(plainTextBody);
    
    // Send the email you have created.
    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
  
  }
  
  public Boolean emailHasBinaryAttachments(Messaging.InboundEmail.BinaryAttachment[] attachments) {
    return attachments != null && attachments.size() > 0;
  }
  
  public Boolean emailHasTextAttachments(Messaging.InboundEmail.TextAttachment[] attachments) {
    return attachments != null && attachments.size() > 0;
  }
  
  public void saveAttachmentsToParentFromInboundEmail(Messaging.InboundEmail email, Id parentId, Boolean saveBody) {
    // Binary Attachments for the case
    
    AttachmentClass objAttachment = new AttachmentClass();
    Blob emailBody;
    
    String description = saveBody == true ? '' : 'See Parent for real attachment';
    
    if (emailHasBinaryAttachments(email.binaryAttachments)) {
      emailBody = null;
      for (Messaging.InboundEmail.BinaryAttachment binaryAttachment : email.binaryAttachments) {
        emailBody = saveBody == true ? binaryAttachment.body : Blob.valueOf(binaryAttachment.fileName);
        objAttachment.createAttachment(parentId, binaryAttachment.filename, emailBody, description);
      }
    } 
    // Text Attachments for case       
    if (emailHasTextAttachments(email.textAttachments)) {
      emailBody = null;
      for (Messaging.Inboundemail.TextAttachment textAttachment : email.textAttachments) {  
        emailBody = saveBody == true ? Blob.valueOf(textAttachment.body) : Blob.valueOf(textAttachment.fileName);      
        objAttachment.createAttachment(parentId, textAttachment.filename, emailBody, description);
      }
    } //end Attachements code for case     
  }
  
  public static Boolean suppressEmailAutoResponse(String fromAddress) {
    // List of email address that will not get an auto response email
        return fromAddress.toLowerCase().equals('askexpedia@expedia.com') ||
           fromAddress.toLowerCase().equals('askexpedia@expediapartnercentral.com') || // added 4/26/11 by MPS
           fromAddress.toLowerCase().equals('assistance-ee@expedia.com') ||
           fromAddress.toLowerCase().equals('assistanceafrica@expedia.com') ||
           fromAddress.toLowerCase().equals('assistanceamer@expedia.com') ||
           fromAddress.toLowerCase().equals('assistanceanz@expedia.com') ||
           fromAddress.toLowerCase().equals('assistanceapac@expedia.com') ||
           fromAddress.toLowerCase().equals('assistanceaustria@expedia.com') ||
           fromAddress.toLowerCase().equals('assistancebnlx@expedia.com') ||
           fromAddress.toLowerCase().equals('assistancecanada@expedia.com') ||
           fromAddress.toLowerCase().equals('assistancecn@expedia.com') ||
           fromAddress.toLowerCase().equals('assistancecyprus@expedia.com') ||
           fromAddress.toLowerCase().equals('assistanceczech@expedia.com') ||
           fromAddress.toLowerCase().equals('assistancedenmark@expedia.com') ||
           fromAddress.toLowerCase().equals('assistanceeasterneurope@expedia.com') ||
           fromAddress.toLowerCase().equals('assistanceemea@expedia.com') ||
           fromAddress.toLowerCase().equals('assistancefinland@expedia.com') ||
           fromAddress.toLowerCase().equals('assistancefr@expedia.com') ||
           fromAddress.toLowerCase().equals('assistancegreece@expedia.com') ||
           fromAddress.toLowerCase().equals('assistancehk@expedia.com') ||
           fromAddress.toLowerCase().equals('assistanceiceland@expedia.com') ||
           fromAddress.toLowerCase().equals('assistanceid@expedia.com') ||
           fromAddress.toLowerCase().equals('assistanceie@expedia.com') ||
           fromAddress.toLowerCase().equals('assistancein@expedia.com') ||
           fromAddress.toLowerCase().equals('assistanceindianocean@expedia.com') ||
           fromAddress.toLowerCase().equals('assistanceisrael@expedia.com') ||
           fromAddress.toLowerCase().equals('assistancejp@expedia.com') ||
           fromAddress.toLowerCase().equals('assistancekh@expedia.com') ||
           fromAddress.toLowerCase().equals('assistancekr@expedia.com') ||
           fromAddress.toLowerCase().equals('assistancemalta@expedia.com') ||
           fromAddress.toLowerCase().equals('assistancemiddleeast@expedia.com') ||
           fromAddress.toLowerCase().equals('assistancemy@expedia.com') ||
           fromAddress.toLowerCase().equals('assistancenorway@expedia.com') ||
           fromAddress.toLowerCase().equals('assistanceph@expedia.com') ||
           fromAddress.toLowerCase().equals('assistancepoland@expedia.com') ||
           fromAddress.toLowerCase().equals('assistancerussia@expedia.com') ||
           fromAddress.toLowerCase().equals('assistancerussian@expedia.com') ||
           fromAddress.toLowerCase().equals('assistancesg@expedia.com') ||
           fromAddress.toLowerCase().equals('assistancesweden@expedia.com') ||
           fromAddress.toLowerCase().equals('assistanceswiss@expedia.com') ||
           fromAddress.toLowerCase().equals('assistanceth@expedia.com') ||
           fromAddress.toLowerCase().equals('assistanceturkey@expedia.com') ||
           fromAddress.toLowerCase().equals('assistancetw@expedia.com') ||
           fromAddress.toLowerCase().equals('assistanceuk@expedia.com') ||
           fromAddress.toLowerCase().equals('assistancevn@expedia.com') ||
           fromAddress.toLowerCase().equals('channelintegrationemea@ihg.com') ||
           fromAddress.toLowerCase().equals('conload@expedia.com') ||
           fromAddress.toLowerCase().equals('content@expedia.com') ||
           fromAddress.toLowerCase().equals('dchelp@expedia.com') || // added 5/3/11 by MPS
           fromAddress.toLowerCase().equals('dcsupport@expedia.com') ||
           fromAddress.toLowerCase().contains('donotreply') ||
           fromAddress.toLowerCase().contains('do-not-reply') ||
           fromAddress.toLowerCase().contains('do_not_reply') ||
           fromAddress.toLowerCase().equals('dshelp@expedia.com') || // added 5/3/11 by MPS
           fromAddress.toLowerCase().equals('dsmaint@expedia.com') ||
           fromAddress.toLowerCase().equals('ehelp@expedia.com') ||
           fromAddress.toLowerCase().equals('eqchelp@expedia.com') ||
           fromAddress.toLowerCase().equals('esrloc@expedia.com') ||
           fromAddress.toLowerCase().equals('expediahelp@easylink.com') ||
           fromAddress.toLowerCase().contains('expediapartnercentral.com') ||
           fromAddress.toLowerCase().equals('expevt@expedia.com.com') ||
           fromAddress.toLowerCase().equals('geosup@expedia.com') ||
           fromAddress.toLowerCase().equals('hdm@expedia.com') ||
           fromAddress.toLowerCase().equals('hotelphotos@expedia.com') ||
           fromAddress.toLowerCase().equals('hothelp@expedia.com') || // added 5/3/11 by MPS
           fromAddress.toLowerCase().equals('info@bbgliartisti.com') ||
           fromAddress.toLowerCase().equals('infosite@expedia.com') || // added 5/2/11 by MPS
           fromAddress.toLowerCase().equals('lo-hps-m@expedia.com') || // added 5/3/11 by MPS
           fromAddress.toLowerCase().equals('lodgeops@expedia.com') || // added 5/3/11 by MPS
           fromAddress.toLowerCase().equals('lodgops@expedia.com') || // added 5/3/11 by MPS
           fromAddress.toLowerCase().equals('mailer-daemon@jade.host-care.com') || 
           fromAddress.toLowerCase().equals('mm@expedia.com') || // added 5/2/11 by MPS
           fromAddress.toLowerCase().contains('noreply') ||
           fromAddress.toLowerCase().contains('noreply4') ||
           fromAddress.toLowerCase().contains('no-reply') ||
           fromAddress.toLowerCase().contains('no_reply') ||
           fromAddress.toLowerCase().contains('notify@pegs.com') ||
           fromAddress.toLowerCase().equals('nzmarketing@airnz.co.nz') ||
           fromAddress.toLowerCase().equals('opinions@expedia.com') ||
           fromAddress.toLowerCase().equals('partner@expedia.com') ||  // added 4/22/11 by MPS 
           fromAddress.toLowerCase().equals('ratings@expedia.com') || // added 5/3/11 by MPS
           fromAddress.toLowerCase().equals('relomgt@expedia.com') || // added 5/3/11 by MPS
           fromAddress.toLowerCase().equals('reviews@expedia.com') ||
           fromAddress.toLowerCase().equals('roger@made2010.com') ||
           fromAddress.toLowerCase().equals('se@expedia.com') ||
           fromAddress.toLowerCase().equals('sfhelp@expedia.com') || // added 5/6/11 by MPS
           fromAddress.toLowerCase().equals('shscustomercare@sabre.com') ||
           fromAddress.toLowerCase().equals('tocaftops@expedia.com') ||  
           fromAddress.toLowerCase().equals('travopin@expedia.com') ||
           fromAddress.toLowerCase().equals('vchelp@expedia.com');
           
  }
  
    // Do not reply if email address has x number of closed-spam cases
  public static Boolean suppressSpamEmails(String fromAddress) {
    integer closedSpamEmailThreshold = 10;
    List<Case> spamCases = [SELECT Id FROM Case WHERE Status = 'Closed - Spam' AND suppliedEmail = :fromAddress limit :closedSpamEmailThreshold];
    system.debug ('EXCEEDED MAX SPAM EMAILS: '+ string.valueOf(spamCases.size() == closedSpamEmailThreshold));
    return spamCases.size() == closedSpamEmailThreshold;
  }
  
  public static String getExpediaReplyToAlias(String aliasKey) {
    
    if (aliasKey == 'Geography') return 'geosup@expedia.com';
    if (aliasKey == 'Destination_Services') return 'dsmaint@expedia.com';
    if (aliasKey == 'Ticketing') return 'tktwfm@expedia.com';
    if (aliasKey == 'Schedule_Change') return 'ascwfm@expedia.com';
    if (aliasKey == 'Air_Fulfillment_Process_Support') return 'aftwfm@expedia.com';
    if (aliasKey == 'Air_CPR') return 'acprtkt@expedia.com';
    if (aliasKey == 'ADM') return 'admwfm@expedia.com';
    if (aliasKey == 'CarOps') return 'carwfm@expedia.com';
    if (aliasKey == 'HDM') return 'hdm@expedia.com';
    if (aliasKey == 'Star_Ratings') return 'ratings@expedia.com';
    if (aliasKey == 'Hothelp') return 'hothelp@expedia.com';
    if (aliasKey == 'DC Help') return 'dchelp@expedia.com';
    if (aliasKey == 'Non-English') return 'nonenglish@expedia.com';
    if (aliasKey == 'NYC Tech') return 'nyctech@expedia.com';
    if (aliasKey == 'Media_Content') return 'hotelphotos@expedia.com';
    if (aliasKey == 'Virtual_Tours_Content') return 'expevt@expedia.com';
    if (aliasKey == 'Lodging_Content') return 'content@expedia.com';
    if (aliasKey == 'EQC Help') return 'connect.eqc@3b49lbjwy8aaythyiuc5i84z4.m9grhmay.m.apex.sandbox.salesforce.com';
    if (aliasKey == 'VC Help') return 'connect.vc@32r19emanpyaxr95clwh0a2qs.m9grhmay.m.apex.sandbox.salesforce.com';
       
    return 'donotreply.gso@expedia.com';
  }
  
  public static String getExpediaReplyToAliasName(String aliasKey) {
    if (aliasKey == 'Geography') return 'Geography Change Requests';
    if (aliasKey == 'Destination_Services') return 'Destination Services Content Maintenance';
    if (aliasKey == 'Ticketing') return 'GTP Support';
    if (aliasKey == 'Schedule_Change') return 'ASC Support';
    if (aliasKey == 'Air_Fulfillment_Process_Support') return 'Air Fulfillment - Workflow Management';
    if (aliasKey == 'Air_CPR') return 'Air CPR Workflow Management';
    if (aliasKey == 'ADM') return 'Debit Memos Workflow Management';
    if (aliasKey == 'CarOps') return 'Car Operations Workflow Management';
    if (aliasKey == 'HDM') return 'Hotel Data Management';
    if (aliasKey == 'Star_Ratings') return 'Star Ratings';
    if (aliasKey == 'Hothelp') return 'Hotel Tools Support';
    if (aliasKey == 'DC Help') return 'Direct Connect Help';
    if (aliasKey == 'Non-English') return 'Non-English Hotel Hothelp';
    if (aliasKey == 'NYC Tech') return 'NYC Tech Express';
    if (aliasKey == 'Media_Content') return 'Media';
    if (aliasKey == 'Virtual_Tours_Content') return 'Virtual Tours';
    if (aliasKey == 'Lodging_Content') return 'Lodging Content';
    if (aliasKey == 'EQC Help') return 'EQC Help';
    if (aliasKey == 'VC Help') return 'VC Help';
    
    return 'Expedia GSO';
  }
  
  public static Map<String,Id> getOrgWideEmailAddressToId() {
    
    Map<String,Id> orgWideEmailDisplayNameToId = new Map<String,Id>();
    
    OrgWideEmailAddress[] orgEmailAddresses = [Select Id
                                                     ,DisplayName
                                                     ,Address
                                                 From OrgWideEmailAddress];
                                                 
    for (OrgWideEmailAddress orgEmail : orgEmailAddresses) {
      orgWideEmailDisplayNameToId.put(orgEmail.Address,orgEmail.Id);
    }
    
    return orgWideEmailDisplayNameToId;
  }
  
  public static String buildEmailRecipientsText(String[] toAddresses, String[] ccAddresses, String newLine) {
    
    String emailRecipientsHeader = '-------------- EMAIL ADDRESS(s) SENT TO ---------------' + newLine + newLine;
    String emailCCRecipientsHeader = newLine + newLine + '-------------- CC ADDRESS(s) SENT TO ---------------' + newLine + newLine;
    String flatToAddresses = '';
    String flatCCAddresses = '';
    
    String returnText = '';
    
    if(toAddresses != null) {
      for(String emailAddress : toAddresses) {
        if (flatToAddresses.length() == 0) {
          flatToAddresses = emailAddress + ';';
        }
        else {
          flatToAddresses = flatToAddresses + newLine + emailAddress + newLine;
        }
      }  
    }
    if (ccAddresses != null) {
      for (String ccAddress : ccAddresses) {
        if (flatCCAddresses.length() == 0) {
          flatCCAddresses = ccAddress + ';';
        }
        else {
          flatCCAddresses = flatCCAddresses + newline + ccAddress + newLine;
        }
      }
    }
    
    returnText = emailRecipientsHeader + flatToAddresses;
    if (flatCCAddresses.length() != 0) {
      returnText = returnText + emailCCRecipientsHeader + flatCCaddresses;
    }
    
    returnText = returnText + newLine + newLine + '------------------------------------------------------' + newLine + newLine;
    
    return returnText;
  }

  public static String buildEmailRecipientsField(String[] addresses){
    string returnText = ''; 
    // Emails in the "CC" address will appear lowercase   
    if (addresses != NULL) {
        //String[] unformattedAddresses = EmailUtilities.unformattedEmailAddresses(addresses);
      for (String address : addresses){
        //string formattedCCAddress = unFormatEmailAddress(address).toLowerCase();        
        returnText = returnText + address + ';\n'; //space after semicolon to not interfere with linebreaks
      }
    }
    return returnText;
  }
  
  private static String unFormatEmailAddress(String emailAddress){
    string unFormattedEmailAddress;
    if (emailAddress.contains('<') && emailAddress.contains('>')){
     unFormattedEmailAddress = emailAddress.substring(emailAddress.indexOf('<')+1, emailAddress.lastIndexOf('>'));
    }
    else{
     unFormattedEmailAddress = emailAddress;
    }
    return unFormattedEmailAddress;
  }
  
  public static String[] unformattedEmailAddresses(String[] formattedAddresses) {
    if(formattedAddresses == null) return new String[]{};
    
    String[] addresses = new String[]{};
    
    for(String address : formattedAddresses) {
        if (address.contains('<') && address.contains('>')){
          addresses.add(address.substring(address.indexOf('<')+1, address.lastIndexOf('>')));
        }
        else {
            addresses.add(address);
        }
    }
    
    return addresses;
  }
}