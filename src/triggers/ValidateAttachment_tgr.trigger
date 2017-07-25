/****************************************************************************************************
    Information general 
    -------------------
    Developed by:        Avanxo Colombia
    Author:              Juan Gabriel Duarte Pacheco
    Project:             Novartis (CRM)
    Description:
    1. A user can include comments and attachments in the subcase, if any open task assigned to a group to which the user belongs.
    2. If there is an open task assigned to another group in the same subcase, and the task (stage) must check the box "validate comments and attachments" = TRUE, the user can not include comments or attachments to the case.
    3. Users of pharmacovigilance profile can include attachments and comments to the case at any time, even if the sub-case is closed.         
    
    Information about  version changes.
    -------------------------------------
    Number  Date       Author                       Description
    ------  ----------  --------------------------  -----------
    1.0     11-12-2012  Juan Gabriel Duarte P.          Create.
    2.0     12-03-2013  Juan Gabriel Duarte P.          Omitted validation for the profile to TdS.
****************************************************************************************************/
trigger ValidateAttachment_tgr on Attachment (before insert, before update) {
    ValidateAttachment attachment = new ValidateAttachment();
    attachment.executeLogic(Trigger.new, Trigger.old);
}