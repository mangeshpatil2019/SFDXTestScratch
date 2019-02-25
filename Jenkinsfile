#!groovy

node {

    def SFDC_USERNAME
    def emailSubject
    def emailId
    stage('checkout source') {
        // when running in multi-branch job, one must issue this command
        checkout scm
    }

   
        stage('Create Scratch Org') {
            
            SFDC_USERNAME="abc@example123.com"
            emailId="patil_mangesh77@yahoo.com"

        }
        
        stage('send email'){
            
             emailSubject= "${SFDC_USERNAME}"  
            emailext (subject: "${emailSubject}", mimeType: 'text/html',to: "${emailId}")
        }

   
       
   
}
