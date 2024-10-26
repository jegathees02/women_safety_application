

const {login, signup} = require('../auth/auth.js');
const {sendMail} = require('../services/send_mail.js');
const {sendCall} = require('../services/send_call.js');
const {sendWhatsAppMsg} = require('../services/send_whatsapp_msg.js');
const {sendSMS} = require('../services/send_sms.js');




async function loginController(req, res) {
    await login(req, res);
}

async function signupController(req, res) {
    await signup(req, res);
}

function alertController(req, res) {
    sendMail(req, res);
    // sendCall(req, res);
    // sendWhatsAppMsg(req, res);
    // sendSMS(req, res);
    console.log(req.body);
    res.status(200).send('Alert Sent');
}


module.exports = {
    loginController,
    signupController,
    alertController
};