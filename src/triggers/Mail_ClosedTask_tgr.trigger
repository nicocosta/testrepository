/**                                                     
* ===================================================================================================================================
*  Desarrollado por:    Avanxo Colombia
*  @AUTHOR:             Juan Gabriel Duarte Pacheco
*  Fecha:               Mayo 23 de 2013
*  Decripción:          Desencadenador individual sobre el objeto Tarea, para cerrar las actividades propias de los emails.
*  @version:            1.0
* ===================================================================================================================================
*       Version     Fecha                       Desarrollador                   Observaciones
*       1.0         Mayo 23 de 2013            JGDP                            Creación
**/
trigger Mail_ClosedTask_tgr on Task (after insert, after update) {
    Mail_ClosedTask_cls closeTask = new Mail_ClosedTask_cls();
    closeTask.executeLogic(Trigger.new, Trigger.old);
}