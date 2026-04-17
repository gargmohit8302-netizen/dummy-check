# Update References Guide

## Important: ID Field Changes

After migrating from MongoDB to Firestore, document IDs have changed from `_id` to `id`.

## Files That Need Manual Updates

The following files contain references to `._id` that need to be updated to `.id`:

1. **controllers/userController.js** (36 occurrences)
2. **kiteConnect/socket.js** (8 occurrences)
3. **controllers/adminController.js** (2 occurrences)
4. **middleware/authentication.js** (2 occurrences)
5. **utils/helper.js** (1 occurrence)

## How to Update

### Option 1: Manual Search and Replace

For each file listed above:

1. Open the file in your editor
2. Find all instances of `._id`
3. Replace with `.id`
4. Review each change to ensure it's correct

**Example Changes:**

Before:
```javascript
user._id
trade._id
wallet.user._id
```

After:
```javascript
user.id
trade.id
wallet.user.id
```

### Option 2: Automated Search and Replace (Careful!)

You can use a find-and-replace tool, but be careful:

```bash
# For macOS/Linux (use with caution!)
# This is just an example - review changes before committing

# Backup first
cp controllers/userController.js controllers/userController.js.backup

# Then you can manually edit or use sed carefully
# sed -i '' 's/\._id/.id/g' controllers/userController.js
```

**⚠️ Warning**: Automated replacement can cause issues if there are edge cases. Always review changes!

## Common Patterns to Update

### 1. User ID References
```javascript
// Before
const userId = user._id;
const query = { user: user._id };

// After
const userId = user.id;
const query = { user: user.id };
```

### 2. Comparison Operations
```javascript
// Before
if (trade.user._id.toString() === userId) { }

// After
if (trade.user === userId) { }
// Note: Firestore IDs are already strings, no need for .toString()
```

### 3. Response Objects
```javascript
// Before
res.json({ 
    id: user._id,
    email: user.email 
});

// After
res.json({ 
    id: user.id,
    email: user.email 
});
```

### 4. Query Building
```javascript
// Before
const trades = await Trade.find({ user: req.user._id });

// After
const trades = await Trade.find({ user: req.user.id });
```

### 5. JWT Payload
```javascript
// Before (in authentication middleware)
req.user = { _id: decoded._id, email: decoded.email };

// After
req.user = { id: decoded._id, email: decoded.email };
// Note: JWT might still have _id from token, but assign it to id
```

## Special Cases to Watch For

### 1. ObjectId to String Conversion
MongoDB ObjectIds needed `.toString()` for comparison. Firestore IDs are already strings.

```javascript
// Before
if (trade.user._id.toString() === userId.toString()) { }

// After
if (trade.user === userId) { }
```

### 2. Mongoose Populate
Firestore doesn't have populate. You'll need to fetch related documents manually.

```javascript
// Before (Mongoose)
const trades = await Trade.find({ user: userId }).populate('user');

// After (Firestore)
const trades = await Trade.find({ user: userId });
// If you need user details, fetch separately:
const user = await User.findById(userId);
```

### 3. Aggregation Queries
Firestore doesn't support MongoDB-style aggregation. You'll need to:
- Fetch data and aggregate in application code
- Use Firestore's limited aggregation features
- Consider restructuring data for better queries

## Testing After Updates

After updating references, test the following:

1. **User Registration/Login**
   ```bash
   POST /api/register
   POST /api/login
   ```

2. **User Profile**
   ```bash
   GET /api/profile
   ```

3. **Trade Operations**
   ```bash
   POST /api/trades
   GET /api/trades
   ```

4. **Wallet Operations**
   ```bash
   GET /api/wallet
   POST /api/wallet/transaction
   ```

5. **Admin Operations**
   ```bash
   POST /api/admin/login
   GET /api/admin/users
   ```

## Verification Checklist

- [ ] All `._id` references updated to `.id`
- [ ] Removed unnecessary `.toString()` calls
- [ ] Updated JWT token handling
- [ ] Updated authentication middleware
- [ ] Tested user registration
- [ ] Tested user login
- [ ] Tested trade creation
- [ ] Tested wallet operations
- [ ] Tested admin operations
- [ ] Checked WebSocket connections (socket.js)
- [ ] Verified all API endpoints work

## Common Errors After Migration

### Error: "Cannot read property '_id' of undefined"
**Solution**: Change `._id` to `.id`

### Error: "user._id.toString is not a function"
**Solution**: Remove `.toString()` - Firestore IDs are already strings

### Error: "Invalid query"
**Solution**: Check Firestore query syntax - it's different from MongoDB

## Need Help?

If you encounter issues:
1. Check the console for specific error messages
2. Review the model files to understand the new API
3. Check `MIGRATION_SUMMARY.md` for API differences
4. Review Firebase Firestore documentation

## Recommended Approach

1. **Start with authentication files first**:
   - `middleware/authentication.js`
   - Test login/registration

2. **Then update controllers one by one**:
   - `controllers/adminController.js`
   - `controllers/userController.js`
   - Test each controller after updating

3. **Finally update utility files**:
   - `utils/helper.js`
   - `kiteConnect/socket.js`

4. **Test thoroughly** after each update

This incremental approach makes it easier to identify and fix issues.
