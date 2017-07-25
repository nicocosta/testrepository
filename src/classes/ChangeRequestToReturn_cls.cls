global class ChangeRequestToReturn_cls implements Schedulable{
    
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
            
            Id batch= database.executebatch(new ChangeRequestToReturn_batch());
            
            System.debug(' \n Ejecuto el ChangeRequestToReturn_batch auto ' + batch);
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