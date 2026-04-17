# Paper Trading Backend - Firebase Edition

A Node.js backend application for paper trading with Firebase Firestore database.

## 🔥 Firebase Migration

This project has been migrated from MongoDB to Firebase Firestore. See [MIGRATION_SUMMARY.md](./MIGRATION_SUMMARY.md) for details.

## 📋 Prerequisites

- Node.js (v14 or higher)
- npm or yarn
- Firebase account
- Zerodha Kite API credentials

## 🚀 Quick Start

### 1. Install Dependencies

```bash
npm install
```

### 2. Set Up Firebase

Follow the detailed guide in [FIREBASE_SETUP_GUIDE.md](./FIREBASE_SETUP_GUIDE.md)

Quick steps:
1. Create a Firebase project
2. Enable Firestore Database
3. Generate service account credentials
4. Download the JSON key file

### 3. Configure Environment Variables

Copy `.env.example` to `.env` and fill in your credentials:

```bash
cp .env.example .env
```

Update `.env` with your Firebase credentials:

```env
PORT=3000

# Zerodha API
ZERODHA_API_KEY=your_api_key
ZERODHA_API_SECRET=your_api_secret
ACCESS_TOKEN=your_access_token
KITE_API_URL=https://api.kite.trade

# Firebase Configuration
FIREBASE_PROJECT_ID=your-project-id
FIREBASE_PRIVATE_KEY_ID=your-private-key-id
FIREBASE_PRIVATE_KEY="-----BEGIN PRIVATE KEY-----\n...\n-----END PRIVATE KEY-----\n"
FIREBASE_CLIENT_EMAIL=firebase-adminsdk-xxxxx@your-project.iam.gserviceaccount.com
FIREBASE_CLIENT_ID=123456789
FIREBASE_CLIENT_CERT_URL=https://www.googleapis.com/robot/v1/metadata/x509/...

# JWT Token Secret
TOKEN_SECRET=your_secret_key_here

# CORS Configuration
CORS_ORIGIN=http://localhost:3000
```

### 4. Start the Application

```bash
# Development mode
npm run dev

# Production mode
npm start
```

You should see:
```
Firebase connected successfully
Server running on port 3000
```

## 📁 Project Structure

```
paper-trading-backend/
├── bin/                    # Server startup scripts
├── controllers/            # Request handlers
│   ├── adminController.js
│   └── userController.js
├── database/              # Database configuration
│   └── firebaseConnect.js # Firebase initialization
├── kiteConnect/           # Zerodha Kite integration
│   └── socket.js
├── middleware/            # Express middleware
│   ├── authentication.js
│   └── errorHandler.js
├── models/                # Firestore models
│   ├── adminModel.js
│   ├── limitOrderModel.js
│   ├── tokenModel.js
│   ├── tradeModel.js
│   ├── userModel.js
│   ├── walletModel.js
│   └── wishlistModel.js
├── routes/                # API routes
│   ├── adminRoute.js
│   └── usersRoute.js
├── utils/                 # Utility functions
│   ├── cronJobs.js
│   └── helper.js
├── validators/            # Request validation
├── app.js                 # Express app configuration
├── package.json
├── .env.example
├── FIREBASE_SETUP_GUIDE.md
├── MIGRATION_SUMMARY.md
├── UPDATE_REFERENCES.md
└── QUICK_REFERENCE.md
```

## 🗄️ Firestore Collections

The application uses the following Firestore collections:

- **users** - User accounts and profiles
- **admins** - Admin accounts
- **trades** - Trading records
- **limit_orders** - Limit and stop-loss orders
- **wallet_transactions** - Wallet transaction history
- **wishlists** - User watchlists
- **tokens** - Authentication tokens

## 🔌 API Endpoints

### User Routes (`/api`)

#### Authentication
- `POST /register` - Register new user
- `POST /login` - User login
- `GET /profile` - Get user profile (authenticated)

#### Trading
- `POST /trades` - Create new trade
- `GET /trades` - Get user trades
- `PUT /trades/:id` - Update trade
- `DELETE /trades/:id` - Delete trade

#### Limit Orders
- `POST /limit-orders` - Create limit order
- `GET /limit-orders` - Get user limit orders
- `PUT /limit-orders/:id` - Update limit order
- `DELETE /limit-orders/:id` - Cancel limit order

#### Wallet
- `GET /wallet` - Get wallet balance
- `GET /wallet/transactions` - Get transaction history
- `POST /wallet/deposit` - Deposit funds
- `POST /wallet/withdraw` - Withdraw funds

#### Wishlist
- `POST /wishlist` - Add to wishlist
- `GET /wishlist` - Get user wishlist
- `DELETE /wishlist/:id` - Remove from wishlist

### Admin Routes (`/api/admin`)

- `POST /login` - Admin login
- `GET /users` - Get all users
- `PUT /users/:id/block` - Block/unblock user
- `GET /trades` - Get all trades
- `GET /statistics` - Get platform statistics

## 🔐 Authentication

The application uses JWT (JSON Web Tokens) for authentication.

### Headers Required
```
Authorization: Bearer <token>
```

### Token Generation
Tokens are generated on login/registration and include:
- User/Admin ID
- Email
- Role (for users)

## 🛠️ Development

### Model Usage

See [QUICK_REFERENCE.md](./QUICK_REFERENCE.md) for detailed examples.

Quick example:
```javascript
const User = require('./models/userModel');

// Create user
const user = new User({
    email: 'user@example.com',
    name: 'John Doe',
    password: 'hashed_password'
});
await user.save();

// Find user
const user = await User.findOne({ email: 'user@example.com' });

// Update user
user.walletBalance = 1000;
await user.save();
```

### Important Changes from MongoDB

1. **Document IDs**: Use `.id` instead of `._id`
2. **No ObjectId**: IDs are strings
3. **No Populate**: Fetch related documents manually
4. **Query Syntax**: Different from MongoDB (see model files)

See [UPDATE_REFERENCES.md](./UPDATE_REFERENCES.md) for migration details.

## 📊 Monitoring

### Firebase Console
Monitor your database in real-time:
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project
3. Navigate to Firestore Database
4. View collections and documents

### Application Logs
```bash
# View logs in development
npm run dev

# Check Firebase connection
# Should see: "Firebase connected successfully"
```

## 🧪 Testing

```bash
# Run tests (if configured)
npm test

# Test API endpoints
# Use Postman, curl, or any HTTP client
```

## 🔒 Security

### Best Practices Implemented

1. **Environment Variables**: Sensitive data in `.env` file
2. **JWT Authentication**: Secure token-based auth
3. **Password Hashing**: Using bcrypt
4. **CORS Configuration**: Controlled origins
5. **Rate Limiting**: Prevent abuse
6. **Firestore Rules**: Database-level security

### Firestore Security Rules

Update in Firebase Console:
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    // Add more rules as needed
  }
}
```

## 📚 Documentation

- [Firebase Setup Guide](./FIREBASE_SETUP_GUIDE.md) - Complete Firebase setup
- [Migration Summary](./MIGRATION_SUMMARY.md) - MongoDB to Firebase migration details
- [Update References](./UPDATE_REFERENCES.md) - Guide for updating code references
- [Quick Reference](./QUICK_REFERENCE.md) - Model usage examples

## 🐛 Troubleshooting

### Firebase Connection Issues

**Error**: "Firebase connection error"
- Check environment variables
- Verify private key format (should have `\n` characters)
- Ensure service account has proper permissions

**Error**: "PERMISSION_DENIED"
- Update Firestore security rules
- Check authentication token

### Application Issues

**Error**: "Cannot read property '_id'"
- Update to use `.id` instead of `._id`
- See [UPDATE_REFERENCES.md](./UPDATE_REFERENCES.md)

**Error**: "Module not found: firebase-admin"
- Run `npm install`

## 📝 License

[Your License Here]

## 👥 Contributors

[Your Contributors Here]

## 📞 Support

For issues or questions:
- Check documentation files
- Review Firebase Firestore documentation
- Contact development team

## 🚀 Deployment

### Environment Setup
1. Set up production Firebase project
2. Configure environment variables
3. Update CORS origins
4. Set up proper Firestore security rules

### Deploy to Server
```bash
# Build (if needed)
npm run build

# Start production server
npm start
```

### Recommended Hosting
- Google Cloud Run
- Heroku
- AWS EC2
- DigitalOcean
- Any Node.js hosting platform

## 🔄 Updates

### Updating Dependencies
```bash
npm update
```

### Firebase SDK Updates
```bash
npm install firebase-admin@latest
```

## ⚠️ Important Notes

1. **Never commit `.env` file** to version control
2. **Keep service account JSON secure** - do not share publicly
3. **Regularly backup Firestore data**
4. **Monitor Firebase usage** to avoid unexpected costs
5. **Update security rules** before going to production

## 🎯 Next Steps

1. ✅ Complete Firebase setup
2. ✅ Update environment variables
3. ⬜ Update controller files (see UPDATE_REFERENCES.md)
4. ⬜ Test all API endpoints
5. ⬜ Set up Firestore indexes for better performance
6. ⬜ Configure production security rules
7. ⬜ Deploy to production

---

**Happy Trading! 📈**
