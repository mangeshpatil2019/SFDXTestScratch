#!groovy
import groovy.json.JsonSlurperClassic
node {

    def BUILD_NUMBER=env.BUILD_NUMBER
    def RUN_ARTIFACT_DIR="tests/${BUILD_NUMBER}"
    def SFDC_USERNAME
    def password;
    def instanceURL;
    def HUB_ORG="mangeshpatildev2@cicd.com"
    def SFDC_HOST = "https://login.salesforce.com"
    def JWT_KEY_CRED_ID = "db23e4b1-18f8-4422-9927-74aa0b4257ac"
    def CONNECTED_APP_CONSUMER_KEY="3MVG9pe2TCoA1Pf6CsZ6N7hb1eD_jy_DLXuMKoARnLXV16JuRVTZWZpBK9Y3ajdDmuYMx_hPD9DK.yrJ6RF2F"
    def JWT_KEY_FILE                   = "ca.key"
    def toolbelt = tool 'toolbelt'
    def emailSubject
    def emailId
    def emailBody
    stage('checkout source') {
        // when running in multi-branch job, one must issue this command
        checkout scm
    }

    withCredentials([file(credentialsId: JWT_KEY_CRED_ID, variable: 'jwt_key_file')]) {
        stage('Create Scratch Org') {
            //error CONNECTED_APP_CONSUMER_KEY_DH 
            //jwt_key_file="7b05b896-ca8e-48cb-a679-968f3dbee968"
            echo jwt_key_file 

           // rc = sh returnStatus: true, script: "\"${toolbelt}/sfdx\" force:auth:jwt:grant --clientid ${CONNECTED_APP_CONSUMER_KEY} --username ${HUB_ORG} --jwtkeyfile ${jwt_key_file} --setdefaultdevhubusername --instanceurl ${SFDC_HOST}"
              rc = sh returnStatus: true, script: "\"${toolbelt}/sfdx\" force:auth:jwt:grant --clientid ${CONNECTED_APP_CONSUMER_KEY} --username ${HUB_ORG} --jwtkeyfile ${JWT_KEY_FILE} --setdefaultdevhubusername --instanceurl ${SFDC_HOST} --json --loglevel debug"
            //printf rc
            if (rc != 0) { error 'hub org authorization failed' }

            // need to pull out assigned username
            rmsg = sh returnStdout: true, script: "\"${toolbelt}/sfdx\" force:org:create --definitionfile config/project-scratch-def.json --json --setdefaultusername"
            
            
            
            def jsonSlurper = new JsonSlurperClassic()
            def robj = jsonSlurper.parseText(rmsg)
            if (robj.status != 0) { error 'org creation failed: ' + robj.message }
            SFDC_USERNAME=robj.result.username
            
            //rmsg2= sh returnStdout: true, script: "\"${toolbelt}/sfdx\" force:user:password:generate --targetusername ${SFDC_USERNAME}"
            //rmsg3= sh returnStdout: true, script: "\"${toolbelt}/sfdx\" force:user:display --targetusername ${SFDC_USERNAME} --json"
            
            //def jsonSlurper1 = new JsonSlurperClassic()
            //def robj1 = jsonSlurper1.parseText(rmsg3)
            //if (robj1.status != 0) { error 'org creation failed: ' + robj1.message }
            //password=robj1.result.username
            //instanceURL=robj1.result.instanceURL
            robj = null
            //robj1=null

        }
        stage('create password'){
            
            rmsg= sh returnStdout: true, script: "\"${toolbelt}/sfdx\" force:user:password:generate --targetusername ${SFDC_USERNAME}"
            def jsonSlurper = new JsonSlurperClassic()
            def robj = jsonSlurper.parseText(rmsg)
            if (robj.status != 0) { error 'org creation failed: ' + robj.message }            
            robj = null
        }
        
        stage('get detail'){
            
            rmsg= sh returnStdout: true, script: "\"${toolbelt}/sfdx\" force:user:display -u ${SFDC_USERNAME} --json"
            def jsonSlurper = new JsonSlurperClassic()
            def robj = jsonSlurper.parseText(rmsg)
            if (robj.status != 0) { error 'org creation failed: ' + robj.message }            
            password=robj.result.username
            instanceURL=robj.result.instanceURL
            robj = null
        }
        
        stage('send email'){
            emailId="mangesh_patil32@syntelinc.com"
            emailBody="${SFDC_USERNAME} - ${password} - ${instanceURL}"
            emailSubject= "${SFDC_USERNAME}"  
            emailext (subject: "${emailSubject}", mimeType: 'text/html',body:"${emailBody}",to: "${emailId}")
        }
       
        
    }
       
   
}
