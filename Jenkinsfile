#!groovy
import groovy.json.JsonSlurperClassic
node {

    def BUILD_NUMBER=env.BUILD_NUMBER
    def RUN_ARTIFACT_DIR="tests/${BUILD_NUMBER}"
    def SFDC_USERNAME

    def HUB_ORG="mangeshpatildev2@cicd.com"
    def SFDC_HOST = env.SFDC_HOST_DH
    def JWT_KEY_CRED_ID = env.JWT_CRED_ID_DH
    def CONNECTED_APP_CONSUMER_KEY="3MVG9pe2TCoA1Pf6CsZ6N7hb1eP64sQz6nZAIOTm.WTJB4jnWEoHGayQlj4I_MzZLpZWMDN7Q7L44u.xp1iG6"
    def JWT_KEY_FILE                   = "ca.key"
    def toolbelt = tool 'toolbelt'
    def package_name="mypackage"

    stage('checkout source') {
        // when running in multi-branch job, one must issue this command
        checkout scm
    }

    withCredentials([file(credentialsId: JWT_KEY_CRED_ID, variable: 'jwt_key_file')]) {
        stage('Create Scratch Org') {
            //error CONNECTED_APP_CONSUMER_KEY_DH 
            

           // rc = sh returnStatus: true, script: "\"${toolbelt}/sfdx\" force:auth:jwt:grant --clientid ${CONNECTED_APP_CONSUMER_KEY} --username ${HUB_ORG} --jwtkeyfile ${jwt_key_file} --setdefaultdevhubusername --instanceurl ${SFDC_HOST}"
              rc = sh returnStatus: true, script: "\"${toolbelt}/sfdx\" force:auth:jwt:grant --clientid ${CONNECTED_APP_CONSUMER_KEY} --username ${HUB_ORG} --jwtkeyfile ${JWT_KEY_FILE} --setdefaultdevhubusername --instanceurl ${SFDC_HOST} --json --loglevel debug"
            //printf rc
            if (rc != 0) { error 'hub org authorization failed' }
			           
           
            robj = null

        }

        stage('Convert to metadata') {
			sh "mkdir -p ${RUN_ARTIFACT_DIR}"
            rc = sh returnStatus: true, script: "\"${toolbelt}/sfdx\"  force:source:convert -d ${RUN_ARTIFACT_DIR}/ --packagename ${package_name}"
            if (rc != 0) {
                error 'package failed'
            }
            
        }

        stage('Deploy to Server') {
            rc = sh returnStatus: true, script: "\"${toolbelt}/sfdx\"  force:mdapi:deploy -d ${RUN_ARTIFACT_DIR}/ -u ${HUB_ORG} -l NoTestRun"
            if (rc != 0) {
                error 'package failed'
            }
        }

        stage('collect results') {
		//sfdx force:mdapi:deploy:report
	    rc = sh returnStatus: true, script: "\"${toolbelt}/sfdx\"  force:mdapi:deploy:report --wait -1 --loglevel info"
            if (rc != 0) {
                error 'package failed'
            }
            
        }
    }
}
