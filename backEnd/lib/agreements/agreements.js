const express = require('express');
const docusign = require('docusign-esign');
const apiClient = new docusign.ApiClient();

const OAuthToken = 'eyJ0eXAiOiJNVCIsImFsZyI6IlJTMjU2Iiwia2lkIjoiNjgxODVmZjEtNGU1MS00Y2U5LWFmMWMtNjg5ODEyMjAzMzE3In0.AQkAAAABAAUABwAAa64S6zHWSAgAAKvRIC4y1kgCAAMerU6j_-lLlLBvhfFlfxkVAAEAAAAYAAEAAAAFAAAADQAkAAAAZjBmMjdmMGUtODU3ZC00YTcxLWE0ZGEtMzJjZWNhZTNhOTc4EgABAAAACwAAAGludGVyYWN0aXZlMAAAt-kN6zHWSA.GFk6S2Z-EO-xAMJ6VN6iG_9kUlzV_xHgujlH-2qx0JNtTbS996otRZMKutddbxOqVD5DFeBqLylQU3Saly6n70IqTJqFGE2oi-PnltHNpi9Pbiu71HhVzAFiUhk9FXNjkX6Nf8ziXmg9Q_8Xbx8cvciQq9y3bWrxkuQSDN1BoI02UnJcuuwgIDNfTlAVHyNaJcch53jAHGbtsCTDktX8NUGhTw14vD9e5GJDIG7U370PjZoDsnldCifYt2KDa4x8H9eI_LopwR8DB_Akj5esFjOyhHJTw7OwU135LpRPuIVRwuGKzQT2lJM8lBwwftsTVYaGTFt83WKraiJx1lU9dA';
const accountId = '6807321';

//Recipient Information goes here
const templateRoleName = 'signer1'; //IE: Signer 1
const templateId = '0cd6a242-a57c-4b67-8ddc-a99430daa990';

module.exports.createAgreement = (req,res) => {

    const agreement = {
        sender: req.username,
        receiver: req.body.receiver,
        agreement: req.body.agreement
      }
    

    apiClient.setBasePath('https://demo.docusign.net/restapi');
  apiClient.addDefaultHeader('Authorization', 'Bearer ' + OAuthToken);

  // *** Begin envelope creation ***
  

  docusign.Configuration.default.setDefaultApiClient(apiClient);

  let envDef = new docusign.EnvelopeDefinition();

  //Set the Email Subject line and email message
  envDef.emailSubject = 'Please sign this document sent from Node SDK';
  envDef.emailBlurb = 'Please sign this document sent from the DocuSign Node.JS SDK.'

  envDef.templateId = templateId;

  let signer1TemplateRole = new docusign.TemplateRole();
  signer1TemplateRole.roleName = 'signer1';
  signer1TemplateRole.email = agreement.receiver;
  signer1TemplateRole.name = agreement.receiver;
  signer1TemplateRole.clientUserId = '123';

  let tab = new docusign.Text();
  tab.value = agreement.agreement;
  tab.tabLabel = 'Text 796c277e-7cdc-4269-9a2a-6622ecd125fb';
  signer1TemplateRole.tabs = new docusign.Tabs();
  signer1TemplateRole.tabs.textTabs = [tab];
  let templateRoleArray = [];
  templateRoleArray.push(signer1TemplateRole)

  let templateRecipients = new docusign.TemplateRecipients;
  templateRecipients = templateRoleArray;

  envDef.templateRoles = templateRecipients;

  //Envelope status for drafts is created, set to sent if wanting to send the envelope right away
  envDef.status = 'sent';

  // *** End envelope creation ***

  
  //Send the envelope
  let envelopesApi = new docusign.EnvelopesApi();
  envelopesApi.createEnvelope(accountId, { 'envelopeDefinition': envDef }, function (err, envelopeSummary, response) {

    agreement.envelopeId = envelopeSummary.envelopeId;
    agreement.state = 'pending';

    agreements.insert(agreement)
    .then(command => {
      res.send({create: true});
    })
    .catch((err) => {
        console.log("Error: " + err);
        res.send({error: 'pbm with agreement'});//normaly a condition souhld check the err
      })

  })

}

module.exports.generatePdf = (req, res) => {

    const agreement = {
        sender: req.username,
        receiver: req.body.receiver,
        agreement: req.body.agreement,
        envelopeId: req.body.envelopeId
      }

    apiClient.setBasePath('https://demo.docusign.net/restapi');
    apiClient.addDefaultHeader('Authorization', 'Bearer ' + OAuthToken);
  
  
    
    docusign.Configuration.default.setDefaultApiClient(apiClient);
    
  
      //Send the envelope
      let envelopesApi = new docusign.EnvelopesApi();
      
    
        //Set envelopeId the envelopeId that was just created
        let envelopeId = agreement.envelopeId;
    
        //Fill out the recipient View request. authenticationMethod should be email. ClientUserId, RecipientId, returnUrl, userName (Full name of the signer), and email are required.
        //If a clientUserId was not specified, leave it out.
        let recipientViewRequest = new docusign.RecipientViewRequest();
        recipientViewRequest.authenticationMethod = 'email';
        recipientViewRequest.clientUserId = '123';
        recipientViewRequest.recipientId = '1';
        recipientViewRequest.returnUrl = 'http://localhost:4000/dsreturn';
        recipientViewRequest.userName = agreement.receiver;
        recipientViewRequest.email = agreement.receiver;
    
    
        //Create the variable used to handle the response
        recipientViewresults = docusign.ViewLinkRequest();
        console.log(recipientViewRequest)
        //Make the request for a recipient view
        envelopesApi.createRecipientView(accountId, envelopeId, { recipientViewRequest: recipientViewRequest }, function (err, recipientViewResults, response) {
    
          if (err) {
            console.log(response);
            return res.send('Error while creating a DocuSign recipient view:' + err);
          }
    
          
      //Set the signingUrl variable to the link returned from the CreateRecipientView request
      let signingUrl = recipientViewResults.url;
  
        console.log(signingUrl);
        
  
        agreement.signingUrl = signingUrl;

        res.send(agreement)
        
  
      
    })
}

module.exports.getAgreements = (req, res) => {
    agreements.find( { receiver: req.username } )
    .toArray()
    .then(items => res.status(200).json(items))
}

module.exports.getCreatedAgreements = (req, res) => {
    agreements.find( { sender: req.username } )
    .toArray()
    .then(items => res.status(200).json(items))
}

module.exports.putState = (req, res) => {
    agreements.update({ envelopeId: req.body.envelopeId }, { $set: { state: req.body.state }})
    .then(() => {
        if( req.body.state !== 'signed' ){
            agreements.findOne(
                { envelopeId: req.body.envelopeId })
            .then( ( agreement) => {
                console.log(agreement.receiver)
                users.findOne(
                    { mail: agreement.receiver })
                    .then( (user) => {
                        if( req.body.state === 'satisfied'){
                            user.validAgreements +=1
                        } else {
                            user.unvalidAgreements += 1
                        }
                        users.update({ mail: agreement.receiver },{ $set: user})
                    })
                })
            
        }
    })
    .then(res.json(req.body))
    .catch(err => console.log("Error: " + err))
}



