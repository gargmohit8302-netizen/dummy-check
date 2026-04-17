# Firebase Firestore Quick Reference

## Model Usage Cheat Sheet

### Creating Documents

```javascript
const User = require('./models/userModel');

// Create new user
const user = new User({
    email: 'user@example.com',
    name: 'John Doe',
    password: 'hashed_password',
    walletBalance: 1000
});
await user.save();
console.log(user.id); // Firestore document ID
```

### Reading Documents

```javascript
// Find by ID
const user = await User.findById('user_id_here');

// Find one by query
const user = await User.findOne({ email: 'user@example.com' });

// Find multiple
const users = await User.find({ isBlocked: 'init' });

// Find all
const allUsers = await User.find();
```

### Updating Documents

```javascript
// Method 1: Find and update
const user = await User.findById(userId);
user.walletBalance = 2000;
user.name = 'Jane Doe';
await user.save();

// Method 2: Using updateOne (for models that support it)
await Trade.updateOne(
    { id: tradeId },
    { $set: { type: 'close' } }
);
```

### Deleting Documents

```javascript
// Delete one
await User.deleteOne({ email: 'user@example.com' });

// Delete many
await Trade.deleteMany({ user: userId });
```

## Model-Specific Examples

### User Model

```javascript
const User = require('./models/userModel');

// Create user
const user = new User({
    email: 'test@example.com',
    name: 'Test User',
    password: 'hashed_password'
});
await user.save();

// Generate JWT token
const token = user.generateToken();

// Get JSON representation
const userJson = user.toJSON1();
```

### Admin Model

```javascript
const Admin = require('./models/adminModel');

// Create admin (password will be hashed on save)
const admin = new Admin({
    email: 'admin@example.com',
    name: 'Admin User',
    password: 'plain_password'
});
admin._isPasswordModified = true; // Mark password as modified
await admin.save();

// Verify password
const isValid = await admin.isPasswordCorrect('plain_password');

// Generate token
const token = admin.generateToken();
```

### Trade Model

```javascript
const Trade = require('./models/tradeModel');

// Create trade
const trade = new Trade({
    type: 'open',
    instrument_id: 12345,
    tradingsymbol: 'RELIANCE',
    exchange: 'NSE',
    price: 2500,
    quantity: 10,
    user: userId,
    buy_type: 'buy',
    instrument_type: 'EQ'
});
await trade.save();

// Find user's trades
const userTrades = await Trade.find({ user: userId });

// Update trade
await Trade.updateOne(
    { id: tradeId },
    { $set: { type: 'close', sell_quantity: 5 } }
);

// Delete trades
await Trade.deleteMany({ user: userId, type: 'cancel' });
```

### Limit Order Model

```javascript
const LimitOrder = require('./models/limitOrderModel');

// Create limit order
const order = new LimitOrder({
    status: 'pending',
    instrument_id: 12345,
    tradingsymbol: 'INFY',
    price: 1500,
    quantity: 20,
    user: userId,
    buy_type: 'buy',
    instrument_type: 'EQ',
    order_type: 'limit'
});
await order.save();

// Find pending orders
const pendingOrders = await LimitOrder.find({ 
    user: userId, 
    status: 'pending' 
});

// Update order status
await LimitOrder.updateOne(
    { id: orderId },
    { $set: { status: 'executed' } }
);
```

### Wallet Transaction Model

```javascript
const WalletTransaction = require('./models/walletModel');

// Create transaction
const transaction = new WalletTransaction({
    type: 'credit',
    amount: 1000,
    description: 'Initial deposit',
    user: userId
});
await transaction.save();

// Get user transactions
const transactions = await WalletTransaction.find({ user: userId });

// Delete user transactions
await WalletTransaction.deleteMany({ user: userId });
```

### Wishlist Model

```javascript
const Wishlist = require('./models/wishlistModel');

// Add to wishlist
const wishlist = new Wishlist({
    instrument_token: 12345,
    tradingsymbol: 'TCS',
    exchange: 'NSE',
    name: 'Tata Consultancy Services',
    user: userId,
    wishlist_name: 'My Stocks'
});
await wishlist.save();

// Get user's wishlist
const items = await Wishlist.find({ 
    user: userId, 
    wishlist_name: 'My Stocks' 
});

// Remove from wishlist
await Wishlist.deleteOne({ 
    user: userId, 
    instrument_token: 12345 
});
```

### Token Model

```javascript
const Token = require('./models/tokenModel');

// Store token
const tokenDoc = new Token({
    token: 'access_token_here'
});
await tokenDoc.save();

// Find token
const tokenDoc = await Token.findOne({ token: 'access_token_here' });

// Update token
await Token.updateOne(
    { id: tokenId },
    { $set: { token: 'new_token_here' } }
);

// Delete token
await Token.deleteOne({ token: 'old_token' });
```

## Common Patterns

### Authentication Flow

```javascript
// Registration
const User = require('./models/userModel');
const bcrypt = require('bcrypt');

const hashedPassword = await bcrypt.hash(password, 10);
const user = new User({
    email,
    name,
    password: hashedPassword
});
await user.save();

const token = user.generateToken();
user.token = token;
await user.save();

// Login
const user = await User.findOne({ email });
if (!user) throw new Error('User not found');

const isValid = await bcrypt.compare(password, user.password);
if (!isValid) throw new Error('Invalid password');

const token = user.generateToken();
user.token = token;
await user.save();
```

### Pagination

```javascript
// Firestore doesn't have skip/limit like MongoDB
// You need to use startAfter for pagination

// First page
const firstQuery = Trade.getCollection()
    .where('user', '==', userId)
    .orderBy('createdAt', 'desc')
    .limit(10);
const firstSnapshot = await firstQuery.get();
const firstPageDocs = firstSnapshot.docs.map(doc => 
    new Trade({ id: doc.id, ...doc.data() })
);

// Next page
const lastDoc = firstSnapshot.docs[firstSnapshot.docs.length - 1];
const nextQuery = Trade.getCollection()
    .where('user', '==', userId)
    .orderBy('createdAt', 'desc')
    .startAfter(lastDoc)
    .limit(10);
const nextSnapshot = await nextQuery.get();
```

### Transactions (Atomic Operations)

```javascript
const { db } = require('./database/firebaseConnect');

// Run in transaction
await db.runTransaction(async (transaction) => {
    const userRef = db.collection('users').doc(userId);
    const userDoc = await transaction.get(userRef);
    
    if (!userDoc.exists) {
        throw new Error('User not found');
    }
    
    const newBalance = userDoc.data().walletBalance - amount;
    if (newBalance < 0) {
        throw new Error('Insufficient balance');
    }
    
    transaction.update(userRef, { walletBalance: newBalance });
    
    // Add wallet transaction
    const transactionRef = db.collection('wallet_transactions').doc();
    transaction.set(transactionRef, {
        type: 'debit',
        amount,
        user: userId,
        description: 'Trade purchase',
        createdAt: new Date(),
        updatedAt: new Date()
    });
});
```

### Batch Operations

```javascript
const { db } = require('./database/firebaseConnect');

const batch = db.batch();

// Delete multiple documents
const trades = await Trade.find({ user: userId, type: 'cancel' });
trades.forEach(trade => {
    const ref = db.collection('trades').doc(trade.id);
    batch.delete(ref);
});

await batch.commit();
```

## Important Notes

1. **IDs are strings**: Firestore document IDs are strings, not ObjectIds
2. **No populate**: You need to manually fetch related documents
3. **Query limitations**: Firestore has different query capabilities than MongoDB
4. **Timestamps**: Managed in the `save()` method, not automatically
5. **Indexes**: May need to create composite indexes in Firebase Console for complex queries

## Environment Variables

```env
FIREBASE_PROJECT_ID=your-project-id
FIREBASE_PRIVATE_KEY_ID=your-private-key-id
FIREBASE_PRIVATE_KEY="-----BEGIN PRIVATE KEY-----\n...\n-----END PRIVATE KEY-----\n"
FIREBASE_CLIENT_EMAIL=firebase-adminsdk-xxxxx@your-project.iam.gserviceaccount.com
FIREBASE_CLIENT_ID=123456789
FIREBASE_CLIENT_CERT_URL=https://www.googleapis.com/robot/v1/metadata/x509/...
TOKEN_SECRET=your_jwt_secret
```

## Useful Links

- [Firebase Console](https://console.firebase.google.com/)
- [Firestore Documentation](https://firebase.google.com/docs/firestore)
- [Firebase Admin SDK](https://firebase.google.com/docs/admin/setup)
