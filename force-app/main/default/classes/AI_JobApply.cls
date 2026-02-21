public without sharing class AI_JobApply {
    public class RequestDetails {
         @InvocableVariable(required=true label='JobPostingName' )
        public String JobPostingName;
    }
    
    public class Response {
        @InvocableVariable(label='isSuccess')
        public Boolean isSuccess;
        @InvocableVariable(label='message')
        public String message;
    }
    
    @InvocableMethod(label='View Applicant' description='View Applicant')
    public static List<Response> JobApplyAction(List<RequestDetails> inputs) {
        //Fetch the user input
        List<Response> outputs = new List<Response>();
        Response  response= new Response();
        response.isSuccess = false;    
        String JobPostingName, description;
        for ( RequestDetails input : inputs) {
             JobPostingName=input.JobPostingName;
        }
        system.debug(JobPostingName+'######## input #######' +description);
        
        try{
            List<JobApplication__c> jp = [select  Contact_Details__c from JobApplication__c where JobPosting__r.Name =: JobPostingName];
            String result ='';
            for(JobApplication__c j: jp)
                {
                    result = result + j.Contact_Details__c + '\',\'';
                }
           
            
            response.isSuccess = false;
            
            response.message = result ;
            
        }
        catch(Exception e)
        {
            system.debug('###############'+e);
            response.message = 'Job not applied, contact HR for more details' ;
        }
        
        outputs.add(response);
        return outputs;
    }
}