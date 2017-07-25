public class InvokeChangeRequestWS {
    
    @future (callout=true)
    public static void invokeChangeRequestWS(Id crId) {
        
        System.debug('::::invokeChangeRequestWS');
        
        List<Change_Request__c> lstCR = new List<Change_Request__c>([select Subcase_number__c, Task_Id__c, CR_error_message__c from Change_Request__c where id = :crId]);
        if (lstCR == null || lstCR.size() == 0) {
            System.debug('::::Change Request no encontrado');
            return;
        }
        
        Change_Request__c cr = lstCR[0];
        System.debug('Change_Request__c\n' + cr );
        List<Case> lstCase = new List<Case>([select AccountId, Number_of_complained_packages__c, Patient_Name__c, Request_Numbers__c, Product__c, Reimbursement_via__c, Case_Subcase_Number__c from Case where Id = :cr.Subcase_number__c]);
        /**
        Esta validación no es necesaria, debido a que una regla de válidación garantiza que un Change Request obligatoriamente debe
        tener un subcase.
        if (lstCase == null || lstCase.size() == 0) {
            System.debug('::::Subcase no encontrado');
            return;
        }*/
        
        Case subcase = lstCase[0];
        System.debug('Case\n' + subcase );
        List<Account> lstAccount = [select Person_identification_number_CPF__pc, LastName, Name, Main_Address__c, Phone_1__c, Phone_2__c, AccountNumber from Account where Id = :subcase.AccountId];
        //Account acc = null;
        Account acc = lstAccount[0];
        /**
        Esta validación no es necesaria, debido a que una regla de válidación garantiza que un Change Request obligatoriamente debe
        tener un subcase.
        if (lstAccount == null || lstAccount.size() == 0) {
            System.debug('Account no encontrado.');
            acc = null;
        } else {
            System.debug('Account encontrado: ');
            acc = lstAccount[0];
        }*/
        System.debug('Account\n' + acc );
        List<Product2> lstProduct = [select Name from Product2 where Id = :subcase.Product__c];
        Product2 product = null;
        if (lstProduct == null || lstProduct.size() == 0) {
            System.debug('::::Product no encontrado.');
        } else {
            System.debug('::::Product encontrado.');
            product = lstProduct[0];
        }
        System.debug('Product2\n' + product );
        List<Address__c> lstAddress = [select Address_Name__c, State__c, City__c, Complement__c, District__c, Number__c, Post_code_number__c, Post_Code__c, Post_Code__r.Post_Code_CEP__c from Address__c where Id = :acc.Main_Address__c]; 
        Address__c addr = null;
        if (lstAddress == null || lstAddress.size() == 0) {
            System.debug('::::Address no encontrado.');
        } else {
            System.debug('::::Address enontrado.');
            addr = lstAddress[0];
        }
        System.debug('Address__c\n' + addr );
        List<Phone__c> lstPhone = new List<Phone__c>([select Phone_Number__c, Local_Code__c from Phone__c where Id = :acc.Phone_1__c]); 
        Phone__c phone1 = lstPhone.size() == 0 ? null :  lstPhone[0];
        System.debug('Phone__c 1\n' + phone1 );
        lstPhone = [select Phone_Number__c, Local_Code__c from Phone__c where Id = :acc.Phone_2__c];
        Phone__c phone2 = lstPhone.size() == 0 ? null :  lstPhone[0];
        System.debug('Phone__c 2\n' + phone2 );
        CRWEBService24102010.wsEssSoap stub = new CRWEBService24102010.wsEssSoap();
        stub.ValidationSoapHeader = new CRWEBService24102010.ValidationSoapHeader();
        stub.ValidationSoapHeader.Password = 'novartis2010';
        stub.ValidationSoapHeader.UserID = 'USR010';
        
        CRWEBService24102010.wsSolicitacao solicitacao = new CRWEBService24102010.wsSolicitacao();
        
        //solicitacao.SolNroCliente = crId;
        solicitacao.SolNroCliente = subcase.Case_Subcase_Number__c;
        //solicitacao.CaseNumber= subcase;
        solicitacao.Observacao = '?';
        solicitacao.End_numero = 0; 
        if(acc.LastName != null && acc.LastName != '')
            solicitacao.Nome = acc.LastName;
        else
            solicitacao.Nome = acc.Name;
        solicitacao.Endereco = addr == null ? '' : addr.Address_Name__c;
        if( addr != null && addr.Number__c != null )
           solicitacao.Endereco = solicitacao.Endereco + ',' + addr.Number__c;
        solicitacao.End_numero = 0; 
        //solicitacao.End_numero = 0;
        //addr == null || 
        //addr.Number__c == null? 0 : Integer.valueOf(addr.Number__c); 
        solicitacao.Complemento = addr == null ? '' : addr.Complement__c;
        solicitacao.Bairro = addr == null ? '' : addr.District__c;
        solicitacao.Cidade = addr == null ? '' : addr.City__c;
        if( addr != null && addr.Post_code_number__c != null )
            solicitacao.CEP = addr.Post_code_number__c;
        else if( addr != null && addr.Post_Code__c != null )
            solicitacao.CEP = addr.Post_Code__r.Post_Code_CEP__c;
        else
            solicitacao.CEP = '';
        solicitacao.UF = addr == null ? '' : addr.State__c;
        solicitacao.ddd1 = phone1 == null || phone1.Local_Code__c == null ? '' : ''+phone1.Local_Code__c;
        solicitacao.Fone1 = phone1 == null ? '' : phone1.Phone_Number__c;
        solicitacao.ddd2 = phone2 == null || phone2.Local_Code__c == null ? '' : ''+phone2.Local_Code__c;
        solicitacao.Fone2 = phone2 == null ? '' : phone2.Phone_Number__c;
        if( acc.Person_identification_number_CPF__pc != null )
            solicitacao.cpf_cnpj = acc.Person_identification_number_CPF__pc;
        else
            solicitacao.cpf_cnpj = acc.AccountNumber;
            
        System.debug('subcase.Reimbursement_via__c -->' + subcase.Reimbursement_via__c);        
        if( subcase != null && (subcase.Reimbursement_via__c.equalsIgnoreCase( 'Troca do produto' ) || subcase.Reimbursement_via__c.equalsIgnoreCase( 'Product' )) )
        {
            solicitacao.ProdutoColeta = product == null ? '' : product.Name;
            solicitacao.ProdutoColetaQtde = Integer.valueOf( '' + subcase.Number_of_complained_packages__c );
            solicitacao.ProdutoEntrega = product == null ? '' : product.Name;
            solicitacao.ProdutoEntregaQtde = Integer.valueOf( '' + subcase.Number_of_complained_packages__c );
        }
        else if( subcase != null && (subcase.Reimbursement_via__c.equalsIgnoreCase( 'Ressarcimento em dinheiro' ) || subcase.Reimbursement_via__c.equalsIgnoreCase( 'Money' )) )
        {
            solicitacao.ProdutoColeta = product == null ? '' : product.Name;
            solicitacao.ProdutoColetaQtde = Integer.valueOf( '' + subcase.Number_of_complained_packages__c );
            solicitacao.ProdutoEntrega = '';
            solicitacao.ProdutoEntregaQtde = 0;
        }
        else if( subcase != null && (subcase.Reimbursement_via__c.equalsIgnoreCase( 'Retirada da amostra do cliente' ) || subcase.Reimbursement_via__c.equalsIgnoreCase( 'N/A (Analysis only)' )) )
        {
            solicitacao.ProdutoColeta = product == null ? '' : product.Name;
            solicitacao.ProdutoColetaQtde = Integer.valueOf( '' + subcase.Number_of_complained_packages__c );
            solicitacao.ProdutoEntrega = '';
            solicitacao.ProdutoEntregaQtde = 0;
        }        
         else if( subcase != null && (subcase.Reimbursement_via__c.equalsIgnoreCase( 'Delivery' ) || subcase.Reimbursement_via__c.equalsIgnoreCase( 'Entrega' )) )
        {
            solicitacao.ProdutoColeta = '';
            solicitacao.ProdutoColetaQtde = 0;
            solicitacao.ProdutoEntrega = product == null ? '' : product.Name;
            solicitacao.ProdutoEntregaQtde = Integer.valueOf( '' + subcase.Number_of_complained_packages__c );
        }
        
        printSolicitacao(solicitacao);
                
        Integer crNumber;
        System.debug('Contactando WS\n' + solicitacao );
        try {
            /*if( !isTest )*/
                crNumber = stub.InserirNovaSolicitacao2(solicitacao);
            /*else
                crNumber = 123456;*/
            cr.CR_number__c = crNumber;
            cr.CR_error_message__c = 'Ok';
        } catch (System.TypeException e) {
            System.debug(':::: ERROR(1)\n' + e.getMessage());
            // cr.CR_error_message__c = e.getMessage();
            cr.CR_error_message__c = 'Ok';
        } catch(System.CalloutException e) {
            System.debug(':::: ERROR(2)\n' + e.getMessage());
            cr.CR_error_message__c = e.getMessage();
        }
        
        System.debug('::::cr.Task_Id__c' + cr.Task_Id__c);
        System.debug('::::cr.CR_error_message__c' + cr.CR_error_message__c);
        if( cr.Task_Id__c != null && cr.Task_Id__c != '' && cr.CR_error_message__c.equalsIgnoreCase( 'Ok' ) )
        {
            try
            {
                Task t = [  Select Status From Task Where Id = :cr.Task_Id__c ];
                System.debug(':::: Task.Id:'+t.Id);
                System.debug(':::: Task.Status:'+t.Status);
                t.Status = 'Closed';
                update t;
            }
            catch( System.Exception e )
            {
                System.debug( 'Problema al encontrar o cerrar la tarea' );
                cr.CR_error_message__c += ' -- Problema al encontrar o cerrar la tarea \'' + cr.Task_Id__c + '\' --> ' +  e.getMessage();
            }
        }
        
        //cr.CR_creation_date__c = System.now();
        
        update cr;
        
        System.debug('::::crNumber:'+crNumber);
        
        System.debug('::::END');
    }
    
    private static void printSolicitacao(CRWEBService24102010.wsSolicitacao solicitacao) {
        String s = '\n' +
        solicitacao.SolNroCliente + '\n' +
        solicitacao.Observacao + '\n' +
        solicitacao.Nome + '\n' +
        solicitacao.Endereco + '\n' +
        solicitacao.End_numero + '\n' + 
        solicitacao.Complemento + '\n' +
        solicitacao.Bairro  + '\n' +
        solicitacao.Cidade + '\n' +
        solicitacao.CEP + '\n' +
        solicitacao.UF + '\n' +
        solicitacao.ddd1 + '\n' +
        solicitacao.Fone1 + '\n' +
        solicitacao.ddd2 + '\n' +
        solicitacao.Fone2 + '\n' +
        solicitacao.cpf_cnpj + '\n' +
        solicitacao.ProdutoColeta + '\n' +  
        solicitacao.ProdutoColetaQtde  + '\n' +
        solicitacao.ProdutoEntrega  + '\n' +
        solicitacao.ProdutoEntregaQtde  + '\n';
        
        System.debug(s);
    }
}