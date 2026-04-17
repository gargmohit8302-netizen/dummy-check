# Deploy Firestore Indexes and Rules

This guide shows you how to deploy Firestore indexes and security rules from your code.

## Files Created

✅ **firestore.indexes.json** - Composite indexes for better query performance
✅ **firestore.rules** - Security rules for your Firestore database
✅ **firebase.json** - Firebase configuration file

## Option 1: Deploy Using Firebase CLI (Recommended)

### Step 1: Install Firebase CLI

```bash
npm install -g firebase-tools
```

### Step 2: Login to Firebase

```bash
firebase login
```

This will open a browser window for you to authenticate with your Google account.

### Step 3: Initialize Firebase Project

```bash
firebase init firestore
```

When prompted:
- Select **"Use an existing project"**
- Choose your project: **errtuyrr-ba515**
- For Firestore rules file: Press Enter (use default `firestore.rules`)
- For Firestore indexes file: Press Enter (use default `firestore.indexes.json`)

### Step 4: Deploy Indexes and Rules

```bash
# Deploy both indexes and rules
firebase deploy --only firestore

# Or deploy separately
firebase deploy --only firestore:rules
firebase deploy --only firestore:indexes
```

You should see:
```
✔  Deploy complete!
```

## Option 2: Manual Deployment via Firebase Console

### For Security Rules:

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project: **errtuyrr-ba515**
3. Click **Firestore Database** in the left sidebar
4. Click the **Rules** tab
5. Copy the contents of `firestore.rules` file
6. Paste into the editor
7. Click **Publish**

### For Indexes:

1. In Firebase Console → Firestore Database
2. Click the **Indexes** tab
3. Click **Add Index** for each index in `firestore.indexes.json`:

**Index 1: wallet_transactions**
- Collection ID: `wallet_transactions`
- Fields to index:
  - `user` - Ascending
  - `createdAt` - Descending
- Query scope: Collection

**Index 2: trades (by type)**
- Collection ID: `trades`
- Fields to index:
  - `user` - Ascending
  - `type` - Ascending
- Query scope: Collection

**Index 3: trades (by date)**
- Collection ID: `trades`
- Fields to index:
  - `user` - Ascending
  - `createdAt` - Descending
- Query scope: Collection

**Index 4: limit_orders (by status)**
- Collection ID: `limit_orders`
- Fields to index:
  - `user` - Ascending
  - `status` - Ascending
- Query scope: Collection

**Index 5: limit_orders (by date)**
- Collection ID: `limit_orders`
- Fields to index:
  - `user` - Ascending
  - `createdAt` - Descending
- Query scope: Collection

**Index 6: wishlists**
- Collection ID: `wishlists`
- Fields to index:
  - `user` - Ascending
  - `wishlist_name` - Ascending
- Query scope: Collection

## What These Indexes Do

### wallet_transactions (user + createdAt)
Optimizes queries like:
```javascript
await WalletTransaction.find({ user: userId })
  .orderBy('createdAt', 'desc');
```

### trades (user + type)
Optimizes queries like:
```javascript
await Trade.find({ user: userId, type: 'open' });
```

### trades (user + createdAt)
Optimizes queries like:
```javascript
await Trade.find({ user: userId })
  .orderBy('createdAt', 'desc');
```

### limit_orders (user + status)
Optimizes queries like:
```javascript
await LimitOrder.find({ user: userId, status: 'pending' });
```

### limit_orders (user + createdAt)
Optimizes queries like:
```javascript
await LimitOrder.find({ user: userId })
  .orderBy('createdAt', 'desc');
```

### wishlists (user + wishlist_name)
Optimizes queries like:
```javascript
await Wishlist.find({ user: userId, wishlist_name: 'My Stocks' });
```

## Verify Deployment

### Check Rules:
1. Go to Firebase Console → Firestore Database → Rules
2. You should see the rules from `firestore.rules`

### Check Indexes:
1. Go to Firebase Console → Firestore Database → Indexes
2. You should see all 6 composite indexes
3. Wait for indexes to build (may take a few minutes)
4. Status should change from "Building" to "Enabled"

## Troubleshooting

### Error: "Firebase CLI not found"
```bash
npm install -g firebase-tools
```

### Error: "Not authorized"
```bash
firebase login --reauth
```

### Error: "Project not found"
Make sure you selected the correct project during `firebase init`

### Indexes taking too long to build
- This is normal for large datasets
- Small/empty databases build indexes instantly
- Check status in Firebase Console

## Benefits of Using These Files

✅ **Version Control** - Track changes to rules and indexes in git
✅ **Consistency** - Same configuration across dev/staging/prod
✅ **Automation** - Deploy with CI/CD pipelines
✅ **Documentation** - Clear definition of your database structure

## Next Steps

After deploying:
1. ✅ Verify indexes are enabled in Firebase Console
2. ✅ Test your queries to ensure they're using indexes
3. ✅ Monitor query performance in Firebase Console
4. ✅ Add more indexes as needed based on your query patterns

## Quick Commands Reference

```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login
firebase login

# Initialize
firebase init firestore

# Deploy everything
firebase deploy --only firestore

# Deploy only rules
firebase deploy --only firestore:rules

# Deploy only indexes
firebase deploy --only firestore:indexes

# Check current project
firebase projects:list

# Switch project
firebase use errtuyrr-ba515
```

---

**Recommended**: Use Option 1 (Firebase CLI) for easier deployment and version control!
