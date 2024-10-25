

const {login, signup} = require('../auth/auth.js');
const {sendMail} = require('../services/send_mail.js');
const {sendCall} = require('../services/send_call.js');
const {sendWhatsAppMsg} = require('../services/send_whatsapp_msg.js');





async function loginController(req, res) {
    await login(req, res);
}

async function signupController(req, res) {
    await signup(req, res);
}

async function alertController(req, res) {
    await sendMail(req, res);
    await sendCall(req, res);
    await sendWhatsAppMsg(req, res);
}


module.exports = {
    loginController,
    signupController,
    alertController
};