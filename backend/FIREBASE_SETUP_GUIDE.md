# Firebase Setup Guide

This guide will help you set up Firebase Firestore for your Paper Trading Backend application.

## Prerequisites
- A Google account
- Node.js installed on your system

## Step 1: Create a Firebase Project

1. Go to the [Firebase Console](https://console.firebase.google.com/)
2. Click on **"Add project"** or **"Create a project"**
3. Enter your project name (e.g., "Paper Trading Backend")
4. Click **Continue**
5. (Optional) Enable Google Analytics if you want analytics features
6. Click **Create project**
7. Wait for the project to be created, then click **Continue**

## Step 2: Enable Firestore Database

1. In your Firebase project dashboard, click on **"Firestore Database"** in the left sidebar
2. Click **"Create database"**
3. Select **"Start in production mode"** (recommended) or **"Start in test mode"** (for development)
4. Choose a Cloud Firestore location (select the one closest to your users)
5. Click **Enable**

## Step 3: Set Up Firestore Security Rules

1. In the Firestore Database page, click on the **"Rules"** tab
2. Update the rules based on your security requirements:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Allow authenticated users to read/write their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    match /admins/{adminId} {
      allow read, write: if request.auth != null;
    }
    
    match /trades/{tradeId} {
      allow read, write: if request.auth != null;
    }
    
    match /limit_orders/{orderId} {
      allow read, write: if request.auth != null;
    }
    
    match /wallet_transactions/{transactionId} {
      allow read, write: if request.auth != null;
    }
    
    match /wishlists/{wishlistId} {
      allow read, write: if request.auth != null;
    }
    
    match /tokens/{tokenId} {
      allow read, write: if request.auth != null;
    }
  }
}
```

3. Click **Publish**

## Step 4: Generate Service Account Credentials

1. In the Firebase Console, click on the **gear icon** (⚙️) next to "Project Overview"
2. Select **"Project settings"**
3. Navigate to the **"Service accounts"** tab
4. Click on **"Generate new private key"**
5. A dialog will appear warning you to keep the key secure
6. Click **"Generate key"**
7. A JSON file will be downloaded to your computer - **Keep this file secure!**

## Step 5: Extract Credentials from the JSON File

Open the downloaded JSON file. It will look something like this:

```json
{
  "type": "service_account",
  "project_id": "your-project-id",
  "private_key_id": "your-private-key-id",
  "private_key": "-----BEGIN PRIVATE KEY-----\n...\n-----END PRIVATE KEY-----\n",
  "client_email": "firebase-adminsdk-xxxxx@your-project-id.iam.gserviceaccount.com",
  "client_id": "123456789",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/..."
}
```

## Step 6: Update Your .env File

Create or update your `.env` file in the project root with the following values from the JSON file:

```env
PORT=3000

ZERODHA_API_KEY=your_zerodha_api_key
ZERODHA_API_SECRET=your_zerodha_api_secret
ACCESS_TOKEN=your_access_token
KITE_API_URL=https://api.kite.trade

# Firebase Configuration
FIREBASE_PROJECT_ID=your-project-id
FIREBASE_PRIVATE_KEY_ID=your-private-key-id
FIREBASE_PRIVATE_KEY="-----BEGIN PRIVATE KEY-----\n...\n-----END PRIVATE KEY-----\n"
FIREBASE_CLIENT_EMAIL=firebase-adminsdk-xxxxx@your-project-id.iam.gserviceaccount.com
FIREBASE_CLIENT_ID=123456789
FIREBASE_CLIENT_CERT_URL=https://www.googleapis.com/robot/v1/metadata/x509/...

# JWT Token Secret
TOKEN_SECRET=your_jwt_secret_key_here

# CORS Configuration
CORS_ORIGIN=http://localhost:3000
```

**Important Notes:**
- For `FIREBASE_PRIVATE_KEY`, copy the entire private key including the `-----BEGIN PRIVATE KEY-----` and `-----END PRIVATE KEY-----` parts
- Make sure to wrap the private key in quotes
- The `\n` characters in the private key should remain as `\n` (not actual newlines)

## Step 7: Install Dependencies

Run the following command to install the Firebase Admin SDK:

```bash
npm install
```

This will install `firebase-admin` and all other dependencies.

## Step 8: Create Firestore Indexes (Optional but Recommended)

For better query performance, you may want to create indexes:

1. Go to the **Firestore Database** in Firebase Console
2. Click on the **"Indexes"** tab
3. Create composite indexes for frequently queried fields:
   - For `wallet_transactions`: Index on `user` (Ascending) and `createdAt` (Descending)
   - For `trades`: Index on `user` (Ascending) and `type` (Ascending)
   - For `limit_orders`: Index on `user` (Ascending) and `status` (Ascending)

## Step 9: Test the Connection

Start your application:

```bash
npm run dev
```

You should see a message in the console:
```
Firebase connected successfully
```

If you see this message, your Firebase setup is complete!

## Firestore Collections Structure

Your application will use the following Firestore collections:

- **users** - User accounts and profiles
- **admins** - Admin accounts
- **trades** - Trading records
- **limit_orders** - Limit and stop-loss orders
- **wallet_transactions** - Wallet transaction history
- **wishlists** - User watchlists
- **tokens** - Authentication tokens

## Security Best Practices

1. **Never commit your `.env` file** to version control
2. **Keep your service account JSON file secure** - do not share it publicly
3. **Use environment variables** for all sensitive data
4. **Regularly rotate your credentials**
5. **Set up proper Firestore security rules** in production
6. **Enable Firebase App Check** for additional security (optional)

## Troubleshooting

### Error: "Firebase connection error"
- Check that all environment variables are correctly set
- Verify that the private key is properly formatted with `\n` characters
- Ensure the service account has the necessary permissions

### Error: "PERMISSION_DENIED"
- Update your Firestore security rules
- Verify that authentication is working correctly

### Error: "Module not found: firebase-admin"
- Run `npm install` to install all dependencies

## Migration from MongoDB

The following changes were made during migration:

1. **Replaced mongoose with firebase-admin**
2. **Converted Mongoose schemas to Firestore classes**
3. **Updated all model methods** to work with Firestore
4. **Changed `_id` to `id`** for document identifiers
5. **Removed MongoDB-specific features** like pre-save hooks (now handled in the save method)

### Key Differences:

- **Document IDs**: Firestore uses `id` instead of `_id`
- **References**: Instead of ObjectId references, use string IDs
- **Timestamps**: Handled automatically with `createdAt` and `updatedAt` fields
- **Queries**: Firestore queries are different from MongoDB queries (see model files for examples)

## Additional Resources

- [Firebase Documentation](https://firebase.google.com/docs)
- [Firestore Documentation](https://firebase.google.com/docs/firestore)
- [Firebase Admin SDK Documentation](https://firebase.google.com/docs/admin/setup)
- [Firestore Security Rules](https://firebase.google.com/docs/firestore/security/get-started)

## Support

If you encounter any issues, please refer to the Firebase documentation or contact your development team.
