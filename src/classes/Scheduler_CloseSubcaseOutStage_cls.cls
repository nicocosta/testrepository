/**                                                     
* ===================================================================================================================================
*  Desarrollado por:    Avanxo Colombia
*  @AUTHOR:             Juan Gabriel Duarte Pacheco
*  Fecha:               Mayo 24 de 2013
*  Decripción:          Clase que permite agendar la clase batch: CloseSubcaseOutStage_batch
*  @version:            1.0
* ===================================================================================================================================
*       Version     Fecha                       Desarrollador                   Observaciones
*       1.0         Mayo 24 de 2013             JGDP                            Creación
**/

global class Scheduler_CloseSubcaseOutStage_cls implements Schedulable{
    
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
            
            if(!Test.isRunningTest()){
                Id batch= database.executebatch(new CloseSubcaseOutStage_batch());
            }
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