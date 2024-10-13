

const {login, signup} = require('../auth/auth.js');

async function loginController(req, res) {
    await login(req, res);
}

async function signupController(req, res) {
    await signup(req, res);
}


module.exports = {
    loginController,
    signupController,
};