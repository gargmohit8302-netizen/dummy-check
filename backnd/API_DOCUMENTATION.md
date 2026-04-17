# Paper Trading Backend - API Documentation

Base URL: `https://paper-trading-backend-bz8w.onrender.com`

## Authentication

All authenticated endpoints require a Bearer token in the Authorization header:
```
Authorization: Bearer YOUR_TOKEN_HERE
```

---

## Admin Endpoints

### 1. Admin Register
**POST** `/api/admin/register`

Create a new admin account.

**Request Body:**
```json
{
  "name": "Admin Name",
  "email": "admin@example.com",
  "password": "password123"
}
```

**Response (201):**
```json
{
  "statusCode": 201,
  "success": true,
  "data": {
    "id": "admin_id",
    "name": "Admin Name",
    "email": "admin@example.com",
    "token": "jwt_token_here"
  },
  "message": "Admin register successfully"
}
```

---

### 2. Admin Login
**POST** `/api/admin/login`

Login as admin.

**Request Body:**
```json
{
  "email": "admin@example.com",
  "password": "password123"
}
```

**Response (200):**
```json
{
  "statusCode": 200,
  "success": true,
  "data": {
    "id": "admin_id",
    "name": "Admin Name",
    "email": "admin@example.com",
    "token": "jwt_token_here"
  },
  "message": "Admin logged in successfully"
}
```

---

### 3. Admin Logout
**POST** `/api/admin/logout`

Logout admin (requires authentication).

**Headers:**
```
Authorization: Bearer YOUR_ADMIN_TOKEN
```

**Response (200):**
```json
{
  "statusCode": 200,
  "success": true,
  "data": {},
  "message": "Admin logged out successfully"
}
```

---

### 4. Create User
**POST** `/api/admin/create/user`

Create a new user account (no authentication required).

**Request Body:**
```json
{
  "name": "John Doe",
  "email": "john@example.com",
  "password": "password123",
  "phone": "9876543210"
}
```

**Response (201):**
```json
{
  "statusCode": 201,
  "success": true,
  "data": {
    "id": "user_id",
    "name": "John Doe",
    "email": "john@example.com",
    "phone": "9876543210",
    "token": "jwt_token_here"
  },
  "message": "User created successfully"
}
```

---

### 5. Get All Users
**GET** `/api/admin/user?perPage=10&page=1`

Get paginated list of all users (requires admin authentication).

**Headers:**
```
Authorization: Bearer YOUR_ADMIN_TOKEN
```

**Query Parameters:**
- `perPage` (optional): Number of users per page (default: 10)
- `page` (optional): Page number (default: 1)
- `search` (optional): Search by name or email

**Response (200):**
```json
{
  "statusCode": 200,
  "success": true,
  "data": {
    "data": [
      {
        "id": "user_id",
        "name": "John Doe",
        "email": "john@example.com",
        "phone": "9876543210",
        "walletBalance": 10000,
        "isBlocked": false,
        "createdAt": "2024-01-01T00:00:00.000Z"
      }
    ],
    "totalData": 50,
    "perPage": 10,
    "page": 1,
    "totalPages": 5
  },
  "message": ""
}
```

---

### 6. Edit User
**POST** `/api/admin/user/:id`

Edit user details (requires admin authentication).

**Headers:**
```
Authorization: Bearer YOUR_ADMIN_TOKEN
```

**URL Parameters:**
- `id`: User ID

**Request Body:**
```json
{
  "amount": 5000,
  "trade_limit": 100000,
  "isBlocked": false
}
```

**Fields (all optional):**
- `amount`: Add money to user wallet
- `trade_limit`: Set trade limit
- `isBlocked`: Block/unblock user (true/false)

**Response (200):**
```json
{
  "statusCode": 200,
  "success": true,
  "data": {},
  "message": "User profile is edited successfully"
}
```

---

### 7. Get User Wallet Details
**GET** `/api/admin/wallet/:id`

Get wallet details for a specific user (requires admin authentication).

**Headers:**
```
Authorization: Bearer YOUR_ADMIN_TOKEN
```

**URL Parameters:**
- `id`: User ID

**Response (200):**
```json
{
  "statusCode": 200,
  "success": true,
  "data": {
    "balance": 15000,
    "transactions": [
      {
        "id": "transaction_id",
        "type": "credit",
        "amount": 5000,
        "description": "Credit amount by admin",
        "createdAt": "2024-01-01T00:00:00.000Z"
      }
    ]
  },
  "message": ""
}
```

---

## User Endpoints

### 8. User Login
**POST** `/api/user/login`

Login as user.

**Request Body:**
```json
{
  "email": "john@example.com",
  "password": "password123"
}
```

**Response (200):**
```json
{
  "statusCode": 200,
  "success": true,
  "data": {
    "id": "user_id",
    "name": "John Doe",
    "email": "john@example.com",
    "token": "jwt_token_here",
    "walletBalance": 10000
  },
  "message": "User logged in successfully"
}
```

---

### 9. User Logout
**POST** `/api/user/logout`

Logout user (requires authentication).

**Headers:**
```
Authorization: Bearer YOUR_USER_TOKEN
```

**Response (200):**
```json
{
  "statusCode": 200,
  "success": true,
  "data": {},
  "message": "User logged out successfully"
}
```

---

### 10. Get User Profile
**GET** `/api/user`

Get logged-in user profile (requires authentication).

**Headers:**
```
Authorization: Bearer YOUR_USER_TOKEN
```

**Response (200):**
```json
{
  "statusCode": 200,
  "success": true,
  "data": {
    "id": "user_id",
    "name": "John Doe",
    "email": "john@example.com",
    "phone": "9876543210",
    "walletBalance": 10000,
    "trade_limit": 100000,
    "isBlocked": false
  },
  "message": ""
}
```

---

### 11. Get Wallet Details
**GET** `/api/wallet`

Get user wallet balance and transactions (requires authentication).

**Headers:**
```
Authorization: Bearer YOUR_USER_TOKEN
```

**Response (200):**
```json
{
  "statusCode": 200,
  "success": true,
  "data": {
    "balance": 10000,
    "transactions": []
  },
  "message": ""
}
```

---

### 12. Buy Shares
**POST** `/api/buy`

Buy shares (requires authentication).

**Headers:**
```
Authorization: Bearer YOUR_USER_TOKEN
```

**Request Body:**
```json
{
  "instrument_token": "738561",
  "quantity": 10,
  "price": 2500.50,
  "tradingsymbol": "RELIANCE",
  "instrument_type": "EQ"
}
```

**Response (200):**
```json
{
  "statusCode": 200,
  "success": true,
  "data": {
    "trade_id": "trade_id",
    "instrument_token": "738561",
    "quantity": 10,
    "price": 2500.50,
    "total": 25005
  },
  "message": "Trade executed successfully"
}
```

---

### 13. Sell Shares
**POST** `/api/sell`

Sell shares (requires authentication).

**Headers:**
```
Authorization: Bearer YOUR_USER_TOKEN
```

**Request Body:**
```json
{
  "instrument_token": "738561",
  "quantity": 5,
  "price": 2550.00,
  "tradingsymbol": "RELIANCE",
  "instrument_type": "EQ"
}
```

**Response (200):**
```json
{
  "statusCode": 200,
  "success": true,
  "data": {
    "trade_id": "trade_id",
    "instrument_token": "738561",
    "quantity": 5,
    "price": 2550.00,
    "total": 12750
  },
  "message": "Trade executed successfully"
}
```

---

### 14. Get Portfolio
**GET** `/api/portfolio`

Get user's portfolio/holdings (requires authentication).

**Headers:**
```
Authorization: Bearer YOUR_USER_TOKEN
```

**Response (200):**
```json
{
  "statusCode": 200,
  "success": true,
  "data": {
    "holdings": [
      {
        "instrument_token": "738561",
        "tradingsymbol": "RELIANCE",
        "quantity": 5,
        "average_price": 2500.50,
        "current_price": 2550.00,
        "pnl": 247.50
      }
    ],
    "total_value": 12750
  },
  "message": ""
}
```

---

### 15. Search Instruments
**GET** `/api/search?q=RELIANCE`

Search for trading instruments (requires authentication).

**Headers:**
```
Authorization: Bearer YOUR_USER_TOKEN
```

**Query Parameters:**
- `q`: Search query (stock name or symbol)

**Response (200):**
```json
{
  "statusCode": 200,
  "success": true,
  "data": [
    {
      "instrument_token": "738561",
      "tradingsymbol": "RELIANCE",
      "name": "RELIANCE",
      "exchange": "NSE",
      "last_price": 2550.00
    }
  ],
  "message": ""
}
```

---

### 16. Get Market Quotes
**GET** `/api/quote?instruments=NSE:RELIANCE`

Get real-time market quotes (requires authentication).

**Headers:**
```
Authorization: Bearer YOUR_USER_TOKEN
```

**Query Parameters:**
- `instruments`: Comma-separated list of instruments (e.g., NSE:RELIANCE,NSE:INFY)

**Response (200):**
```json
{
  "statusCode": 200,
  "success": true,
  "data": {
    "NSE:RELIANCE": {
      "last_price": 2550.00,
      "change": 25.50,
      "change_percent": 1.01
    }
  },
  "message": ""
}
```

---

### 17. Add to Wishlist
**POST** `/api/wishlist/:wishlist_name/:instrument_token`

Add instrument to wishlist (requires authentication).

**Headers:**
```
Authorization: Bearer YOUR_USER_TOKEN
```

**URL Parameters:**
- `wishlist_name`: Name of wishlist (e.g., "My Stocks")
- `instrument_token`: Instrument token (e.g., "738561")

**Response (200):**
```json
{
  "statusCode": 200,
  "success": true,
  "data": {},
  "message": "Added to wishlist successfully"
}
```

---

### 18. Get Wishlist
**GET** `/api/wishlist/:wishlist_name`

Get instruments in a wishlist (requires authentication).

**Headers:**
```
Authorization: Bearer YOUR_USER_TOKEN
```

**URL Parameters:**
- `wishlist_name`: Name of wishlist

**Response (200):**
```json
{
  "statusCode": 200,
  "success": true,
  "data": {
    "wishlist_name": "My Stocks",
    "instruments": [
      {
        "instrument_token": "738561",
        "tradingsymbol": "RELIANCE",
        "last_price": 2550.00
      }
    ]
  },
  "message": ""
}
```

---

### 19. Delete from Wishlist
**DELETE** `/api/wishlist/:id`

Remove instrument from wishlist (requires authentication).

**Headers:**
```
Authorization: Bearer YOUR_USER_TOKEN
```

**URL Parameters:**
- `id`: Wishlist item ID

**Response (200):**
```json
{
  "statusCode": 200,
  "success": true,
  "data": {},
  "message": "Removed from wishlist successfully"
}
```

---

### 20. Check Market Status
**GET** `/api/market/status`

Check if market is open (requires authentication).

**Headers:**
```
Authorization: Bearer YOUR_USER_TOKEN
```

**Response (200):**
```json
{
  "statusCode": 200,
  "success": true,
  "data": {
    "is_open": true,
    "message": "Market is open"
  },
  "message": ""
}
```

---

## Error Responses

All endpoints return errors in this format:

**400 Bad Request:**
```json
{
  "statusCode": 400,
  "success": false,
  "errors": [],
  "message": "Error message here"
}
```

**401 Unauthorized:**
```json
{
  "statusCode": 401,
  "success": false,
  "errors": [],
  "message": "Invalid credentials"
}
```

**404 Not Found:**
```json
{
  "statusCode": 404,
  "success": false,
  "errors": [],
  "message": "Not Found"
}
```

**422 Validation Error:**
```json
{
  "statusCode": 422,
  "success": false,
  "errors": [
    {
      "email": "Email is required"
    },
    {
      "password": "Password is required"
    }
  ],
  "message": "Received data is not valid"
}
```

---

## Testing with Postman

### Setup:
1. Import the Postman collection
2. Set environment variable:
   - `baseUrl`: `https://paper-trading-backend-bz8w.onrender.com`

### Authentication Flow:
1. **Admin**: Login with `/api/admin/login` → Save token
2. **User**: Create user with `/api/admin/create/user` → Save token
3. Use token in Authorization header for protected endpoints

### Test Credentials:
**Admin:**
- Email: `admin@test.com`
- Password: `admin123`

---

## Rate Limiting

- **Limit**: 500 requests per 15 minutes per IP
- **Headers**: 
  - `RateLimit-Limit`: Maximum requests allowed
  - `RateLimit-Remaining`: Requests remaining
  - `RateLimit-Reset`: Time when limit resets

---

## Notes

1. All timestamps are in ISO 8601 format (UTC)
2. All amounts are in INR
3. Token expires after 7 days
4. WebSocket connection available for real-time market data
5. Market hours: 9:15 AM - 3:30 PM IST (Monday-Friday)
