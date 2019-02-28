#!groovy
import groovy.json.JsonSlurperClassic
node {

    def BUILD_NUMBER=env.BUILD_NUMBER
    def RUN_ARTIFACT_DIR="tests/${BUILD_NUMBER}"
    def SFDC_USERNAME

    def HUB_ORG="mangeshpatildev1@cicd.com"
    def SFDC_HOST = "https://login.salesforce.com"
    def JWT_KEY_CRED_ID = "db23e4b1-18f8-4422-9927-74aa0b4257ac"
    def CONNECTED_APP_CONSUMER_KEY="3MVG9pe2TCoA1Pf4DdrbHp5h._MTkHGH7qy9WY2QZzUw3qTeF9WlYZ4zCOARR5HXlkN2BGE2PRkyyF9XbiudB"
    def JWT_KEY_FILE                   = "ca.key"
    def toolbelt = tool 'toolbelt'
    def emailSubject
    def emailId
    def result
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
            printf rmsg
            def jsonSlurper = new JsonSlurperClassic()
            def robj = jsonSlurper.parseText(rmsg)
            if (robj.status != 0) { error 'org creation failed: ' + robj.message }
            SFDC_USERNAME=robj.result.username
            robj = null

        }
        
        
        stage('Push To Test Org') {
            rc = sh returnStatus: true, script: "\"${toolbelt}/sfdx\" force:source:push --targetusername ${SFDC_USERNAME}"
            if (rc != 0) {
                error 'push failed'
            }
            // assign permset
            rc = sh returnStatus: true, script: "\"${toolbelt}/sfdx\" force:user:permset:assign --targetusername ${SFDC_USERNAME} --permsetname DreamHouse"
            if (rc != 0) {
                error 'permset:assign failed'
            }
        }
        
        stage('Run Apex Test') {
            sh "mkdir -p ${RUN_ARTIFACT_DIR}"
            timeout(time: 120, unit: 'SECONDS') {
                rc = sh returnStatus: true, script: "\"${toolbelt}/sfdx\" force:apex:test:run --testlevel RunLocalTests --outputdir ${RUN_ARTIFACT_DIR} --resultformat tap --targetusername ${SFDC_USERNAME}"
                if (rc != 0) {
                    result="fail"
                    rc = sh returnStatus: true, script: "\"${toolbelt}/sfdx\" force:org:delete --targetusername ${SFDC_USERNAME} "
                    error 'apex test run failed'
                }else{
                    result="success"
                }
            }
        }
        
        stage('collect results') {
            junit keepLongStdio: true, testResults: 'tests/**/*-junit.xml'
        }
        
        stage('Delete scratch org'){
            if(result=="success"){      
                rc = sh returnStatus: true, script: "\"${toolbelt}/sfdx\" force:org:delete --targetusername ${SFDC_USERNAME} "
            }
        }
        
        stage('send email'){
           
             emailext (
               subject: "Job: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
               body: """<p>SUCCESSFUL: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]':</p>
                 <p>Check console output at "<a href="${env.BUILD_URL}">${env.JOB_NAME} [${env.BUILD_NUMBER}]</a>"</p>""",
                  mimeType: 'text/html',to: "${emailId}"
             )

            
        }
        
    }
       
   
}
