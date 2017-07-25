@isTest
private class Utilities_tst 
{

    static testMethod void EmptyList() 
    {
    	 Map<String,Date> testMap= new Map<String, Date>();
	     List<String> orderList= Utilities.organize(testMap);
	     List<String> orderListDesc= Utilities.organizeDesc(testMap);
    }
    
     static testMethod void OneElement() 
    {
    	 Map<String,Date> testMap= new Map<String, Date>();
		  
		  for (Integer i=0; i< 1; i++){
		 	 testMap.put(''+i, date.newinstance(1960+i, 2, 1+i));   
		  }
		  
		 List<String> orderList= Utilities.organize(testMap);
		 List<String> orderListDesc= Utilities.organizeDesc(testMap);
    }

       static testMethod void MoreThanOneElement() 
    {
    	 Map<String,Date> testMap= new Map<String, Date>();
		  
		 for (Integer i=1; i< 6; i++){
		  	 if (i/2==0){
		 	 	testMap.put(''+i, date.newinstance(1950+i, 2, 1+i));
		  	 }else {
		  		testMap.put(''+i, date.newinstance(1980+i, 2, 1+i));
		  	 }   
		  }
		  
		 List<String> orderList= Utilities.organize(testMap);
		 List<String> orderListDesc= Utilities.organizeDesc(testMap);
    }
    
    
}