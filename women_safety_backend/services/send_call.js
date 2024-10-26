


var api = require('../node_modules/clicksend/api.js');
require('dotenv').config();




async function sendCall(req, res) {
    var voiceDeliveryReceiptApi = new api.VoiceApi(process.env.SMS_EMAIL, process.env.SMS_PASSWORD);

    var voiceMessage = new api.VoiceMessage();

    voiceMessage.to = `+91${req.body.phone}`;
    voiceMessage.body = "Your friend needs you help. Please check the app for more details.";
    voiceMessage.voice = "female";
    voiceMessage.customString = "Your friend needs you help. Please check the app for more details.";
    voiceMessage.country = "India";
    voiceMessage.source = "php";
    // voiceMessage.listId = 185161;
    voiceMessage.lang = "en-in";
    // voiceMessage.requireInput = 1;
    // voiceMessage.machineDetection = 1;

    var voiceMessages = new api.VoiceMessageCollection();

    voiceMessages.messages = [voiceMessage]

    voiceDeliveryReceiptApi.voiceSendPost(voiceMessages).then(function(response) {
    console.log(response.body);
    }).catch(function(err){
    console.error(err.body);
    });
}

module.exports = {
    sendCall
};