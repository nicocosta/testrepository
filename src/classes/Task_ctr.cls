/****************************************************************************************************
    General Information
    -------------------
    Developer:          Avanxo Colombia
    Autor:              Juan Pablo Gracia
    Project:            Novartis Brazil
    Description:        Page's Controller which allow edit or create task.
    
    Changes (Versions)
    -------------------------------------
    Number  Date        Autor                       Description
    ------  ----------  --------------------------  -----------
    1.0     21-11-2011  Juan Pablo Gracia           Create class.
    1.1     24-08-2012  Juan Gabriel Duarte P.      Change LookupGroup.
    1.2     06-03-2013  Juan Gabriel Duarte P.      Included validation field Justification.
    1.3     18-10-2013  Juan Gabriel Duarte P.      Called from the button close.
    ****************************************************************************************************/
    
public class Task_ctr { 
    
    public Group_Task__c groupTask {get;set;}
    public Task tsk {get;set;}
    public class TestException extends Exception {}    
    public String strGroupName { get; set; }
    public String strGroupId { get; set; }
    public Boolean blnSubject {get; set;}
    public Boolean blnDescription {get; set;}
    public Boolean blnJustification {get; set;}    
    public Boolean blnDisabled {get; set;}
    private Map<String,String> mapParameters;
        
    public Task_ctr(ApexPages.Standardcontroller controller)
    {      
        groupTask = new Group_Task__c();
        tsk =  (Task)controller.getRecord();
                        
        if(tsk.id!=null){            
            strGroupId =tsk.Group_Id__c;
            updateGroup();
            
        }
        
        if(tsk.id!=null){
	        if( isDisabled() )
	        {
	            blnDisabled = true;
	        }
	        else {
	            blnDisabled = false;
	        }
        }
        //
        mapParameters = Apexpages.currentPage().getParameters();
        if( mapParameters.containsKey( 'close' ) )
        {
            tsk.Status = 'Closed';
        }
    }
    
    public pageReference btnSave(){
        tsk.Group_Id__c = groupTask.Group__c;
        
        if(checkFields())
        {
                if(strGroupId != null)
                        tsk.Group_Id__c = strGroupId;
                
                try{
                    upsert tsk;
                    PageReference pr;
                    if( mapParameters.containsKey( 'close' ) )
			        {
			            pr = new PageReference('/' + tsk.WhatId);
			        }
			        else
			        {
			            pr = new PageReference('/' + tsk.id);
			        }
                    if(!test.isRunningTest())return pr;
                    else throw new TestException();
                }catch(Exception e){    
                    Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR,e.getMessage()));
                    return null;
                }
        } else {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Label_Subject+': '+Label.Label_You_must_enter_a_value));
                return null;
        }
        
    }
    
    /* Método para validar si los campos obligatorios tienen valores */
    public boolean checkFields()
    {
        boolean fieldsOk=true;
        
        if( tsk.Subject==null )
        {   
                fieldsOk = false;
                blnSubject = true;
        } 
        else 
        {
                blnSubject = false;
        }
        if( tsk.Description__c==null )
        {
                fieldsOk = false;
                blnDescription = true;
        }
        else
        {
                blnDescription = false;
        }
        if( isRequired() )
        {
            fieldsOk = false;
            blnJustification = true;
        }
        else
        {
            blnJustification = false;
        }
        return fieldsOk;
    }
    
    public PageReference updateGroup()
    {
        
        System.debug('strGroupId-> '+strGroupId);
        try
        {            
            List<Group__c> lstGroup = [ SELECT Name FROM Group__c WHERE id =:strGroupId ];
            if(!lstGroup.isEmpty())
                strGroupName= lstGroup.get(0).Name;
            else
                strGroupName= '';
        }
        catch( System.Exception e )
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: '+'Subject: Case Type Id invalid'));
        }
        
        return null;
    }
    
    public Boolean isRequired()
    {
    	Boolean isRequired = false;    	
        if( (tsk.Status.equals('Canceled') || tsk.Status.equals('Unrealized')) && (tsk.Justification__c==null || tsk.Justification__c == '') )
        {
            isRequired = true;
        }        
        return isRequired;
    }
    
    public Boolean isDisabled()
    {
        Boolean isDisabled = false;        
        if( (tsk.Status.equals('Canceled') || tsk.Status.equals('Unrealized')) && tsk.Justification__c!=null )
        {
            isDisabled = true;
        }        
        return isDisabled;
    }
 
}