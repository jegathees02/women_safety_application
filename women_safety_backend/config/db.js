// config/db.js

const mongoose = require('mongoose');
require('dotenv').config(); // Load environment variables

async function connectDB() {
    const dbURI = process.env.MONGO_URI; // Get the URI from the .env file
    
    try {
        await mongoose.connect(dbURI, {
            useNewUrlParser: true,
            useUnifiedTopology: true,
        });
        console.log('Connected to MongoDB Atlas...');
    } catch (err) {
        console.error('Could not connect to MongoDB', err);
        process.exit(1);
    }
}

module.exports = connectDB;
