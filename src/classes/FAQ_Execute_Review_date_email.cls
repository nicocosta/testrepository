global class FAQ_Execute_Review_date_email implements Schedulable,Database.AllowsCallouts 
{
  public Integer opc{get;set;}
  
  global FAQ_Execute_Review_date_email()
  {
    this.opc=0;
  }
  
  global FAQ_Execute_Review_date_email(Integer opc)
    {
      this.opc=opc;
    } 
  

   global void execute(SchedulableContext sc) 
    {
        if(opc==0)
        {
           database.executebatch(new FAQ_Review_date_email(),200);
        }
  }    
      
}