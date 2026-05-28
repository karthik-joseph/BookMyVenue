# API Specification

## Base URL
```
http://localhost:8000/api/v1  (Development)
https://api.bookmyvenue.com/api/v1  (Production)
```

---

## Authentication

### JWT Token Flow
```
POST /auth/register or /auth/login
  ↓
Receive: { access_token, refresh_token }
  ↓
Store tokens in localStorage
  ↓
Include in headers: Authorization: Bearer {access_token}
  ↓
Token expires in 15 minutes (access), 7 days (refresh)
  ↓
Use refresh_token to get new access_token
```

### Headers
```
Authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbGc...
Content-Type: application/json
```

---

## Response Format

### Success Response (2xx)
```json
{
  "success": true,
  "data": {...},
  "message": "Operation successful"
}
```

### Paginated Response
```json
{
  "success": true,
  "data": {
    "count": 100,
    "next": "http://api.bookmyvenue.com/api/v1/venues/?page=2",
    "previous": null,
    "results": [...]
  }
}
```

### Error Response (4xx, 5xx)
```json
{
  "success": false,
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Invalid input",
    "details": {
      "email": ["This field is required"]
    }
  }
}
```

---

## Auth Module Endpoints

### POST /auth/register
Register a new user

**Request:**
```json
{
  "username": "john_doe",
  "email": "john@example.com",
  "password": "SecurePass123!",
  "first_name": "John",
  "last_name": "Doe",
  "phone_number": "+91-9999999999",
  "user_type": "customer"
}
```

**Response (201):**
```json
{
  "success": true,
  "data": {
    "id": "uuid",
    "username": "john_doe",
    "email": "john@example.com",
    "user_type": "customer",
    "access_token": "eyJ0eXAiOiJKV1QiLCJhbGc...",
    "refresh_token": "eyJ0eXAiOiJKV1QiLCJhbGc..."
  }
}
```

---

### POST /auth/login
Login user

**Request:**
```json
{
  "email": "john@example.com",
  "password": "SecurePass123!"
}
```

**Response (200):**
```json
{
  "success": true,
  "data": {
    "id": "uuid",
    "username": "john_doe",
    "email": "john@example.com",
    "user_type": "customer",
    "access_token": "eyJ0eXAiOiJKV1QiLCJhbGc...",
    "refresh_token": "eyJ0eXAiOiJKV1QiLCJhbGc..."
  }
}
```

---

### POST /auth/token/refresh
Refresh access token using refresh token

**Request:**
```json
{
  "refresh": "eyJ0eXAiOiJKV1QiLCJhbGc..."
}
```

**Response (200):**
```json
{
  "success": true,
  "data": {
    "access": "eyJ0eXAiOiJKV1QiLCJhbGc..."
  }
}
```

---

### GET /auth/me
Get current user profile

**Response (200):**
```json
{
  "success": true,
  "data": {
    "id": "uuid",
    "username": "john_doe",
    "email": "john@example.com",
    "first_name": "John",
    "last_name": "Doe",
    "phone_number": "+91-9999999999",
    "user_type": "customer",
    "profile_picture_url": "https://...",
    "is_email_verified": true
  }
}
```

---

## Venue Module Endpoints

### GET /venues/
List all venues with filtering and pagination

**Query Parameters:**
```
?city=Mumbai
?category_id=uuid
?min_price=5000&max_price=50000
?capacity__gte=100
?search=banquet
?page=1
?page_size=20
?ordering=-average_rating
```

**Response (200):**
```json
{
  "success": true,
  "data": {
    "count": 150,
    "next": "...",
    "previous": null,
    "results": [
      {
        "id": "uuid",
        "name": "Grand Ballroom",
        "description": "Luxury venue...",
        "address": "123 Main St",
        "city": "Mumbai",
        "capacity": 500,
        "price_per_day": 50000,
        "average_rating": 4.5,
        "total_bookings": 45,
        "images": [
          {
            "id": "uuid",
            "image_url": "https://...",
            "is_primary": true
          }
        ],
        "amenities": [
          {"id": "uuid", "amenity_name": "AC"},
          {"id": "uuid", "amenity_name": "WiFi"}
        ]
      }
    ]
  }
}
```

---

### POST /venues/
Create a new venue (authenticated, venue_owner only)

**Request:**
```json
{
  "name": "Grand Ballroom",
  "description": "Luxury venue for weddings and corporate events",
  "address": "123 Main St",
  "city": "Mumbai",
  "state": "Maharashtra",
  "postal_code": "400001",
  "phone_number": "+91-8888888888",
  "email": "contact@ballroom.com",
  "capacity": 500,
  "price_per_day": 50000,
  "category_id": "uuid",
  "amenities": ["AC", "WiFi", "Parking"]
}
```

**Response (201):**
```json
{
  "success": true,
  "data": {
    "id": "uuid",
    "owner_id": "uuid",
    "name": "Grand Ballroom",
    "verification_status": "pending",
    "is_active": true,
    "created_at": "2026-05-25T10:30:00Z"
  }
}
```

---

### GET /venues/{id}/
Get venue details

**Response (200):**
```json
{
  "success": true,
  "data": {
    "id": "uuid",
    "owner_id": "uuid",
    "name": "Grand Ballroom",
    "description": "...",
    "address": "123 Main St",
    "city": "Mumbai",
    "capacity": 500,
    "price_per_day": 50000,
    "average_rating": 4.5,
    "total_bookings": 45,
    "is_verified": true,
    "images": [...],
    "amenities": [...],
    "reviews": [...]
  }
}
```

---

### PATCH /venues/{id}/
Update venue (authenticated, owner only)

**Request:**
```json
{
  "description": "Updated description...",
  "price_per_day": 55000
}
```

---

### DELETE /venues/{id}/
Delete venue (authenticated, owner only)

**Response (204):** No content

---

## Availability Module Endpoints

### GET /venues/{id}/availability/
Check venue availability for date range

**Query Parameters:**
```
?start_date=2026-06-01&end_date=2026-06-30
```

**Response (200):**
```json
{
  "success": true,
  "data": {
    "venue_id": "uuid",
    "availability_slots": [
      {
        "date": "2026-06-01",
        "status": "available"
      },
      {
        "date": "2026-06-02",
        "status": "booked"
      },
      {
        "date": "2026-06-03",
        "status": "available"
      }
    ]
  }
}
```

---

### GET /venues/{id}/availability/check/
Quick check if date is available

**Query Parameters:**
```
?date=2026-06-15
```

**Response (200):**
```json
{
  "success": true,
  "data": {
    "date": "2026-06-15",
    "is_available": true
  }
}
```

---

### POST /venues/{id}/availability/bulk-create/
Create availability slots (authenticated, owner only)

**Request:**
```json
{
  "start_date": "2026-06-01",
  "end_date": "2026-06-30"
}
```

**Response (201):**
```json
{
  "success": true,
  "data": {
    "created_count": 30,
    "message": "30 availability slots created"
  }
}
```

---

### POST /venues/{id}/block-dates/
Block dates (maintenance, special events)

**Request:**
```json
{
  "start_date": "2026-06-01",
  "end_date": "2026-06-03",
  "reason": "Maintenance"
}
```

---

## Booking Module Endpoints

### POST /bookings/
Create a new booking request (authenticated, customer only)

**Request:**
```json
{
  "venue_id": "uuid",
  "booking_date": "2026-06-15",
  "number_of_guests": 250,
  "notes": "Would like white decoration"
}
```

**Response (201):**
```json
{
  "success": true,
  "data": {
    "id": "uuid",
    "customer_id": "uuid",
    "venue_id": "uuid",
    "booking_date": "2026-06-15",
    "number_of_guests": 250,
    "total_price": 50000,
    "status": "pending",
    "created_at": "2026-05-25T10:30:00Z"
  }
}
```

---

### GET /bookings/
List user's bookings (authenticated)

**Query Parameters:**
```
?status=pending
?status=approved
?page=1
?page_size=20
```

**Response (200):**
```json
{
  "success": true,
  "data": {
    "count": 5,
    "results": [
      {
        "id": "uuid",
        "venue_id": "uuid",
        "venue_name": "Grand Ballroom",
        "booking_date": "2026-06-15",
        "number_of_guests": 250,
        "total_price": 50000,
        "status": "pending",
        "created_at": "2026-05-25T10:30:00Z"
      }
    ]
  }
}
```

---

### GET /bookings/{id}/
Get booking details (authenticated, customer or owner or admin)

**Response (200):**
```json
{
  "success": true,
  "data": {
    "id": "uuid",
    "customer_id": "uuid",
    "customer_name": "John Doe",
    "customer_email": "john@example.com",
    "venue_id": "uuid",
    "venue_name": "Grand Ballroom",
    "booking_date": "2026-06-15",
    "number_of_guests": 250,
    "total_price": 50000,
    "status": "pending",
    "notes": "Would like white decoration",
    "created_at": "2026-05-25T10:30:00Z",
    "updated_at": "2026-05-25T10:30:00Z"
  }
}
```

---

### POST /bookings/{id}/approve/
Approve booking (authenticated, venue owner only)

**Request:**
```json
{
  "notes": "Approved - confirmed with management"
}
```

**Response (200):**
```json
{
  "success": true,
  "data": {
    "id": "uuid",
    "status": "approved",
    "approved_at": "2026-05-25T11:00:00Z"
  }
}
```

---

### POST /bookings/{id}/reject/
Reject booking (authenticated, venue owner only)

**Request:**
```json
{
  "rejection_reason": "Venue not available for that date"
}
```

**Response (200):**
```json
{
  "success": true,
  "data": {
    "id": "uuid",
    "status": "rejected",
    "rejection_reason": "Venue not available for that date"
  }
}
```

---

### POST /bookings/{id}/cancel/
Cancel booking (authenticated, customer or admin)

**Request:**
```json
{
  "cancellation_reason": "Plans changed"
}
```

**Response (200):**
```json
{
  "success": true,
  "data": {
    "id": "uuid",
    "status": "cancelled",
    "cancelled_by": "customer"
  }
}
```

---

## Admin Module Endpoints

### GET /admin/users/
List all users (authenticated, admin only)

**Query Parameters:**
```
?user_type=customer
?is_active=true
?page=1
?page_size=50
```

---

### GET /admin/venues/pending/
List pending venue verifications (authenticated, admin only)

**Response (200):**
```json
{
  "success": true,
  "data": {
    "count": 10,
    "results": [
      {
        "id": "uuid",
        "owner_id": "uuid",
        "name": "New Venue",
        "verification_status": "pending",
        "created_at": "2026-05-25T10:30:00Z"
      }
    ]
  }
}
```

---

### POST /admin/venues/{id}/verify/
Approve venue verification (authenticated, admin only)

**Request:**
```json
{
  "notes": "Venue verified and approved"
}
```

---

### POST /admin/venues/{id}/reject/
Reject venue (authenticated, admin only)

**Request:**
```json
{
  "rejection_reason": "Venue does not meet standards"
}
```

---

### GET /admin/bookings/
List all bookings (authenticated, admin only)

**Query Parameters:**
```
?status=pending
?venue_id=uuid
?customer_id=uuid
?page=1
```

---

## Error Codes

```
VALIDATION_ERROR        - Input validation failed
UNAUTHORIZED           - Authentication required
FORBIDDEN              - Permission denied
NOT_FOUND              - Resource not found
CONFLICT               - Resource already exists
RATE_LIMIT_EXCEEDED    - Too many requests
INTERNAL_ERROR         - Server error
```

---

## Pagination

All list endpoints return paginated results:

```json
{
  "count": 100,
  "next": "http://api.bookmyvenue.com/api/v1/venues/?page=2",
  "previous": null,
  "results": [...]
}
```

**Default page_size**: 20
**Max page_size**: 100

---

## Filtering & Searching

### Venue Filtering
```
GET /venues/?city=Mumbai&category_id=uuid&capacity__gte=100&search=banquet
```

### Booking Filtering
```
GET /bookings/?status=pending&venue_id=uuid
```

### User Filtering
```
GET /admin/users/?user_type=customer&is_active=true
```

---

## Versioning Strategy

- **Current Version**: v1
- **URL-based versioning**: All endpoints prefixed with `/api/v1/`
- **Backward Compatibility**: v1 will be supported for at least 1 year
- **Deprecation Headers**: Future versions will include deprecation warnings in response headers

---

## Rate Limiting

```
- Auth endpoints: 5 requests per minute
- General endpoints: 60 requests per minute
- Admin endpoints: 100 requests per minute
```

Response headers:
```
X-RateLimit-Limit: 60
X-RateLimit-Remaining: 45
X-RateLimit-Reset: 1623168000
```

---

## Status Codes

| Code | Meaning |
|------|---------|
| 200  | OK |
| 201  | Created |
| 204  | No Content |
| 400  | Bad Request |
| 401  | Unauthorized |
| 403  | Forbidden |
| 404  | Not Found |
| 409  | Conflict |
| 429  | Too Many Requests |
| 500  | Internal Server Error |
| 503  | Service Unavailable |
