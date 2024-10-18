// import 'package:mongo_dart/mongo_dart.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'dart:convert';  // To convert string to bytes
// import 'package:crypto/crypto.dart';  // For SHA-256

// class AuthService {
//   // static final String dbPassword = dotenv.env['MONGODB_PASSWORD'] ?? '';
//   // static final String dbUri = dotenv.env['MONGODB_URI'] ?? 'mongodb+srv://ws-user-1:F7SLpgTBsUFlvJ3o@womensafetyapp.cc5sm.mongodb.net/?';
//   static const String dbUri =  'mongodb://ws-user-1:F7SLpgTBsUFlvJ3o@womensafetyapp.cc5sm.mongodb.net/?';

//   static final Db _db = Db(dbUri);  // Use the environment variable for the URI
//   static late final DbCollection _users;

//   // Initialize MongoDB connection and user collection
//   static Future<void> init() async {
//     await _db.open();   
//     _users = _db.collection('User');  // Assuming you have a 'users' collection in MongoDB
//   }

//   // Hash the password using SHA-256
//   static String hashPassword(String password) {
//     var bytes = utf8.encode(password);  // Convert the password to bytes
//     var hashedPassword = sha256.convert(bytes);  // Hash the password
//     return hashedPassword.toString();
//   }

//   // Login function with hashed password
//   static Future<bool> login(String email, String password) async {
//     await init();
//     var hashedPassword = hashPassword(password);  // Hash the input password

//     var user = await _users.findOne({
//       'email': email,
//       'password': hashedPassword  // Compare the hashed password
//     });
//     return user != null;
//   }

//   // Signup function with hashed password
//   static Future<bool> signup(String email, String password) async {
//     await init();
//     var userExists = await _users.findOne({'email': email});

//     if (userExists == null) {
//       var hashedPassword = hashPassword(password);  // Hash the password before saving
//       await _users.insertOne({
//         'email': email,
//         'password': hashedPassword  // Store the hashed password
//       });
//       return true;
//     } else {
//       return false;  // User already exists
//     }
//   }
// }
