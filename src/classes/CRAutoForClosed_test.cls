@isTest
private class CRAutoForClosed_test {

    static testMethod void myUnitTest() {
    
    //Invoca la clase tipo Schuduler
	CRAutoForClosed ia=new CRAutoForClosed();
    DateTime fechaActual= System.now().addMinutes(1);
    Integer minutos=fechaActual.minute();
    Integer hora=fechaActual.hour();
    Integer dia=fechaActual.day();
    integer mes=fechaActual.month();
    Integer anio=fechaActual.year();
    Integer segundo=fechaActual.second();
    //Seconds Minutes Hours Day_of_month Month Day_of_week optional_year
    String sch = segundo+' '+minutos+' '+hora+' '+dia+' '+mes+' ? '+anio;
    System.debug('\n\n###sch'+sch);
    Id tarea=System.schedule('ChangeRequestShedulerAuto:'+System.now(), sch, ia);
    ia.execute(null);
    ia.EliminarSch();
    
    }
}