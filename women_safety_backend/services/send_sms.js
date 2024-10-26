var api = require('../node_modules/clicksend/api.js');
require('dotenv').config();


function sendSMS(req, res) {
    var smsMessage = new api.SmsMessage();

    smsMessage.from = process.env.SMS_FROM;
    smsMessage.to = `+91${req.body.phone}`;
    smsMessage.body = "Your friend needs help. Details shared to you in the app. Please check the app for more details.";

    var smsApi = new api.SMSApi(process.env.SMS_EMAIL, process.env.SMS_PASSWORD);

    var smsCollection = new api.SmsMessageCollection();

    smsCollection.messages = [smsMessage];

    smsApi.smsSendPost(smsCollection).then(function(response) {
        console.log(response.body);
    }).catch(function(err){
        console.error(err.body);
    });

}


module.exports = {
    sendSMS
};