# User Stories

## Story Format

```
**Title**: [Feature Name]
**User Type**: [Customer/Owner/Admin]
**Story Points**: [1-13]
**Priority**: [P0/P1/P2]
**Status**: Backlog/Ready/In Progress/Done
**Dependencies**: [Other stories]
**Sprint**: [Sprint number]

**As a** [type of user]
**I want to** [action/feature]
**So that** [benefit]

**Acceptance Criteria**:
- [ ] Criterion 1
- [ ] Criterion 2
- [ ] Criterion 3

**Notes**:
- Implementation detail 1
- Implementation detail 2
```

---

## Epic 1: Authentication & User Management

### US-101: User Registration
**Status**: Ready
**Story Points**: 3
**Priority**: P0
**Sprint**: Sprint 1

**As a** potential user
**I want to** create an account with email and password
**So that** I can book venues and manage bookings

**Acceptance Criteria**:
- [ ] User can sign up with email, password, first name, last name
- [ ] Email validation is enforced
- [ ] Password must meet security requirements (min 8 chars, uppercase, number, special char)
- [ ] Duplicate emails are rejected
- [ ] User receives confirmation email with verification link
- [ ] User type (customer/owner) can be selected during signup
- [ ] User can login immediately after registration

**Technical Details**:

**API Endpoint:** `POST /api/v1/auth/register/` (Auth: None, Rate: 5/hour)

**Request:**
```json
{
  "email": "user@example.com",
  "password": "SecurePass123!",
  "first_name": "John",
  "last_name": "Doe",
  "user_type": "customer"
}
```

**Response (201):**
```json
{
  "id": "uuid",
  "email": "user@example.com",
  "first_name": "John",
  "user_type": "customer",
  "is_verified": false,
  "created_at": "2024-05-25T10:30:00Z"
}
```

**Errors:** `400` Email exists | `400` Weak password | `429` Rate limited

**Database Fields:** id (UUID), email (unique), password (hashed), first_name, last_name, user_type, is_verified, created_at

**Frontend:** `src/pages/Auth/Register.tsx`, `src/components/PasswordStrengthMeter.tsx`, `src/hooks/useRegister.ts`

**Implementation:** 1) User model 2) Serializer 3) Registration endpoint 4) Email verification 5) Form component 6) Password strength meter

---

### US-102: User Login & JWT Token Management
**Status**: Ready
**Story Points**: 3
**Priority**: P0
**Sprint**: Sprint 1

**As a** registered user
**I want to** login with email/password and receive JWT tokens
**So that** I can authenticate API requests

**Acceptance Criteria**:
- [ ] User can login with email and password
- [ ] Successful login returns access_token (15 min expiry) and refresh_token (7 days)
- [ ] Tokens are stored securely in localStorage
- [ ] Failed login shows appropriate error message
- [ ] User can refresh their token before expiry
- [ ] Expired token returns 401 Unauthorized
- [ ] Token includes user info (id, email, user_type)

**Technical Details**:

**API Endpoints:** `POST /api/v1/auth/login/` (Auth: None) | `POST /api/v1/auth/refresh/` (Auth: Required)

**Request:**
```json
{"email": "user@example.com", "password": "SecurePass123!"}
```

**Response (200):**
```json
{
  "access_token": "eyJ...",
  "refresh_token": "eyJ...",
  "user": {"id": "uuid", "email": "user@example.com", "user_type": "customer"}
}
```

**Errors:** `401` Invalid credentials | `429` Rate limited | `400` Missing fields

**Database Fields:** Token table: token (unique), user_id (FK), is_blacklisted, created_at, expires_at

**Frontend:** `src/pages/Auth/Login.tsx`, `src/hooks/useAuth.ts`, `src/utils/tokenManager.ts`

**Implementation:** 1) JWT setup (djangorestframework-simplejwt) 2) Login endpoint 3) Refresh endpoint 4) Token storage hook 5) Auto-refresh middleware

---

### US-103: User Profile Management
**Status**: Ready
**Story Points**: 2
**Priority**: P1
**Sprint**: Sprint 1

**As a** logged-in user
**I want to** view and edit my profile information
**So that** I can keep my details up to date

**Acceptance Criteria**:
- [ ] User can view their current profile
- [ ] User can edit: first name, last name, phone number, bio
- [ ] User can upload profile picture
- [ ] Changes are saved and reflected immediately
- [ ] User cannot change email or user_type
- [ ] Profile picture is validated (format, size)

**Technical Details**:

**API Endpoints:** `GET /api/v1/profile/` (Auth: Required) | `PATCH /api/v1/profile/` (Auth: Required)

**Request (PATCH):**
```json
{"first_name": "John", "last_name": "Doe", "phone": "+1234567890", "bio": "Event planner", "profile_pic": "<file>"}
```

**Response (200):**
```json
{"id": "uuid", "email": "user@example.com", "first_name": "John", "phone": "+1234567890", "bio": "Event planner", "profile_pic_url": "https://...jpg"}
```

**Errors:** `400` Invalid phone format | `413` Image too large | `401` Unauthorized

**Database Fields:** phone (CharField), bio (TextField), profile_pic (ImageField), updated_at (DateTimeField)

**Frontend:** `src/pages/Profile/ProfilePage.tsx`, `src/components/ProfileForm.tsx`, `src/components/ImageUploader.tsx`

**Implementation:** 1) Profile serializer 2) GET/PATCH endpoints 3) Image upload handler 4) Profile form component 5) Image validation

---

### US-104: Logout & Session Management
**Status**: Ready
**Story Points**: 1
**Priority**: P1
**Sprint**: Sprint 1

**As a** logged-in user
**I want to** logout and have my session cleared
**So that** my account is secure on shared devices

**Acceptance Criteria**:
- [ ] User can logout from any page
- [ ] Tokens are cleared from localStorage
- [ ] User is redirected to home page
- [ ] Expired sessions automatically logout user
- [ ] User can logout on all devices (optional for MVP)

**Technical Details**:

**API Endpoint:** `POST /api/v1/auth/logout/` (Auth: Required)

**Request:** `{"refresh_token": "eyJ..."}`

**Response (200):** `{"detail": "Successfully logged out"}`

**Errors:** `401` Unauthorized | `400` Invalid token

**Database Fields:** TokenBlacklist: token, blacklisted_at, expires_at

**Frontend:** `src/hooks/useLogout.ts`, Logout button in Navigation component

**Implementation:** 1) Logout endpoint with token blacklist 2) Clear localStorage hook 3) Redirect to home 4) Logout button in navbar

---

## Epic 2: Venue Management

### US-201: Venue Owner Registration & Setup
**Status**: Ready
**Story Points**: 3
**Priority**: P0
**Sprint**: Sprint 1

**As a** venue owner
**I want to** register as a venue owner and set up my profile
**So that** I can list my venues

**Acceptance Criteria**:
- [ ] Owner can select "venue_owner" during registration
- [ ] Owner receives owner-specific onboarding
- [ ] Owner can upload business documents (optional for MVP)
- [ ] Owner profile shows "pending verification" status
- [ ] Owner can view verification timeline

**Technical Details**:

**API Endpoint:** `PATCH /api/v1/profile/` with user_type='owner' (Auth: Required)

**Request:** `{"user_type": "owner", "business_name": "ABC Venues", "tax_id": "12345"}`

**Response (200):** `{"id": "uuid", "email": "owner@example.com", "user_type": "owner", "is_verified": false, "verification_status": "pending"}`

**Errors:** `400` Already owner | `403` Not authorized

**Database Fields:** business_name (CharField), tax_id (CharField), verification_status (CharField: pending/approved/rejected), verified_at (DateTimeField)

**Frontend:** `src/pages/Auth/OwnerSignup.tsx`, `src/components/VerificationStatus.tsx`

**Implementation:** 1) Owner type flag 2) User type update endpoint 3) Verification status tracking 4) Owner onboarding flow

---

### US-202: Create & List Venues
**Status**: Ready
**Story Points**: 5
**Priority**: P0
**Sprint**: Sprint 2

**As a** venue owner
**I want to** create a new venue listing with details and images
**So that** customers can discover my venue

**Acceptance Criteria**:
- [ ] Owner can enter venue details: name, description, address, capacity, price
- [ ] Owner can upload multiple images (primary + gallery)
- [ ] Owner can add amenities from predefined list (AC, WiFi, Parking, etc.)
- [ ] Owner can assign category (Banquet Hall, Conference Room, etc.)
- [ ] Venue creation is saved as PENDING verification
- [ ] Owner receives confirmation and can track verification status
- [ ] Venue appears in search only AFTER admin approval

**Technical Details**:

**API Endpoint:** `POST /api/v1/venues/` (Auth: Required, Owner only)

**Request:**
```json
{"name": "Grand Hall", "description": "Spacious venue", "address": "123 Main St", "city": "NYC", "capacity": 500, "price_per_hour": 250, "category": "banquet", "amenities": ["wifi", "parking", "ac"], "images": [<files>]}
```

**Response (201):** `{"id": "uuid", "name": "Grand Hall", "status": "pending_verification", "created_at": "2024-05-25T..."}`

**Errors:** `400` Missing fields | `413` Image too large | `401` Not verified owner

**Database Fields:** Venue: name, description, address, city, capacity, price_per_hour, category, status (pending/approved/rejected), created_at. VenueImage: venue_id (FK), image, is_primary. VenueAmenity: many-to-many to Amenity

**Frontend:** `src/pages/Venues/CreateVenue.tsx`, `src/components/VenueForm.tsx`, `src/components/ImageUploader.tsx`, `src/components/AmenitySelector.tsx`

**Implementation:** 1) Venue model 2) Image upload 3) Amenity multi-select 4) Create endpoint 5) Multi-step form

---

### US-203: Search & Filter Venues
**Status**: Ready
**Story Points**: 3
**Priority**: P0
**Sprint**: Sprint 2

**As a** customer
**I want to** search venues by location, capacity, and price
**So that** I can find suitable venues easily

**Acceptance Criteria**:
- [ ] Search results show venues by city
- [ ] Filters available: capacity range, price range, amenities, rating
- [ ] Search results show: venue image, name, price, capacity, rating
- [ ] Results are paginated (20 per page)
- [ ] Results sorted by rating, price, or recently added
- [ ] Search is fast (< 500ms)

**Technical Details**:

**API Endpoint:** `GET /api/v1/venues/?city=NYC&min_price=100&max_price=500&amenities=wifi,parking&sort=rating` (Auth: None, Paginated)

**Query Params:** city, capacity_min, capacity_max, price_min, price_max, amenities (comma-separated), sort (rating/price/newest), page (default 1), limit (default 20, max 100)

**Response (200):**
```json
{"count": 150, "next": "...", "previous": null, "results": [{"id": "uuid", "name": "Hall", "city": "NYC", "capacity": 500, "price": 250, "rating": 4.5, "image_url": "https://..."}]}
```

**Errors:** `400` Invalid filters | `404` No venues found

**Database Fields:** Indexed: city, capacity, price, status, rating. Full-text search on name, description

**Frontend:** `src/pages/Venues/SearchVenues.tsx`, `src/components/VenueCard.tsx`, `src/components/SearchFilters.tsx`, `src/components/Pagination.tsx`

**Implementation:** 1) List endpoint with filters 2) Database indexes 3) Search form 4) Venue cards 5) Pagination

---

### US-204: View Venue Details
**Status**: Ready
**Story Points**: 2
**Priority**: P0
**Sprint**: Sprint 2

**As a** customer
**I want to** view detailed information about a venue
**So that** I can decide if it matches my needs

**Acceptance Criteria**:
- [ ] Venue details include: images, description, amenities, capacity, price, reviews
- [ ] Customer can see venue owner contact info
- [ ] Customer can view availability calendar
- [ ] Customer can see venue location on map (optional for MVP)
- [ ] Customer can see reviews and ratings
- [ ] Customer can go directly to booking from this page

**Technical Details**:

**API Endpoint:** `GET /api/v1/venues/{id}/` (Auth: None)

**Response (200):**
```json
{"id": "uuid", "name": "Grand Hall", "description": "...", "capacity": 500, "price": 250, "rating": 4.5, "images": [{"url": "...", "primary": true}], "amenities": [{"id": "uuid", "name": "WiFi"}], "owner": {"name": "John", "email": "john@...", "phone": "+1234567890"}, "availability": [{"date": "2024-05-26", "status": "available"}], "reviews": [{"rating": 5, "content": "...", "customer": "Jane"}]}
```

**Errors:** `404` Venue not found

**Database Fields:** Retrieve: Venue, VenueImage, Amenity (M2M), Review, Availability

**Frontend:** `src/pages/Venues/VenueDetail.tsx`, `src/components/ImageGallery.tsx`, `src/components/AvailabilityCalendar.tsx`, `src/components/ReviewList.tsx`, `src/components/BookingButton.tsx`

**Implementation:** 1) Detail endpoint 2) Image gallery 3) Calendar component 4) Reviews list 5) Booking button

---

### US-205: Edit & Delete Venues
**Status**: Ready
**Story Points**: 2
**Priority**: P1
**Sprint**: Sprint 2

**As a** venue owner
**I want to** edit my venue details and images
**So that** I can keep information current

**Acceptance Criteria**:
- [ ] Owner can edit any venue field except category
- [ ] Owner can add/remove images
- [ ] Owner can update amenities
- [ ] Changes are saved immediately
- [ ] Owner can delete venue (soft delete, shows warning)
- [ ] Only owner can edit their own venues

**Technical Details**:

**API Endpoints:** `PATCH /api/v1/venues/{id}/` (Auth: Owner) | `DELETE /api/v1/venues/{id}/` (Auth: Owner)

**Request (PATCH):** `{"name": "New Name", "price": 300, "amenities": ["wifi", "ac"], "images": [<files>]}`

**Response (200):** `{"id": "uuid", "name": "New Name", "price": 300, "updated_at": "2024-05-25T..."}`

**Errors:** `403` Not venue owner | `404` Venue not found | `400` Cannot edit category

**Database Fields:** Updated_at timestamp, soft_delete (is_active flag)

**Frontend:** `src/pages/Venues/EditVenue.tsx` (reuse VenueForm component with prepopulated data)

**Implementation:** 1) PATCH endpoint with permission check 2) Delete endpoint (soft delete) 3) Edit form component 4) Confirm delete modal

---

### US-206: Venue Reviews & Ratings
**Status**: Backlog
**Story Points**: 3
**Priority**: P2
**Sprint**: Sprint 3

**As a** customer
**I want to** leave a review and rating for a venue after booking
**So that** other customers can benefit from my experience

**Acceptance Criteria**:
- [ ] Customer can only review after booking is COMPLETED
- [ ] Review includes: rating (1-5 stars), title, content
- [ ] Reviews are visible on venue detail page
- [ ] Venue average rating updates automatically
- [ ] Admin can moderate/delete reviews
- [ ] Reviews show customer name and booking date

**Technical Details**:

**API Endpoints:** `POST /api/v1/bookings/{id}/reviews/` (Auth: Required) | `GET /api/v1/venues/{id}/reviews/` (Auth: None)

**Request:** `{"booking_id": "uuid", "rating": 5, "title": "Amazing", "content": "Great venue!"}`

**Response (201):** `{"id": "uuid", "rating": 5, "title": "Amazing", "content": "Great venue!", "customer": "Jane", "created_at": "2024-05-25T..."}`

**Errors:** `403` Not booking customer | `400` Booking not completed | `404` Booking not found

**Database Fields:** Review: id, booking_id (FK), customer_id (FK), rating (1-5), title, content, created_at. Update Venue.rating (avg)

**Frontend:** `src/components/ReviewForm.tsx`, `src/components/ReviewList.tsx` (in VenueDetail)

**Implementation:** 1) Review model 2) Create endpoint (only after COMPLETED) 3) List endpoint 4) Star rating component 5) Review form

---

## Epic 3: Booking Management

### US-301: Submit Booking Request
**Status**: Ready
**Story Points**: 3
**Priority**: P0
**Sprint**: Sprint 2

**As a** customer
**I want to** submit a booking request for a venue
**So that** the venue owner can review and approve/reject

**Acceptance Criteria**:
- [ ] Customer can select date, number of guests, and notes
- [ ] System validates: date is available, guests <= capacity
- [ ] Booking is created with PENDING status
- [ ] Total price is calculated (price_per_day × capacity capacity)
- [ ] Confirmation message shows booking details
- [ ] Customer can see booking in their dashboard

**Technical Details**:

**API Endpoint:** `POST /api/v1/bookings/` (Auth: Required, Customer)

**Request:** `{"venue_id": "uuid", "booking_date": "2024-06-15", "num_guests": 100, "notes": "Need parking"}`

**Response (201):** `{"id": "uuid", "venue_id": "uuid", "customer_id": "uuid", "booking_date": "2024-06-15", "num_guests": 100, "total_price": 25000, "status": "pending", "created_at": "2024-05-25T..."}`

**Errors:** `400` Date not available | `400` Guests exceed capacity | `404` Venue not found

**Database Fields:** Booking: id, venue_id (FK), customer_id (FK), booking_date, num_guests, total_price, notes, status (pending/approved/rejected/completed), created_at

**Frontend:** `src/pages/Bookings/CreateBooking.tsx`, `src/components/BookingForm.tsx`, `src/components/BookingConfirmation.tsx`

**Implementation:** 1) Booking model 2) Create endpoint with validation 3) Availability check 4) Price calculation 5) Booking form 6) Confirmation page

---

### US-302: View Booking History
**Status**: Ready
**Story Points**: 2
**Priority**: P1
**Sprint**: Sprint 2

**As a** customer
**I want to** view all my past and current bookings
**So that** I can track my reservations

**Acceptance Criteria**:
- [ ] Customer can see all bookings (past and future)
- [ ] Bookings show: venue name, date, status, total price
- [ ] Bookings are sorted by date (newest first)
- [ ] Filter by status: PENDING, APPROVED, REJECTED, COMPLETED
- [ ] Pagination (20 per page)
- [ ] Can click on booking to see full details

**Technical Details**:

**API Endpoint:** `GET /api/v1/bookings/?status=pending&sort=-booking_date&page=1` (Auth: Required)

**Query Params:** status, sort (default -booking_date), page, limit (default 20)

**Response (200):**
```json
{"count": 10, "results": [{"id": "uuid", "venue_name": "Hall", "booking_date": "2024-06-15", "status": "pending", "total_price": 25000, "created_at": "2024-05-25T..."}]}
```

**Errors:** `401` Unauthorized

**Database Fields:** Query: Booking filtered by customer_id, sorted, paginated

**Frontend:** `src/pages/Bookings/MyBookings.tsx`, `src/components/BookingCard.tsx`, `src/components/BookingFilters.tsx`

**Implementation:** 1) List endpoint with filters 2) Status badges 3) Booking cards 4) Filter buttons 5) Pagination

---

### US-303: Approve/Reject Bookings (Venue Owner)
**Status**: Ready
**Story Points**: 3
**Priority**: P0
**Sprint**: Sprint 2

**As a** venue owner
**I want to** review pending bookings and approve or reject them
**So that** I can manage my venue calendar

**Acceptance Criteria**:
- [ ] Owner sees PENDING bookings in owner dashboard
- [ ] Owner can view booking details: customer info, date, guests
- [ ] Owner can APPROVE booking with optional notes
- [ ] Owner can REJECT booking with rejection reason
- [ ] Customer is notified of approval/rejection
- [ ] Approved booking blocks that date on availability
- [ ] Only venue owner can approve/reject their bookings

**Technical Details**:

**API Endpoints:** `PATCH /api/v1/bookings/{id}/approve/` (Auth: Owner) | `PATCH /api/v1/bookings/{id}/reject/` (Auth: Owner)

**Request (Approve):** `{"notes": "Approved"}`

**Request (Reject):** `{"reason": "Venue no longer available"}`

**Response (200):** `{"id": "uuid", "status": "approved", "updated_at": "2024-05-25T..."}`

**Errors:** `403` Not venue owner | `400` Booking not pending | `404` Booking not found

**Database Fields:** BookingStatus: created_at, updated_at, status, notes. Update Availability.status when approved

**Frontend:** `src/pages/OwnerDashboard/PendingBookings.tsx`, `src/components/BookingApprovalModal.tsx`

**Implementation:** 1) Approve/reject endpoints 2) Permission check 3) Send notifications 4) Update availability 5) Owner dashboard 6) Approval modals

---

### US-304: Cancel Booking
**Status**: Ready
**Story Points**: 2
**Priority**: P1
**Sprint**: Sprint 3

**As a** customer
**I want to** cancel my booking if my plans change
**So that** I don't have to honor the reservation

**Acceptance Criteria**:
- [ ] Customer can cancel PENDING or APPROVED bookings
- [ ] Cancellation requires reason
- [ ] Owner is notified of cancellation
- [ ] Availability is released if booking was APPROVED
- [ ] Cannot cancel within X days of booking date (configurable)
- [ ] Cancelled bookings show in history

**Technical Details**:

**API Endpoint:** `PATCH /api/v1/bookings/{id}/cancel/` (Auth: Required)

**Request:** `{"reason": "Plans changed"}`

**Response (200):** `{"id": "uuid", "status": "cancelled", "updated_at": "2024-05-25T..."}`

**Errors:** `400` Cannot cancel (too close to date) | `403` Not booking customer | `400` Already cancelled

**Database Fields:** BookingCancel: cancelled_at, cancellation_reason. Update Availability if APPROVED

**Frontend:** `src/components/CancelBookingModal.tsx` (in BookingCard)

**Implementation:** 1) Cancel endpoint with date check 2) Reason required 3) Release availability 4) Send notifications 5) Cancel button in booking detail

---

### US-305: Booking Status Tracking
**Status**: Ready
**Story Points**: 2
**Priority**: P1
**Sprint**: Sprint 2

**As a** customer
**I want to** track the status of my booking in real-time
**So that** I know if my booking is confirmed

**Acceptance Criteria**:
- [ ] Booking shows clear status: PENDING, APPROVED, REJECTED, CANCELLED, COMPLETED
- [ ] Status badge shows appropriate color (yellow=pending, green=approved, red=rejected)
- [ ] Customer can see when status changed and by whom
- [ ] History of all status changes is visible
- [ ] Customer can contact owner if needed

**Technical Details**:

**API Endpoint:** `GET /api/v1/bookings/{id}/history/` (Auth: Required)

**Response (200):** `{"id": "uuid", "status_history": [{"status": "pending", "changed_at": "2024-05-25T...", "changed_by": "system"}, {"status": "approved", "changed_at": "2024-05-26T...", "changed_by": "owner_name"}]}`

**Errors:** `404` Booking not found | `403` Unauthorized

**Database Fields:** BookingHistory: booking_id (FK), status, changed_at, changed_by_id (FK)

**Frontend:** `src/components/BookingTimeline.tsx`, Status badge component

**Implementation:** 1) BookingHistory model 2) Auto-log status changes 3) History endpoint 4) Timeline component 5) Status badge colors

---

## Epic 4: Availability Management

### US-401: Create Venue Availability Slots
**Status**: Ready
**Story Points**: 2
**Priority**: P0
**Sprint**: Sprint 2

**As a** venue owner
**I want to** mark dates when my venue is available for booking
**So that** customers can only book available dates

**Acceptance Criteria**:
- [ ] Owner can bulk create availability for date range
- [ ] Each date is treated as full-day slot
- [ ] Owner can set availability for months in advance
- [ ] Availability is created with status = "available"
- [ ] Owner can delete future availability if needed

**Technical Details**:

**API Endpoints:** `POST /api/v1/venues/{id}/availability/` (Auth: Owner) | `DELETE /api/v1/venues/{id}/availability/{date}/` (Auth: Owner)

**Request:** `{"start_date": "2024-06-01", "end_date": "2024-06-30", "recurrence": "daily"}` or `{"dates": ["2024-06-01", "2024-06-02"]}`

**Response (201):** `{"count": 30, "start_date": "2024-06-01", "end_date": "2024-06-30", "status": "available"}`

**Errors:** `400` Invalid date range | `403` Not venue owner

**Database Fields:** Availability: id, venue_id (FK), date, status (available/booked/blocked), created_at, updated_at

**Frontend:** `src/components/AvailabilityBulkEditor.tsx`, `src/components/DateRangeSelector.tsx`

**Implementation:** 1) Availability model 2) Bulk create endpoint 3) Date range picker 4) Calendar editor

---

### US-402: Block Dates (Maintenance/Special Events)
**Status**: Ready
**Story Points**: 1
**Priority**: P1
**Sprint**: Sprint 2

**As a** venue owner
**I want to** block specific dates when venue is unavailable
**So that** customers cannot book during maintenance or special events

**Acceptance Criteria**:
- [ ] Owner can block date ranges
- [ ] Blocked dates show reason (maintenance, special event, etc.)
- [ ] Blocked dates are removed from availability
- [ ] Blocked dates override previously available dates
- [ ] Owner can view all blocked dates

**Technical Details**:

**API Endpoints:** `POST /api/v1/venues/{id}/blocked-dates/` (Auth: Owner) | `DELETE /api/v1/venues/{id}/blocked-dates/{id}/` (Auth: Owner)

**Request:** `{"start_date": "2024-06-15", "end_date": "2024-06-17", "reason": "Maintenance"}`

**Response (201):** `{"id": "uuid", "start_date": "2024-06-15", "end_date": "2024-06-17", "reason": "Maintenance", "status": "blocked"}`

**Errors:** `400` Invalid date | `403` Not venue owner

**Database Fields:** BlockedDate: id, venue_id (FK), start_date, end_date, reason, created_at

**Frontend:** `src/components/BlockDateModal.tsx` (in availability calendar)

**Implementation:** 1) BlockedDate model 2) Create/delete endpoints 3) Block date form 4) Update Availability to blocked

---

### US-403: Check Availability
**Status**: Ready
**Story Points**: 1
**Priority**: P0
**Sprint**: Sprint 2

**As a** customer
**I want to** see which dates are available for a venue
**So that** I can choose the best date for my event

**Acceptance Criteria**:
- [ ] Availability calendar shows available/booked/blocked dates
- [ ] Visual indication: green (available), red (booked), gray (blocked)
- [ ] Customer can hover to see price and details
- [ ] Calendar shows next 3 months by default
- [ ] Can navigate to future months

**Technical Details**:

**API Endpoint:** `GET /api/v1/venues/{id}/availability/?month=2024-06` (Auth: None)

**Query Params:** month (YYYY-MM), year

**Response (200):**
```json
{"venue_id": "uuid", "month": "2024-06", "price": 250, "dates": [{"date": "2024-06-01", "status": "available"}, {"date": "2024-06-15", "status": "blocked", "reason": "Maintenance"}]}
```

**Errors:** `404` Venue not found

**Database Fields:** Query from Availability and BlockedDate tables

**Frontend:** `src/components/AvailabilityCalendar.tsx`, Status badge component

**Implementation:** 1) Availability endpoint 2) Interactive calendar component 3) Color coding (CSS classes) 4) Month navigation 5) Hover tooltip

---

## Epic 5: Admin Dashboard

### US-501: User Management (Admin)
**Status**: Backlog
**Story Points**: 3
**Priority**: P1
**Sprint**: Sprint 4

**As an** admin
**I want to** manage users, view their activity, and handle issues
**So that** I can maintain platform integrity

**Acceptance Criteria**:
- [ ] Admin can view all users with filters (user_type, status)
- [ ] Admin can deactivate/reactivate users
- [ ] Admin can view user activity and booking history
- [ ] Admin can send messages to users
- [ ] Admin can reset user passwords (with email confirmation)
- [ ] Changes are logged in audit trail

**Technical Details**:

**API Endpoints:** `GET /api/v1/admin/users/?search=john&user_type=customer&status=active` (Auth: Admin) | `PATCH /api/v1/admin/users/{id}/deactivate/` (Auth: Admin)

**Query Params:** search, user_type, status, page, limit (default 20)

**Response (200):** `{"count": 100, "results": [{"id": "uuid", "email": "user@example.com", "name": "John", "user_type": "customer", "is_active": true, "created_at": "...", "bookings_count": 5}]}`

**Errors:** `403` Not admin | `404` User not found

**Database Fields:** AuditLog: admin_id (FK), action, target_user_id (FK), timestamp. User: is_active

**Frontend:** `src/pages/AdminDashboard/UserManagement.tsx`, `src/components/UserTable.tsx`, `src/components/DeactivateModal.tsx`

**Implementation:** 1) Admin middleware 2) User list endpoint with filters 3) Deactivate endpoint 4) Audit logging 5) Admin users page

---

### US-502: Venue Verification & Moderation
**Status**: Backlog
**Story Points**: 3
**Priority**: P0
**Sprint**: Sprint 3

**As an** admin
**I want to** review and approve/reject new venue listings
**So that** only legitimate venues are on the platform

**Acceptance Criteria**:
- [ ] Admin sees list of pending venues
- [ ] Admin can view full venue details, images, owner info
- [ ] Admin can APPROVE venue (becomes visible in search)
- [ ] Admin can REJECT venue with reason
- [ ] Admin can request additional info from owner
- [ ] Owner is notified of decision
- [ ] Admin can flag venues for compliance issues

**Technical Details**:

**API Endpoints:** `GET /api/v1/admin/venues/pending/` (Auth: Admin) | `PATCH /api/v1/admin/venues/{id}/approve/` (Auth: Admin) | `PATCH /api/v1/admin/venues/{id}/reject/` (Auth: Admin)

**Request:** `{"action": "approve", "notes": "Approved"}` or `{"action": "reject", "reason": "Incomplete info"}`

**Response (200):** `{"id": "uuid", "status": "approved", "updated_at": "2024-05-25T..."}`

**Errors:** `403` Not admin | `400` Invalid status

**Database Fields:** Venue: status (pending/approved/rejected/flagged), admin_notes. Notification sent to owner_id

**Frontend:** `src/pages/AdminDashboard/VenueModeration.tsx`, `src/components/VenueApprovalModal.tsx`, `src/components/VenueCard.tsx`

**Implementation:** 1) Admin venue list endpoint 2) Approve/reject endpoints 3) Send notifications 4) Moderation page 5) Approval modals

---

### US-503: Booking Dispute Resolution
**Status**: Backlog
**Story Points**: 3
**Priority**: P2
**Sprint**: Sprint 4

**As an** admin
**I want to** handle disputes between customers and venue owners
**So that** platform trust is maintained

**Acceptance Criteria**:
- [ ] Admin can view disputed bookings
- [ ] Admin can view communication history
- [ ] Admin can make decisions: refund, cancel, force approve
- [ ] Decisions are documented in audit trail
- [ ] Both parties are notified of decision

**Technical Details**:

**API Endpoints:** `GET /api/v1/admin/disputes/` (Auth: Admin) | `PATCH /api/v1/admin/disputes/{id}/resolve/` (Auth: Admin)

**Request:** `{"decision": "refund", "reason": "Venue not as described", "amount": 25000}`

**Response (200):** `{"id": "uuid", "booking_id": "uuid", "decision": "refund", "resolved_at": "2024-05-25T...", "admin_id": "uuid"}`

**Errors:** `403` Not admin | `404` Dispute not found

**Database Fields:** Dispute: id, booking_id (FK), customer_complaint, owner_response, status (open/resolved), decision, resolved_by (FK), resolution_date

**Frontend:** `src/pages/AdminDashboard/DisputeResolution.tsx`, `src/components/DisputeDetail.tsx`

**Implementation:** 1) Dispute model 2) List endpoint 3) Resolve endpoint 4) Send notifications 5) Disputes page

---

### US-504: System Monitoring & Reports
**Status**: Backlog
**Story Points**: 2
**Priority**: P2
**Sprint**: Sprint 4

**As an** admin
**I want to** monitor platform metrics and generate reports
**So that** I can track growth and identify issues

**Acceptance Criteria**:
- [ ] Dashboard shows: total users, venues, bookings, revenue
- [ ] Charts showing growth trends (weekly/monthly)
- [ ] Filters by date range, venue, category
- [ ] Export reports to CSV
- [ ] System health monitoring (API response time, error rates)

**Technical Details**:

**API Endpoint:** `GET /api/v1/admin/analytics/?start_date=2024-05-01&end_date=2024-05-31&metric=all` (Auth: Admin) | `GET /api/v1/admin/analytics/export/?format=csv` (Auth: Admin)

**Response (200):**
```json
{"total_users": 500, "total_venues": 50, "total_bookings": 150, "total_revenue": 375000, "top_venues": [{"name": "Hall", "bookings": 15, "revenue": 37500}], "growth_7d": {"users": 45, "bookings": 25}}
```

**Errors:** `403` Not admin

**Database Fields:** Aggregations from User, Venue, Booking tables. Indexes on created_at

**Frontend:** `src/pages/AdminDashboard/Analytics.tsx`, `src/components/KPICard.tsx`, `src/components/Chart.tsx`, `src/components/DateRangeFilter.tsx`

**Implementation:** 1) Analytics endpoints (aggregations) 2) CSV export 3) Dashboard page 4) KPI cards 5) Chart.js integration 6) Date filter

---

## Sprint Summary

| Sprint | Focus | Stories | Points |
|--------|-------|---------|--------|
| Sprint 1 | Auth & Setup | US-101, US-102, US-103, US-104, US-201 | 12 |
| Sprint 2 | Core Booking | US-202, US-203, US-204, US-205, US-301, US-302, US-303, US-401, US-402, US-403 | 23 |
| Sprint 3 | Refinement | US-206, US-304, US-502 | 8 |
| Sprint 4 | Admin & Polish | US-501, US-503, US-504 | 8 |

---

## Backlog

- Payment Integration (Phase 2)
- Real-time Notifications (Phase 2)
- Advanced Analytics (Phase 2)
- Multi-language Support (Future)
- Mobile App (Future)
