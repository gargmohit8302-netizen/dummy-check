# Firebase Migration Checklist

Use this checklist to ensure a complete and successful migration from MongoDB to Firebase Firestore.

## ✅ Completed Steps

- [x] Updated `package.json` (removed mongoose, added firebase-admin)
- [x] Created `database/firebaseConnect.js`
- [x] Updated `app.js` to use Firebase connection
- [x] Converted all 7 models to Firestore classes:
  - [x] userModel.js
  - [x] adminModel.js
  - [x] walletModel.js
  - [x] tradeModel.js
  - [x] limitOrderModel.js
  - [x] wishlistModel.js
  - [x] tokenModel.js
- [x] Updated `.env.example` with Firebase configuration
- [x] Created documentation files

## 🔲 Remaining Steps

### 1. Firebase Console Setup
- [ ] Create Firebase project
- [ ] Enable Firestore Database
- [ ] Generate service account key
- [ ] Download JSON credentials file
- [ ] Set up Firestore security rules
- [ ] Create composite indexes (if needed)

**Guide**: See `FIREBASE_SETUP_GUIDE.md`

### 2. Environment Configuration
- [ ] Copy `.env.example` to `.env`
- [ ] Add Firebase credentials to `.env`:
  - [ ] FIREBASE_PROJECT_ID
  - [ ] FIREBASE_PRIVATE_KEY_ID
  - [ ] FIREBASE_PRIVATE_KEY
  - [ ] FIREBASE_CLIENT_EMAIL
  - [ ] FIREBASE_CLIENT_ID
  - [ ] FIREBASE_CLIENT_CERT_URL
- [ ] Add TOKEN_SECRET
- [ ] Add CORS_ORIGIN
- [ ] Verify all Zerodha credentials

### 3. Install Dependencies
- [ ] Run `npm install`
- [ ] Verify firebase-admin is installed
- [ ] Check for any dependency conflicts

### 4. Update Code References (_id to id)

**Priority Files** (Must Update):

- [ ] `middleware/authentication.js` (2 occurrences)
  - Update JWT payload handling
  - Update req.user object

- [ ] `controllers/adminController.js` (2 occurrences)
  - Update admin ID references
  - Update response objects

- [ ] `controllers/userController.js` (36 occurrences)
  - Update user ID references
  - Update trade/wallet/wishlist user references
  - Update query parameters
  - Update response objects

- [ ] `kiteConnect/socket.js` (8 occurrences)
  - Update WebSocket user identification
  - Update trade/order references

- [ ] `utils/helper.js` (1 occurrence)
  - Update helper function references

**Guide**: See `UPDATE_REFERENCES.md`

### 5. Test Basic Functionality

**Authentication Tests**:
- [ ] Test user registration
- [ ] Test user login
- [ ] Test JWT token generation
- [ ] Test authentication middleware

**User Operations**:
- [ ] Test get user profile
- [ ] Test update user profile
- [ ] Test wallet operations

**Trading Operations**:
- [ ] Test create trade
- [ ] Test get trades
- [ ] Test update trade
- [ ] Test delete trade

**Limit Orders**:
- [ ] Test create limit order
- [ ] Test get limit orders
- [ ] Test update order status
- [ ] Test cancel order

**Wishlist**:
- [ ] Test add to wishlist
- [ ] Test get wishlist
- [ ] Test remove from wishlist

**Admin Operations**:
- [ ] Test admin login
- [ ] Test get all users
- [ ] Test block/unblock user
- [ ] Test get statistics

### 6. Advanced Testing

- [ ] Test WebSocket connections
- [ ] Test cron jobs (if any)
- [ ] Test error handling
- [ ] Test rate limiting
- [ ] Load testing (optional)

### 7. Data Migration (If Applicable)

If you have existing MongoDB data:

- [ ] Export data from MongoDB
- [ ] Transform data format:
  - [ ] Change `_id` to `id`
  - [ ] Convert ObjectId to strings
  - [ ] Update date formats if needed
- [ ] Create migration script
- [ ] Test migration with sample data
- [ ] Perform full data migration
- [ ] Verify data integrity

### 8. Performance Optimization

- [ ] Create Firestore composite indexes for:
  - [ ] wallet_transactions (user + createdAt)
  - [ ] trades (user + type)
  - [ ] trades (user + createdAt)
  - [ ] limit_orders (user + status)
  - [ ] wishlists (user + wishlist_name)
- [ ] Review query patterns
- [ ] Optimize frequent queries
- [ ] Set up caching if needed

### 9. Security Hardening

- [ ] Update Firestore security rules for production
- [ ] Review authentication flow
- [ ] Verify password hashing
- [ ] Check CORS configuration
- [ ] Enable rate limiting
- [ ] Review error messages (don't expose sensitive info)
- [ ] Set up Firebase App Check (optional)

### 10. Monitoring & Logging

- [ ] Set up Firebase monitoring
- [ ] Configure application logging
- [ ] Set up error tracking (e.g., Sentry)
- [ ] Monitor Firestore usage and costs
- [ ] Set up alerts for errors

### 11. Documentation

- [ ] Update main README (or use README_FIREBASE.md)
- [ ] Document API changes (if any)
- [ ] Update API documentation
- [ ] Document deployment process
- [ ] Create runbook for common issues

### 12. Deployment Preparation

- [ ] Set up production Firebase project
- [ ] Configure production environment variables
- [ ] Update CORS for production domains
- [ ] Set up CI/CD pipeline (if applicable)
- [ ] Create backup strategy
- [ ] Plan rollback procedure

### 13. Final Checks

- [ ] All tests passing
- [ ] No console errors
- [ ] Firebase connection successful
- [ ] All API endpoints working
- [ ] WebSocket connections stable
- [ ] Performance acceptable
- [ ] Security rules in place
- [ ] Monitoring configured

## 📋 Quick Command Reference

```bash
# Install dependencies
npm install

# Run in development
npm run dev

# Run in production
npm start

# Check for _id references
grep -r "\._id" controllers/ middleware/ utils/ kiteConnect/

# Test Firebase connection
node -e "require('./database/firebaseConnect')"
```

## 🚨 Critical Issues to Watch For

1. **Authentication Breaking**: Update JWT payload and middleware first
2. **User ID Mismatches**: Ensure all `._id` changed to `.id`
3. **Query Failures**: Firestore queries are different from MongoDB
4. **Missing Indexes**: Create indexes for compound queries
5. **Security Rules**: Don't leave database open in production

## 📞 Need Help?

- **Firebase Setup**: See `FIREBASE_SETUP_GUIDE.md`
- **Code Updates**: See `UPDATE_REFERENCES.md`
- **Model Usage**: See `QUICK_REFERENCE.md`
- **Migration Details**: See `MIGRATION_SUMMARY.md`

## 🎯 Recommended Order

1. **Firebase Setup** (Steps 1-3)
2. **Authentication Updates** (Step 4 - middleware first)
3. **Controller Updates** (Step 4 - one at a time)
4. **Testing** (Steps 5-6)
5. **Optimization** (Steps 8-9)
6. **Deployment** (Steps 10-12)

## ✨ Success Criteria

Migration is complete when:
- ✅ Application starts without errors
- ✅ Firebase connection successful
- ✅ All API endpoints working
- ✅ Authentication flow working
- ✅ CRUD operations successful
- ✅ No `._id` references in code
- ✅ Security rules configured
- ✅ Production ready

---

**Current Status**: Models converted, Firebase setup pending

**Next Step**: Complete Firebase Console setup (see FIREBASE_SETUP_GUIDE.md)
