// auth/auth.js

const jwt = require('jsonwebtoken');
const bcrypt = require('bcrypt');
const _ = require('lodash');
const { User, validateUser } = require('../models/user'); // Make sure User model is properly defined
require('dotenv').config(); // Load environment variables

async function login(req, res) {
    const { email, password } = req.body;

    // Check if the email and password are provided
    if (!email || !password) return res.status(400).send('Email and password are required.');

    try {
        // Find the user by email
        let user = await User.findOne({ email });
        if (!user) return res.status(400).send('Invalid email or password.');

        // Compare the password with the hashed password in the database
        const validPassword = await bcrypt.compare(password, user.password);
        if (!validPassword) return res.status(400).send('Invalid email or password.');

        // Generate a JWT token if the credentials are valid
        const token = jwt.sign({ _id: user._id, name: user.name, email: user.email }, process.env.JWT_PRIVATE_KEY, {
            expiresIn: '1h', // Token expiration time (optional)
        });

        // Send the token in the Authorization header
        res.header('Authorization', `Bearer ${token}`).send({ message: 'Login successful', token });
    } catch (error) {
        res.status(500).send('Internal Server Error.');
    }
}

async function signup(req, res) {
    const { error } = validateUser(req.body);
    if (error) return res.status(400).send(error.details[0].message);

    // Check if the user already exists
    let user = await User.findOne({ email: req.body.email });
    if (user) return res.status(400).send('User already registered.');

    // Create a new user
    user = new User(_.pick(req.body, ['name', 'email', 'password']));
    const salt = await bcrypt.genSalt(10);
    user.password = await bcrypt.hash(user.password, salt);

    // Save the user to the database
    await user.save();

    // Generate the authentication token
    const token = jwt.sign({ _id: user._id, name: user.name, email: user.email }, process.env.JWT_PRIVATE_KEY);

    // Return the token in the Authorization header as a Bearer token
    res.header('Authorization', `Bearer ${token}`).send(_.pick(user, ['_id', 'name', 'email']));
}

module.exports = {
    login,
    signup,
};
