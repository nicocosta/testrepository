public class HistoryTrackObjects 
{
    public HistoryTrackObjects()
    {
    	
    }
    
    public void TrackHistoryAccount(historyInput input)
    {
    	Account_History__c inputValue= new Account_History__c();
    	inputValue.Account__c=input.idRegister;
    	inputValue.Field__c=input.fieldName;
    	inputValue.Modify_Date_Time__c=input.modifyDateTime;
    	inputValue.New_Value__c=input.newValue;
    	inputValue.Old_Value__c=input.oldValue;
    	inputValue.Tracking_User__c=input.currentUser;
    	insert inputValue;
    }
    public void TrackHistoryFAQ(historyInput input)
    {
        FAQ_History__c inputValue= new FAQ_History__c();
        inputValue.Faq__c=input.idRegister;
        inputValue.Field__c=input.fieldName;
        inputValue.Modify_Date_Time__c=input.modifyDateTime;
        inputValue.New_Value__c=input.newValue;
        inputValue.Old_Value__c=input.oldValue;
        inputValue.Tracking_User__c=input.currentUser;
        
        insert inputValue;
    }
    public void TrackHistoryCase(historyInput input)
    {
        Case_History__c inputValue= new Case_History__c();
        inputValue.Case__c=input.idRegister;
        inputValue.Field__c=input.fieldName;
        inputValue.Modify_Date_Time__c=input.modifyDateTime;
        inputValue.New_Value__c=input.newValue;
        inputValue.Old_Value__c=input.oldValue;
        inputValue.Tracking_User__c=input.currentUser;
        
        insert inputValue;
    }
    public void TrackHistorySIR(historyInput input)
    {
        SIR_History__c inputValue= new SIR_History__c();
        inputValue.Safety_Individual_Report__c=input.idRegister;
        inputValue.Field__c=input.fieldName;
        inputValue.Modify_Date_Time__c=input.modifyDateTime;
        inputValue.New_Value__c=input.newValue;
        inputValue.Old_Value__c=input.oldValue;
        inputValue.Tracking_User__c=input.currentUser;
        
        insert inputValue;
    }
    
    public class historyInput
    {
    	public ID idRegister{get;set;}
    	public String fieldName{get;set;}
    	public String oldValue{get;set;}
    	public String newValue{get;set;}
    	public DateTime modifyDateTime{get;set;}
    	public ID currentUser{get;set;}
    }
    
}