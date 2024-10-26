

const nodemailer = require("nodemailer");
require('dotenv').config();

const transporter = nodemailer.createTransport({
  service: "gmail",
  host: "smtp.gmail.email",
  port: 587,
  ssl : true, // true for port 465, false for other ports
  auth: {
    user: process.env.EMAIL,
    pass: process.env.PASSWORD,
  },
});

// async..await is not allowed in global scope, must use a wrapper
// async function main() {
  // send mail with defined transport object
  
  // Message sent: <d786aa62-4e0a-070a-47ed-0b0666549519@ethereal.email>
// }

// main().catch(console.error);

async function sendMail(req, res) {
    console.log('Sending Email');
    const info = await transporter.sendMail({
        from: '"Help!!!!!!" <jegatheeswaranmk2002@gmail.com>', // sender address
        to: req.body.email, // list of receivers
        subject: "User on High Risk", // Subject line
        text: "Your Friend is on a risk. Need you help", // plain text body
        html: "<b>Your Friend is on a risk. Need you help</b>", // html body
      });
    
      console.log("Message sent: %s", info);
}

// sendMail.catch(console.error);


module.exports = {
    sendMail
};