global class FAQ_Review_date_email implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful
{
    Global String strQuery = '';
    String activo= 'Active';
    String difaultcontact= label.FAQ_Difault_Contac;
    
    global FAQ_Review_date_email()
    {    
        strQuery = 'select Id, Name,Addressee__c, Description__c, FAQ_Type__c, key_words__c, Number_nPCC__c, Responsible_Area__c, Review_date__c,Reviewer_Approver__c,Review_Schedule__c,Status__c,Summary__c, LastModifiedDate from FAQ__c where Status__c =: activo';
        if(Test.isRunningTest()) 
            strQuery += ' limit 10';
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        return Database.getQueryLocator(strQuery);
    }
    
    global void execute(Database.BatchableContext bc, List<FAQ__c> Faqlist )
    {
        List<FAQ__c> FaqlistAfter = new List<FAQ__c>();
        List<FAQ__c> FaqlistBefore = new List<FAQ__c>();
        system.debug('FaqList: '+Faqlist.size());
        List<String> Emaillist = new List<String>();
        List<User> UserRecipients = [select id,Email,ProfileId from User where (ProfileId= '00eA0000000Iw22' or ProfileId= '00eZ0000000M18Q' or ProfileId='00eA0000000Iw1x') and IsActive=true ];
        system.debug('Usuarios con emeils: '+UserRecipients);
        
        for (User u:UserRecipients)
        {
        Emaillist.add(u.Email);            
        }
            
        system.debug('Lista de Correos: '+Emaillist);
        
        if (Faqlist != null && Faqlist.size()>0 && Emaillist != null &&  Emaillist.size()>0 )
        {
            Date Todays = date.today();
            for( FAQ__c faq: Faqlist)
            {
                //Logic for FAQ that has Review Scheduled date
                if(faq.Review_Schedule__c != null)
                { 
                    if(  Todays <= faq.Review_Schedule__c)
                    {
                       FaqlistBefore.add(faq);      
                    }
                    else
                    {
                       FaqlistAfter.add(faq);                                            
                    }
 
                }else
                { //Logic for FAQ that are allready in the system, me need too use LastModiefiedDate+2years
                    Date reviewdate = faq.LastModifiedDate.date();
                    if( Todays  <= reviewdate)
                    {
                        FaqlistBefore.add(faq);
                    }
                    else
                    {
                        FaqlistAfter.add(faq);
                    } 
                }
            }
            system.debug('FaqlistAfter '+FaqlistAfter.size());
            system.debug('FaqlistBefore'+FaqlistBefore.size());
            If(FaqlistAfter != null &&  FaqlistAfter.size()>0)
            {
                this.Process1(FaqlistAfter,Emaillist);
            }
            
            If(FaqlistBefore != null &&  FaqlistBefore.size()>0)
            {
                this.Process2(FaqlistBefore,Emaillist);
            }            
        }
    }
    
    
    global void finish(Database.BatchableContext bc)
    {
        
    }
    
    public void Process1(List<FAQ__c> FLA, List<String> ListEmail)
    {
        EmailTemplate et = [Select id, Subject, HtmlValue, Body, Markup from EmailTemplate where DeveloperName =: 'FAQ_Email_Review'];
        
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        
        for( FAQ__c faq: FLA)
        {   
            Integer result = null;
            Date hoy = date.today();
            
            if(faq.Review_Schedule__c != null)
            {
                result = hoy.daysBetween(faq.Review_Schedule__c);
            }else
            {
                Date reviewdate = faq.LastModifiedDate.date();
                result = hoy.daysBetween(reviewdate);  
            }
            
            Integer remainder = math.mod(result, 2);          
            system.debug('Es par si remainder es = o si no no remainder ='+remainder);
  
            if ( remainder == 0 )
            {       
                //Mensaje por Faq
                Messaging.SingleEmailMessage objEmail = new Messaging.SingleEmailMessage();
                objEmail.setTemplateid(et.id);
                If (faq.Reviewer_Approver__c != null)
                {
                	objEmail.setTargetObjectId(faq.Reviewer_Approver__c);
                }else{objEmail.setTargetObjectId(difaultcontact);}
                objEmail.setToAddresses(ListEmail);
                objEmail.setWhatId(faq.id);
                objEmail.setSaveAsActivity(false);
                mails.add(objEmail);
            }    
        }
        
        system.debug('CantidadEmailsAfter'+mails.size());
        
        if(mails.size()>0)
        {
            Messaging.sendEmail(mails,false);
        }
        mails.clear();
    }
    
    public void Process2(List<FAQ__c> FLB, List<String> ListEmail)
    {
        List<FAQ__c> Faqlist30DayBefore = new List<FAQ__c>();
        List<FAQ__c> Faqlist90DayBefore = new List<FAQ__c>();
        List<FAQ__c> Faqlist60DayBefore = new List<FAQ__c>();
        
        for( FAQ__c faq: FLB)
        { 
            
            if ( this.SendNotification90(faq) )
            {
                Faqlist90DayBefore.add(faq);  
            }else
            {
                if ( this.SendNotification60(faq) )
                {
                    Faqlist60DayBefore.add(faq);
                }
                else
                {
                    if ( this.SendNotification30(faq) )
                    {
                        Faqlist30DayBefore.add(faq);
                    }   
                }
            }  
        }
        
        if (Faqlist30DayBefore!=null && Faqlist30DayBefore.size()>0)   
            this.Sentmail(Faqlist30DayBefore,1,ListEmail);
        if (Faqlist60DayBefore!=null && Faqlist60DayBefore.size()>0)   
            this.Sentmail(Faqlist60DayBefore,2,ListEmail);
        if (Faqlist90DayBefore!=null && Faqlist90DayBefore.size()>0)   
            this.Sentmail(Faqlist90DayBefore,3,ListEmail);
    }
    
    public Boolean SendNotification90(FAQ__c faq)
    {
        Date hoy = date.today();
        Date Reviewbefore = null;
        if(faq.Review_Schedule__c!=null)
        {
            Reviewbefore = faq.Review_Schedule__c.addDays(-90);
        }else
        {
            Reviewbefore = faq.LastModifiedDate.date();    
        }
        
        system.debug('Reviewbefore 90: '+Reviewbefore+' hoy:  '+hoy);
        
        if (Reviewbefore == hoy)
        {
            return true; 
        }
        else
            return false;                
    }
    
    public Boolean SendNotification60(FAQ__c faq)
    {
        Date hoy = date.today();
        Date Reviewbefore = null;
        if(faq.Review_Schedule__c!=null)
        {
            Reviewbefore = faq.Review_Schedule__c.addDays(-60);
        }else
        {
            Reviewbefore = faq.LastModifiedDate.date();    
        }
        
        system.debug('Reviewbefore 60: '+Reviewbefore+' hoy:  '+hoy);
        if (Reviewbefore == hoy)
        {
            return true; 
        }
        else
            return false;                
    }
    
    public Boolean SendNotification30(FAQ__c faq)
    {
        Date hoy = date.today();
        Date Reviewbefore = null;
        if(faq.Review_Schedule__c!=null)
        {
            Reviewbefore = faq.Review_Schedule__c.addDays(-30);
        }else
        {
            Reviewbefore = faq.LastModifiedDate.date();    
        }
        
        system.debug('Reviewbefore 30: '+Reviewbefore+' hoy:  '+hoy);
        if (Reviewbefore == hoy)
        {
            return true; 
        }
        else
            return false;                
    }
    
    public void Sentmail(List<FAQ__c> FLA,Integer month, List<String> ListEmail)
    {
        EmailTemplate et = [Select id, Subject, HtmlValue, Body, Markup from EmailTemplate where DeveloperName =: 'FAQ_Email_Review_90'];

        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        if (FLA.size()>0 && FLA != null)
        {
            for( FAQ__c faq: FLA)
            {   
                String target1= 'xfaqname';
                String target2 = 'xfaqdescription';
                String target3 = 'xmonth';
                String target4 = 'meses';
                String replacement1 = faq.Name;
                String replacement2 = 'sim descripcion';
                if(faq.Description__c != null)
                {
                    replacement2 = faq.Description__c;
                }
                String replacement3 = String.valueOf(month);
                String replacement4 = 'mês';
                String Markup1 = et.Markup.replace(target1, replacement1);
                String Markup2 = Markup1.replace(target2, replacement2);
                String Markup3 = Markup2.replace(target3, replacement3);
                String Markup4 = Markup3.replace(target4, replacement4);
                //Mensaje por Faq
                Messaging.SingleEmailMessage objEmail = new Messaging.SingleEmailMessage();
                 
                
                
                If (faq.Reviewer_Approver__c != null)
                {
                	objEmail.setTargetObjectId(faq.Reviewer_Approver__c);
                }else{objEmail.setTargetObjectId(difaultcontact);}
                
                if(month != 1)
                {
                objEmail.setSubject('O FAQ '+faq.Name+' precisa ser revisado em '+month+' meses:');
                objEmail.setHtmlBody(Markup3);
                }else{objEmail.setSubject('O FAQ '+faq.Name+' precisa ser revisado em '+month+' mês:');
                      objEmail.setHtmlBody(Markup4);}
                objEmail.setToAddresses(ListEmail);
                objEmail.setWhatId(faq.id);
                objEmail.setSaveAsActivity(false);
                mails.add(objEmail);      
            }
            
            system.debug('CantidadEmailsBefore'+month+' : '+mails.size());
            
            if(mails.size()>0)
            {
                Messaging.sendEmail(mails,false);
            }
            
            mails.clear();
        }
    }
    
    
    
}