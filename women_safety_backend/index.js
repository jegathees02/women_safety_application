const http = require('http');
const express = require('express');
require('dotenv').config(); // Load environment variables

const {loginController, signupController, alertController} = require('./controllers/controller.js');
const connectDB = require('./config/db.js');

const app = express();

// Connect to the database
connectDB();

app.use(express.json());

app.get('/', (req, res) => {
    res.send('Hello World');
});

app.post('/login', loginController);
app.post('/signup', signupController);
app.post('/alert', alertController);

app.listen(3000, () => {
    console.log('Server is running on port 3000');
});