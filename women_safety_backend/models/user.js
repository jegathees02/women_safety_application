// models/user.js

const mongoose = require('mongoose');
const Joi = require('joi'); // For input validation
const jwt = require('jsonwebtoken');
require('dotenv').config(); // Load environment variables


// Define the User schema
const userSchema = new mongoose.Schema({
    name: {
        type: String,
        required: true,
        minlength: 3,
        maxlength: 50
    },
    email: {
        type: String,
        required: true,
        minlength: 5,
        maxlength: 255,
        unique: true
    },
    password: {
        type: String,
        required: true,
        minlength: 5,
        maxlength: 1024
    }
});

// Method to generate a JWT token for the user
userSchema.methods.generateAuthToken = function () {
    return jwt.sign({ _id: this._id, name: this.name, email: this.email }, process.env.JWT_PRIVATE_KEY, {
        expiresIn: '1h' // Token expiration time
    });
};

// Create the User model from the schema
const User = mongoose.model('User', userSchema);

// Function to validate user input when creating or updating a user
function validateUser(user) {
    const schema = Joi.object({
        name: Joi.string().min(3).max(50).required(),
        email: Joi.string().min(5).max(255).email().required(),
        password: Joi.string().min(5).max(255).required()
    });

    return schema.validate(user);
}

module.exports = {
    User,
    validateUser
};
