#!groovy
import groovy.json.JsonSlurperClassic
import javax.mail.internet.*;
import javax.mail.*
import javax.activation.*
import javax.mail.Multipart;
import javax.mail.internet.MimeMultipart;
/*
import com.atlassian.jira.issue.Issue;
import com.atlassian.jira.ComponentManager;
import com.atlassian.jira.issue.CustomFieldManager;
import com.atlassian.jira.issue.fields.CustomField;
import com.atlassian.jira.issue.comments.CommentManager;
import com.atlassian.jira.issue.attachment.Attachment;
import com.atlassian.jira.issue.history.ChangeItemBean;
import com.atlassian.jira.util.AttachmentUtils;
import groovy.text.GStringTemplateEngine;
*/
node {

    def BUILD_NUMBER=env.BUILD_NUMBER
    def RUN_ARTIFACT_DIR="tests/${BUILD_NUMBER}"
    def SFDC_USERNAME

    def HUB_ORG=env.HUB_ORG_DH
    def SFDC_HOST = env.SFDC_HOST_DH
    def JWT_KEY_CRED_ID = env.JWT_CRED_ID_DH
    def CONNECTED_APP_CONSUMER_KEY=env.CONNECTED_APP_CONSUMER_KEY_DH
    def JWT_KEY_FILE                   = "ca.key"
    def toolbelt = tool 'toolbelt'
    def emailSubject
    stage('checkout source') {
        // when running in multi-branch job, one must issue this command
        checkout scm
    }

    withCredentials([file(credentialsId: JWT_KEY_CRED_ID, variable: 'jwt_key_file')]) {
        stage('Create Scratch Org') {
            //error CONNECTED_APP_CONSUMER_KEY_DH 
            //jwt_key_file="7b05b896-ca8e-48cb-a679-968f3dbee968"
            echo jwt_key_file
            /*
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
            */
            SFDC_USERNAME="abc@example123.com"
            robj = null

        }
        
        stage('Send scratch org username'){
            emailSubject= "${env.JOB_NAME} - Build # ${env.BUILD_NUMBER} - Successful   ${SFDC_USERNAME}" , 
            emailext subject: "$emailSubject}", mimeType: 'text/html',to: "email id"
            //Get Comment Manager
            //CommentManager commentManager = componentManager.getCommentManager();

            //Get custom field manager
            //CustomFieldManager customFieldManager = ComponentManager.getInstance().getCustomFieldManager();


            //Get custom field email by id
            //CustomField customField_email = customFieldManager.getCustomFieldObject( 10205 );

            /*
            //get value of customField_email
            to = "patil_mangesh77@yahoo.com"


            //Email Headers
            sender="mspatil.27@gmail.com"
            sendername="Test Test"


            //Email acccount credentials
            username="MSPATIL.27@GMAIL.COM"
            password=""

            //Gmail Default port
            port = 25

            //Email Body
            content = SFDC_USERNAME
           

            //Creat first part of email, Email Body


            Multipart mp = new MimeMultipart("mixed");

            MimeBodyPart htmlPart = new MimeBodyPart();
            htmlPart.setContent(content.toString(), "text/html");
            mp.addBodyPart(htmlPart);


                    //Email Properties

                    props = new Properties()
                    props.put("mail.smtp.port", port);
                    props.put("mail.smtp.socketFactory.fallback", "false");
                    props.put("mail.smtp.quitwait", "false");
                    props.put("mail.smtp.host", "smtp.gmail.com");
                    props.put("mail.smtp.auth", "true");   
            
            
                                //New session

                Session session = Session.getDefaultInstance(props);
                MimeMessage message = new MimeMessage(session);
                message.setFrom(new InternetAddress(sender,sendername));
                message.setSubject("${issue.getKey()}");
                message.setRecipient(Message.RecipientType.TO, new InternetAddress(to));
                message.setContent(mp)

                try{
                        Transport transport = session.getTransport("smtp");
                        transport.connect( "smtp.gmail.com",port,username,password );
                        transport.sendMessage(message,message.getAllRecipients());
                        transport.close();
                        log.warn ("mail sent sucesfully to : "+ issue.getCustomFieldValue( customField_email).toString())


                }catch (MessagingException mex) {
                         mex.printStackTrace();
                }
            
            */
        }


       
    }
}
