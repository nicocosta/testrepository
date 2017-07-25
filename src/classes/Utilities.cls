public with sharing class Utilities {
    
     private static List<String> bubleSort (List<Datetime> valueList, List<String> keyList )
    {
      boolean  swapped = true;
      Integer j = 0;
      Datetime tmp;
      String tmp2;
      while (swapped) { 
            swapped = false;
            j++;
            for (Integer i = 0; i < valueList.size() - j; i++) {                                       
                  if (valueList[i] > valueList[i + 1]) {                          
                        tmp = valueList[i];
                        valueList[i] = valueList[i + 1];
                        valueList[i + 1] = tmp;
                        
                        //--Changing KeyList also to keep lists synchronized
                        tmp2 = keyList[i];
                        keyList[i] = keyList[i + 1];
                        keyList[i + 1] = tmp2;
                        
                        swapped = true;
                  }
            }                
      }
      return keyList;
    }
    
     private static List<String> bubleSortDesc (List<Datetime> valueList, List<String> keyList )
    {
      boolean  swapped = true;
      Integer j = 0;
      Datetime tmp;
      String tmp2;
      while (swapped) { 
            swapped = false;
            j++;
            for (Integer i = 0; i < valueList.size() - j; i++) {                                       
                  if (valueList[i] < valueList[i + 1]) {                          
                        tmp = valueList[i];
                        valueList[i] = valueList[i + 1];
                        valueList[i + 1] = tmp;
                        
                        //--Changing KeyList also to keep lists synchronized
                        tmp2 = keyList[i];
                        keyList[i] = keyList[i + 1];
                        keyList[i + 1] = tmp2;
                        
                        swapped = true;
                  }
            }                
      }
      return keyList;
    }
    
    public static List<String> organize ( Map<String, Datetime> toOrganise) {
        
        Set <String> keySet = new Set<String>();
        keySet  = toOrganise.keySet();
        List<Datetime> valueList = new List<Datetime>();
        
        List<String> keyList = new List<String>();
        for (String s: keySet){
            keyList.add(s);
            valueList.add ( (Datetime)toOrganise.get(s));
        }

        //calling buble sort    
        if (valueList.size() == 1){
           return keyList;
        }
        else if (valueList.size() > 1){
        List<String> result= bubleSort(valueList,keyList);
        return result;
        }
        
        return new List<String>();
    }   
    
    public static List<String> organizeDesc ( Map<String, Datetime> toOrganise) {
        
        Set <String> keySet = new Set<String>();
        keySet  = toOrganise.keySet();
        List<Datetime> valueList = new List<Datetime>();
        
        List<String> keyList = new List<String>();
        for (String s: keySet){
            keyList.add(s);
            valueList.add ( (Datetime)toOrganise.get(s));
        }

        //calling buble sort    
        if (valueList.size() == 1){
           return keyList;
        }
        else if (valueList.size() > 1){
        List<String> result= bubleSortDesc(valueList,keyList);
        return result;
        }
        
        return new List<String>();
    }   
    
   
  
}