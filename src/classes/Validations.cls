/****************************************************************************************************
    General Information. 
    -------------------
    Developed by:   	Avanxo Colombia
    Author:              Giovanny Rey Cediel.
    Project:           	Novartis (CRM)
    Description:        This class do funtion validaCPF.
    
    Information about version
    -------------------------------------
    Number  Date       Author                       Description
    ------  ----------  --------------------------  -----------
    1.0     12-05-2011  Giovanny Rey Cediel          Creation.
    1.0     12-05-2011  Juan Pablo Gracia         	 Add valida_cnpj.
**************************************************************************************************/

public class Validations {
	/*******************************************
		Attributes of class
	*******************************************/
	public static boolean flatTest=false;//Only test purposes
	
	/*****************************************
		Test method validate CPF code 
		@String cpfString
		@return boolean  
	*****************************************/
	public static boolean valida_CPF(String cpfString){		
		Integer var, soma, resultado;
		String numeros,cpf,digitos;
		Integer i,digitos_iguais;
		digitos_iguais = 1;
		cpf=stringToNumber(cpfString);
		if(cpf.equals('0'))  return false;			
		 
		 if (length(cpf) < 11 )
	            return false;
	      for (i = 0; i < cpf.length() - 1; i++){
	            Integer index =1;			
	            if ( charAt(i,cpf) != charAt(i + 1, cpf) || flatTest){
	                  digitos_iguais = 0;
	                  break;
				}
	      }
	      if (digitos_iguais!=1 || flatTest )
	            {
	            numeros = substring(0,9,cpf);
	            digitos = substring(9,cpf);
	            soma = 0;
	            for (i = 10; i > 1; i--){	            	
	                  soma += Integer.valueOf(charAt(10 - i,numeros)) * i;
	            }
	            resultado = math.mod(soma, 11) < 2 ? 0 : 11 - math.mod(soma, 11);
	            
	            if (resultado != Integer.valueOf(charAt(0,digitos)) && !flatTest )
	                  return false;
	            numeros = substring(0,10,cpf);
	            soma = 0;
	            for (i = 11; i > 1; i--){
	                  soma += Integer.valueOf( charAt(11 - i,numeros)) * i;
	            }
	            resultado = math.mod(soma, 11) < 2 ? 0 : 11 - math.mod(soma, 11);
	            if (resultado != Integer.valueOf(charAt(1,digitos))  && !flatTest ){
	                  return false;
	            }
	            return true;
	            }
	      else{
	            return false;
	      }
      }
	
	/******************************************
		Make as javascript substring funtion
		@Integer indexOne
		@Integer indexTwo
		@return String 
	******************************************/		 	 
	 private static String subString(Integer indexOne, Integer indexTwo, String num){	 		
	 		return num.substring(indexOne,indexTwo);
	 }
	/******************************************Long
		Make as javascript substring funtion
		@Integer index
		@return String 		
	******************************************/		 	 
	 private static String subString(Integer index,String num){
	 		return num.substring(index);
	 }
	/******************************************
		Make as javascript charAt funtion
		@Integer index
		@String  num
		@return String
	******************************************/		 	 		 	 
	private static String charAt(Integer index, String num ){	 			
		return  num.substring(index,index+1);		
	 }	 
	/******************************************
		Make as javascript substring lenght
		@String num
		@Innteger 
	******************************************/		 	 	 
	private static Integer length(String num){
		return num .length();	
	}
	
	/******************************************
		Converts String To Long 
		@String data
		@Integer 
	******************************************/		 	 	 	
	private static String stringToNumber(String data ){
		String num='';	
		for(Integer x=0 ; x<  data.length(); x++){
			String dig = data.substring(x,x+1);				
			if(dig.equalsIgnoreCase('0') || dig.equalsIgnoreCase('1')||dig.equalsIgnoreCase('2')||dig.equalsIgnoreCase('3')
			||dig.equalsIgnoreCase('4')||dig.equalsIgnoreCase('5')||dig.equalsIgnoreCase('6')||dig.equalsIgnoreCase('7')
			||dig.equalsIgnoreCase('8')||dig.equalsIgnoreCase('9') ){
				num+=dig;			
			}						
		}
		if(num.equals('')) num='0';
		return num;
	}
	
	/******************************************
		Get array
		@String arrayIn
		return List<Integer>		 
	******************************************/		 	 	 		
	static public List<Integer> getArray(String arrayIn){
		List<Integer> lst = new List<Integer>();
		for(Integer i=0;i<arrayIn.length();i++){
			try{			
			lst.add(Integer.valueOf(arrayIn.substring(i, i+1)));
			}catch(Exception e){
			}
		}
		return lst;
	}
	
	/******************************************
		valida cnpj
		@String arrayIn
		@return boolean 
	******************************************/		 	 	 			
	static public boolean valida_cnpj(String arrayIn){
	 	List<Integer> cnpj = getArray(arrayIn);
	 	if(cnpj.size()<14){
	 		return false;
	 	}
	 	Boolean digitos_iguais = true;
	 	Integer tamanho,soma,pos,i,resultado;
	 	List<Integer> numeros = new List<Integer>();
	 	List<Integer> digitos = new List<Integer>();
	 	for(i=0;i<cnpj.size()-1;i++){
	 		if(cnpj.get(i)!=cnpj.get(i+1)){
	 			digitos_iguais =false;
	 			break;
	 		}
	 	}
	 	if(!digitos_iguais){
	 		tamanho = cnpj.size()-2;
	 		for(i=0;i<cnpj.size();i++){
	 			if(i<tamanho){
	 				numeros.add(cnpj.get(i));
	 			}else{
	 				digitos.add(cnpj.get(i));
	 			}
	 		}
	 		soma = 0;
	 		pos = tamanho - 7;
	 		for (i = tamanho; i >= 1; i--){
	 			soma += numeros.get(tamanho - i) * pos--;
	 			if(pos<2)pos = 9;
	 		}
	 		if(math.mod(soma, 11)<2){
	 			resultado = 0;
	 		}else{
	 			resultado = 11 - math.mod(soma,11);
	 		}
	 		if (resultado != digitos.get(0))
                  return false;
            tamanho = tamanho + 1; 
            numeros = new List<Integer>();     
	 		for(i=0;i<tamanho;i++){
				numeros.add(cnpj.get(i));
	 		}
	 		soma = 0;
	 		pos = tamanho - 7;
	 		for (i = tamanho; i >= 1; i--){
	 			soma += numeros.get(tamanho - i) * pos--;
	 			if(pos<2) pos = 9;
	 		}
	 		if(math.mod(soma, 11)<2){
	 		 	resultado = 0;
	 		}else{
	 		 	resultado = 11 - math.mod(soma,11);	
	 		}
	 		if (resultado != digitos.get(1))
                  return false;
            return true;
	 	}else{
	 		return false;
	 	}
	 }
	
}