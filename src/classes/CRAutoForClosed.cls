/****************************************************************************************************
	General Information
	-------------------
	Developer:			Avanxo Colombia
	Autor:				Juan Gabriel Duarte P (JGDP)
	Project:			Novartis Brazil
	Description: 		Send retries for Change Request status closed 
	
	Changes (Versions)
	-------------------------------------
	Number	Date		Autor							Description
	------  ----------	--------------------------		-----------	
	1.0		26-10-2012	Juan Gabriel Duarte P (JGDP)	Create class.
	***********************************************************************************************/
	
global class CRAutoForClosed implements Schedulable{
	
	global void execute(SchedulableContext sc)
	{
		EliminarSch();
	    Integer totalJobs = [Select count() from CronTrigger  where state!='DELETED'];
	    if( totalJobs < 25 )
	    {	    	
	    	DateTime fechaActual= System.now().addMinutes(1);
		    Integer minutos=fechaActual.minute();
		    Integer hora=fechaActual.hour();
		    Integer dia=fechaActual.day();
		    Integer mes=fechaActual.month();
		    Integer anio=fechaActual.year();		    
		    String sch = '0 '+minutos+' '+hora+' '+dia+' '+mes+' ? '+anio;
		    
		    Id batch= database.executebatch(new UpdateCRForClosed_batch());
		    
    		System.debug(' \n Ejecuto el UpdateCRForClosed_batch auto ' + batch);
	    }   
	        
	}
	
	public void EliminarSch()
    {
        List<Crontrigger> a=[Select id,state from CronTrigger where state='DELETED'];
        for(CronTrigger ct : a)
        {
            System.abortjob(ct.Id);
        }
    }
	
}