/**                                                     
* ===================================================================================================================================
*  Desarrollado por:    Avanxo Colombia
*  @AUTHOR:             Juan Gabriel Duarte Pacheco
*  Fecha:               Julio 08 de 2013
*  Decripción:          Clase para proporcionar los servicios de lógica para atender los desencadenadores
*  @version:            1.0
* ===================================================================================================================================
*       Version     Fecha                       Desarrollador                   Observaciones
*       1.0         Julio 08 de 2013            JGDP                            Creación
**/

global class Validator_cls{

    private static boolean blnAlreadyDone = false;
    
    public static boolean hasAlreadyDone(){
        return blnAlreadyDone;
    }
    
    public static void setAlreadyDone() {
        blnAlreadyDone = true;
    }
}