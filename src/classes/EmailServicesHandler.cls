global class EmailServicesHandler implements Messaging.InboundEmailHandler {
    
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
        
    system.debug('*** EmailServicesHandler => envelope.toAddress = ' + envelope.toAddress + ' ***');      
    CaseClass objCase = new CaseClass();
    
    // Look at To envelope.toAddress and call appropriate case, passing correct record type
    if (envelope.toAddress.toLowerCase().contains('staging.adm@21iuj73fmwqq0v3z0gds544gt.l8dajmay.l.apex.sandbox.salesforce.com') ||
        envelope.toAddress.toLowerCase().contains('production.adm@a-6i470490emrqee8d8jisxlptj.cpxqgmak.c.apex.salesforce.com')) {       
      system.debug('***EmailServicesHandler => Before processEmail for ADM');
      //ADM case 
      objCase.processEmail(email, 'ADM',null);
    }
    else if (envelope.toAddress.toLowerCase().contains('staging.aircpr@1y34b9nz8hvzaraun3wgzj278.l8dajmay.l.apex.sandbox.salesforce.com') ||
             envelope.toAddress.toLowerCase().contains('production.aircpr@k-1l0klq6ojlnax1zlx2pc6v934.cpxqgmak.c.apex.salesforce.com')) {        
      system.debug('***EmailServicesHandler => Before processEmail for Air CPR');
      //Air CPR case 
      objCase.processEmail(email, 'Air_CPR',null);
    }
    else if (envelope.toAddress.toLowerCase().contains('staging.afps@7c0wbjptdd0psvwzfr1quj78m.l8dajmay.l.apex.sandbox.salesforce.com') ||
             envelope.toAddress.toLowerCase().contains('production.aftps@f-39ndjn2azog3lt1xr50jg7kmq.cpxqgmak.c.apex.salesforce.com')) {        
      system.debug('***EmailServicesHandler => Before processEmail for Air Fulfillment Process & Support');
      //Air Fulfillment Process & Support
      objCase.processEmail(email, 'Air_Fulfillment_Process_Support',null);
    }
    else if (envelope.toAddress.toLowerCase().contains('staging.carops@3dulustn4ht0j00ldvwcyfbn8.l8dajmay.l.apex.sandbox.salesforce.com') ||
             envelope.toAddress.toLowerCase().contains('production.carops@5kluk84albaort7ezk4pbgupo.cpxqgmak.c.apex.salesforce.com')) {        
      system.debug('***EmailServicesHandler => Before processEmail for Car OPS');
      //Car Ops case 
      objCase.processEmail(email, 'CarOps',null);
    }
    else if (envelope.toAddress.toLowerCase().contains('staging.comm@t-33899g2egp7cs2tv0wtwaob1l.l8dajmay.l.apex.sandbox.salesforce.com') ||
             envelope.toAddress.toLowerCase().contains('production.comm@5378nex8cajd3zop3d3bcppak.cpxqgmak.c.apex.salesforce.com')) {        
      system.debug('***EmailServicesHandler => Before processEmail for Commissions');
      //Commissions case 
      objCase.processEmail(email, 'Commissions',null);
    }
    else if (envelope.toAddress.toLowerCase().contains('hoth.ds@c-6859oj86mt4dydkot0vyguvb4.m8nm4maa.m.apex.sandbox.salesforce.com') ||
             envelope.toAddress.toLowerCase().contains('staging.ds@k-3k02tg17q1kgtvm7y7vlloa34.l8dajmay.l.apex.sandbox.salesforce.com') ||
             envelope.toAddress.toLowerCase().contains('production.ds@o-fei89ah5uzxln65dwgfaoscs.cpxqgmak.c.apex.salesforce.com') ||
             envelope.toAddress.toLowerCase().contains('dsmaint@expedia.com')) {
      
      //Destination services case 
      system.debug('***EmailServicesHandler => Before processEmail for DS');
      objCase.processEmail(email, 'Destination_Services',null);
    }
    else if (envelope.toAddress.toLowerCase().contains('staging.ff@7kb6cdhskfdhhh87b838h3y1r.l8dajmay.l.apex.sandbox.salesforce.com') ||
             envelope.toAddress.toLowerCase().contains('production.ff@4jq6lfeg7jro9rdn6fl1aanls.cpxqgmak.c.apex.salesforce.com')) { 
      // Transport Fare Filing case
      system.debug('***EmailServicesHandler => Before processEmail for FF'); 
      objCase.processEmail(email, 'Fare_Filing',null);
    }
    else if (envelope.toAddress.toLowerCase().contains('hoth.geo@4-4uqisn6ksetmougqamyqvhfso.m8nm4maa.m.apex.sandbox.salesforce.com') ||
             envelope.toAddress.toLowerCase().contains('staging.geo@27dh7bhns72irxelriwlm05uy.l8dajmay.l.apex.sandbox.salesforce.com') ||
             envelope.toAddress.toLowerCase().contains('production.geo@5zvrzbr7vhfamla3bi2pqf6qc.cpxqgmak.c.apex.salesforce.com') ||
             envelope.toAddress.toLowerCase().contains('geosup@expedia.com')) {
      
      //Geography case 
      system.debug('***EmailServicesHandler => Before processEmail for GEO');
      objCase.processEmail(email, 'Geography',null);
    }
    else if (envelope.toAddress.toLowerCase().contains('staging.hdm@3qeizs0ka8zz77opsu2o3dc1r.m4cfzmaa.m.apex.sandbox.salesforce.com') ||
             envelope.toAddress.toLowerCase().contains('production.hdm@3gb2pn0wdtm5zpv6bu1pkkgu0.cpxqgmak.c.apex.salesforce.com')){
      system.debug('***EmailServicesHandler => Before processEmail for HDM');
      //HDM
      objCase.processEmail(email, 'HDM',null);
    }
    else if (envelope.toAddress.toLowerCase().contains('staging.health_safety@j-6ni28465bwsl23sfb5hslry7l.m4cfzmaa.m.apex.sandbox.salesforce.com') ||
             envelope.toAddress.toLowerCase().contains('production.health_safety@4gnirzdg1szv016mb8yobjsc.cpxqgmak.c.apex.salesforce.com')) {
      system.debug('***EmailServicesHandler => Before processEmail for Health & Safety');
      //Health & Safety
      objCase.processEmail(email,'Health_Safety',null);   
    }
    else if (envelope.toAddress.toLowerCase().contains('staging.hsts_dchelp@5lday4rc0bppovkotqpm79ho7.m4cfzmaa.m.apex.sandbox.salesforce.com') ||
             envelope.toAddress.toLowerCase().contains('production.hsts_dchelp@3ctqaspbtkhmhkfvu9kweeb.cpxqgmak.c.apex.salesforce.com') ||
             envelope.toAddress.toLowerCase().contains('codeproof.hsts_dchelp@p-whjeqqayfquejy5nxrhm03l3.m9uqhmau.m.apex.sandbox.salesforce.com')){        
      system.debug('***EmailServicesHandler => Before processEmail for HSTS dchelp');
      //HSTS dchelp
      objCase.processEmail(email, 'Hotel_Systems_Technical_Support','DC Help');
    }
    else if (envelope.toAddress.toLowerCase().contains('connect.eqc@3b49lbjwy8aaythyiuc5i84z4.m9grhmay.m.apex.sandbox.salesforce.com')){        
      system.debug('***EmailServicesHandler => Before processEmail for HSTS EQC Help');
      //HSTS EQC
      objCase.processEmail(email, 'Hotel_Systems_Technical_Support','EQC Help');
    }
    else if (envelope.toAddress.toLowerCase().contains('connect.vc@32r19emanpyaxr95clwh0a2qs.m9grhmay.m.apex.sandbox.salesforce.com')){        
      system.debug('***EmailServicesHandler => Before processEmail for HSTS VC Help');
      //HSTS VC
      objCase.processEmail(email, 'Hotel_Systems_Technical_Support','VC Help');
    }
    
    else if (envelope.toAddress.toLowerCase().contains('staging.hsts_hothelp@30o7ryb3t2hbyc44m44raw95g.m4cfzmaa.m.apex.sandbox.salesforce.com') ||
             envelope.toAddress.toLowerCase().contains('production.hsts_hothelp@q-3gidx5snfag809vrhti5qinl3.cpxqgmak.c.apex.salesforce.com') ||
             envelope.toAddress.toLowerCase().contains('codeproof.hsts_hothelp@bdxvupxxlur1zzjc0ljxhgj5.m9uqhmau.m.apex.sandbox.salesforce.com')){        
      system.debug('***EmailServicesHandler => Before processEmail for HSTS Hothelp');
      //HSTS Hothelp
      objCase.processEmail(email, 'Hotel_Systems_Technical_Support','Hothelp');
    }
    else if (envelope.toAddress.toLowerCase().contains('staging.hsts_nonenglish@h-72s35gcre4lyc22vb5wfkew0y.m4cfzmaa.m.apex.sandbox.salesforce.com') ||
            envelope.toAddress.toLowerCase().contains('production.hsts_nonenglish@10qla7thdc6g97tanzogw16z2.cpxqgmak.c.apex.salesforce.com') ||
            envelope.toAddress.toLowerCase().contains('codeproof.hsts_nonenglish@77wkg5qimblv9qasmlqou78kx.m9uqhmau.m.apex.sandbox.salesforce.com')){        
      system.debug('***EmailServicesHandler => Before processEmail for HSTS non english');
      //HSTS non english
      objCase.processEmail(email, 'Hotel_Systems_Technical_Support','Non-English');
    }
    else if (envelope.toAddress.toLowerCase().contains('staging.hsts_nyctech@3l1enklim4xgmhid06jkwpjjb.m4cfzmaa.m.apex.sandbox.salesforce.com') ||
            envelope.toAddress.toLowerCase().contains('production.hsts_nyctech@3-2uvd39qbxrwxddvn25cy9v95l.cpxqgmak.c.apex.salesforce.com') ||
            envelope.toAddress.toLowerCase().contains('codeproof.hsts_nyc_tech@2-6q5bqa9cffenqmpnayqvm4swz.m9uqhmau.m.apex.sandbox.salesforce.com')){        
      system.debug('***EmailServicesHandler => Before processEmail for HSTS NYC Tech');
      //HSTS nyc tech
      objCase.processEmail(email, 'Hotel_Systems_Technical_Support','NYC Tech');
    }
    else if (envelope.toAddress.toLowerCase().contains('staging.lodging_content@29gm0y1maulujgq47zrgs5222.m4cfzmaa.m.apex.sandbox.salesforce.com') ||
             envelope.toAddress.toLowerCase().contains('production.lodging_content@h-1250no0qbwzkjruqmtd5bahag.cpxqgmak.c.apex.salesforce.com')) {
    	system.debug('***EmailServicesHandler => Before processEmail for Lodging Content');
      //Lodging Content
    	objCase.processEmail(email,'Lodging_Content',null);  	
    }
    else if (envelope.toAddress.toLowerCase().contains('staging.lodging_content_apacont@7-74lb12spsmhj2jj7blq2x67bp.m4cfzmaa.m.apex.sandbox.salesforce.com')) {
      system.debug('***EmailServicesHandler => Before processEmail for Lodging Content - apacont');
      //Lodging Content - APACONT
      objCase.processEmail(email,'Lodging_Content','apacont');   
    }
    else if (envelope.toAddress.toLowerCase().contains('staging.lodging_content_emea@w-3svzbbmz61je6a3olkc4s51cd.m4cfzmaa.m.apex.sandbox.salesforce.com')) {
      system.debug('***EmailServicesHandler => Before processEmail for Lodging Content - EMEA');
      //Lodging Content - EMEA
      objCase.processEmail(email,'Lodging_Content','emea');   
    }
    else if (envelope.toAddress.toLowerCase().contains('staging.lodging_content_infosite@v-4zw571afu1qvpekr80kh6blqv.m4cfzmaa.m.apex.sandbox.salesforce.com')) {
      system.debug('***EmailServicesHandler => Before processEmail for Lodging Content - Infosite');
      //Lodging Content - INFOSITE
      objCase.processEmail(email,'Lodging_Content','infosite');   
    }
    else if (envelope.toAddress.toLowerCase().contains('staging.media_content@4-543qsbulkgxuab25cz8ga44o5.m4cfzmaa.m.apex.sandbox.salesforce.com') ||
             envelope.toAddress.toLowerCase().contains('production.content_media@r-6py89m491mynb4j1rqq9990j8.cpxqgmak.c.apex.salesforce.com')) {
      system.debug('***EmailServicesHandler => Before processEmail for Media Content');
      //Media Content
      objCase.processEmail(email,'Media_Content',null);   
    }
    else if (envelope.toAddress.toLowerCase().contains('staging.sched@h-5yu243xkx4ilvfnk986sde3mt.l8dajmay.l.apex.sandbox.salesforce.com') ||
             envelope.toAddress.toLowerCase().contains('production.sched@6-77frurhrk37duk7nui8iyasvu.cpxqgmak.c.apex.salesforce.com')) {      
      system.debug('***EmailServicesHandler => Before processEmail for Schedule Change');
      //Schedule Change case 
      objCase.processEmail(email, 'Schedule_Change',null);
    }
    else if (envelope.toAddress.toLowerCase().contains('staging.settle@j-kc9lk9tjo84reycjvqxfzhhy.l8dajmay.l.apex.sandbox.salesforce.com') ||
             envelope.toAddress.toLowerCase().contains('production.settle@4bbte27ao7xc1h9zsapbtucdf.cpxqgmak.c.apex.salesforce.com')) {       
      system.debug('***EmailServicesHandler => Before processEmail for Settlement');
      //Settlement case 
      objCase.processEmail(email, 'Settlement_Reporting',null);
    }
    else if (envelope.toAddress.toLowerCase().contains('staging.star@z-3jfynxn6omgzqmjtxer1wxgy1.l8dajmay.l.apex.sandbox.salesforce.com') ||
             envelope.toAddress.toLowerCase().contains('production.star_rating@9-5xbm837l8mya4zsykom8s4n7a.cpxqgmak.c.apex.salesforce.com')){        
      system.debug('***EmailServicesHandler => Before processEmail for Star Ratings');
      //Star Ratings
      objCase.processEmail(email, 'Star_Ratings',null);
    }
    else if (envelope.toAddress.toLowerCase().contains('staging.gsosfsup@74l2vc3j965xqw3npmgdonw1j.m4cfzmaa.m.apex.sandbox.salesforce.com') ||
             envelope.toAddress.toLowerCase().contains('production.gsosfsup@76e3skfzszc0q9z7jtzrxs793.cpxqgmak.c.apex.salesforce.com')) {
      system.debug('***EmailServicesHandler => Before processEmail for HSTS non english');
      //Support Request
      objCase.processEmail(email, 'Support_Request', null);
    }
    else if (envelope.toAddress.toLowerCase().contains('staging.ticket@h-5yu243xkx4ilvfnk986sde3mt.l8dajmay.l.apex.sandbox.salesforce.com') ||
             envelope.toAddress.toLowerCase().contains('production.ticket@0-16p21ob3vpjgw63c4xukvxh0i.cpxqgmak.c.apex.salesforce.com')) {      
      system.debug('***EmailServicesHandler => Before processEmail for Ticketing');
      //Ticketing case 
      objCase.processEmail(email, 'Ticketing',null);
    }
    else if (envelope.toAddress.toLowerCase().contains('production.trouble@5f1qin463du2unpotqva62a7.cpxqgmak.c.apex.salesforce.com') ||
      envelope.toAddress.toLowerCase().contains('production.rtamer@4202xc6jrw8o0136ty03f0vnp.cpxqgmak.c.apex.salesforce.com') ||
      envelope.toAddress.toLowerCase().contains('production.rtapac@0-k5vzz715002ojd3zbsm7su40.cpxqgmak.c.apex.salesforce.com') ||
      envelope.toAddress.toLowerCase().contains('production.rtemea@k-6py1d0qyms8yg5f2775n6mgmv.cpxqgmak.c.apex.salesforce.com') ||
      envelope.toAddress.toLowerCase().contains('production.3pp@1-1ipxnn8gcxctzpen001h4dtis.cpxqgmak.c.apex.salesforce.com')) {        
      system.debug('***EmailServicesHandler => Before processEmail for Transport Troubleshooting Case');
      //Troubleshooting Case
      objCase.processEmail(email, 'Troubleshooting',null);
    }
    else if (envelope.toAddress.toLowerCase().contains('staging.virtual_tours_content@9-62zj97lqxxoq82eyuxlnpnlb3.m4cfzmaa.m.apex.sandbox.salesforce.com') ||
             envelope.toAddress.toLowerCase().contains('production.content_virtual_tours@mey824r0tv0j8jnp90d8on4r.cpxqgmak.c.apex.salesforce.com')) {
      system.debug('***EmailServicesHandler => Before processEmail for Virtual Tours Content');
      //Virtual Tours Content
      objCase.processEmail(email,'Virtual_Tours_Content',null);   
    }
    else { 
    	// email not handled so create a
      //Support Request
      objCase.processEmail(email, 'Support_Request', null);
    }
    system.debug('***EmailServicesHandler => Before Return***');    
    return result;  
  }
}