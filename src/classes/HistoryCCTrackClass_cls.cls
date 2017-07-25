public class HistoryCCTrackClass_cls 
{
    public HistoryCCTrackClass_cls()
    {
      
    } 
    
    public void HistoryCCCaseTrg(CaseComment objOldValues, CaseComment objNewValues)
    {
        HistoryTrackObjects.historyInput input1= new HistoryTrackObjects.historyInput();     
        HistoryTrackObjects hstCase1= new HistoryTrackObjects();
        
        input1.idRegister=objOldValues.ParentId;        
        input1.modifyDateTime=DateTime.now();
        input1.currentUser=Userinfo.getUserId();
        
        input1.fieldName='CaseComment.CommentBody';
        input1.oldValue=objOldValues.CommentBody;
        input1.newValue=objNewValues.CommentBody;
        
        if(objOldValues.CommentBody!=objNewValues.CommentBody)
        {
            hstCase1.TrackHistoryCase(input1);        
        }
        
        
    }
}