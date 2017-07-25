trigger HistoryCaseCommentTrg on CaseComment (before update, before delete) {

    if( Trigger.isDelete )
    {
        system.debug ('Entra a Is Delete');
        for( CaseComment cc : Trigger.old){
            cc.addError( System.label.Cannot_Delete_record);
            }
    } else if(Trigger.isUpdate && trigger.new.size()==1)
    {
        HistoryCCTrackClass_cls trackHistory= new HistoryCCTrackClass_cls();
        
        trackHistory.HistoryCCCaseTrg(Trigger.old[0], Trigger.new[0]);
    }
    
}