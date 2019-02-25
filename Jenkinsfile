#!groovy

node {

    def SFDC_USERNAME
    def emailSubject
    def emailID
    stage('checkout source') {
        // when running in multi-branch job, one must issue this command
        checkout scm
    }

    withCredentials([file(credentialsId: JWT_KEY_CRED_ID, variable: 'jwt_key_file')]) {
        stage('Create Scratch Org') {
            
            SFDC_USERNAME="abc@example123.com"
            emailID="mspatil.27@gmail.com"

        }
        
        stage('Send scratch org username'){
            emailSubject= "${SFDC_USERNAME}"  
            emailext subject: "${emailSubject}", mimeType: 'text/html',to: "${eamilID}"
            
        }


       
    }
}
