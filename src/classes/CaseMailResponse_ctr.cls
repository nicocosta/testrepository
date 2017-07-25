/****************************************************************************************************
	General Information
	-------------------
	Developer:			Avanxo Colombia
	Autor:				Juan Pablo Gracia
	Project:			Novartis Brazil
	Description: 		Page's Controller which allow render Case Email Response
	
	Changes (Versions)
	-------------------------------------
	Number	Date		Autor						Description
	------  ----------	--------------------------	-----------
	1.0		18-11-2011	Juan Pablo Gracia			Create class.
	1.1		21-03-2011	Juan Pablo Gracia			Change visualization form.
	****************************************************************************************************/
public class CaseMailResponse_ctr {
	public String urlDoc { get; set; }
	private ApexPages.StandardController controller;
	public String docId { get; set; }
	public String message { get; set; }
	
	//Constructor
	public CaseMailResponse_ctr(ApexPages.StandardController controller){
		this.controller=controller;
	}
	
	//Initial Method
	public PageReference URLAnalist(){
		//Como estaba antes de modificación
		String nameFile = 'tmp_MailResponse';
		
		//Borrar archivos existentes
		/*List<Document> docs = [Select id, url 
                                   From Document d 
                                   Where d.Name LIKE :nameFile
                                   and d.FolderId = : Userinfo.getUserId() ];
        if(docs!=null)delete docs;                           
        
        //Crear el archivo para vizualizar.
		Case_Mail_Response__c cmr= (Case_Mail_Response__c)controller.getRecord();
		Document doc = new Document();             
	    doc.Body = Blob.valueOf('<html><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head><body>' + cmr.Message__c.replace('javascript:','Error:') + '</body></html>');              
	    doc.Name = nameFile;
	    doc.type = 'html'; 
	    doc.FolderId = Userinfo.getUserId();     
	    insert doc;*/
	    
	    //docId = doc.Id;
	    //urlDoc = URL.getSalesforceBaseUrl().toExternalForm() + '/servlet/servlet.FileDownload?file=' +  docId;
		
		//Mensaje
		Case_Mail_Response__c cmr= (Case_Mail_Response__c)controller.getRecord();
	    message = cmr.Message__c.replace('javascript:','Error:').replace('form','<Strong>form</Strong>').replace('input','<Strong>input</Strong>').replace('button','<Strong>button</Strong>').replace('href','*href');
		return null;
		
	}
	
	//When quit page delete document temporal
	public PageReference quit(){
		CaseMailResponse_ctr.deleteDoc(docId);	
		return null;
	}
	
	//When quit page delete document temporal
	@future
	static public void deleteDoc(String docId){
		try{
			Document doc = [Select id From Document Where id=:docId];
			delete doc;
		}catch(Exception e){
		}	
	}
}