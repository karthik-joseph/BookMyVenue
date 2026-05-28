# How to Access Technical Details for Your GitHub Issues

This guide explains exactly where to find the technical specifications for each of the 20 GitHub issues (#7-#28).

## Quick Start (30 seconds)

1. **Find your issue number** - e.g., #17 (US-301)
2. **Go to file:** [`GITHUB-ISSUES-TO-DOCS.md`](GITHUB-ISSUES-TO-DOCS.md)
3. **Find your issue in the table** - locate row with issue #17
4. **Click the link** - opens `docs/04-USER-STORIES.md` directly to US-301
5. **Read the technical details** - API endpoint, JSON examples, database fields, frontend files

---

## The Complete Mapping

### All 20 Issues with Direct Links

| GitHub Issue | Story ID | Find Here |
|--------------|----------|-----------|
| #7 | US-101 | [User Registration](docs/04-USER-STORIES.md#us-101-user-registration) |
| #8 | US-102 | [User Login & JWT](docs/04-USER-STORIES.md#us-102-user-login--jwt-token-management) |
| #9 | US-103 | [User Profile](docs/04-USER-STORIES.md#us-103-user-profile-management) |
| #10 | US-104 | [User Logout](docs/04-USER-STORIES.md#us-104-logout--session-management) |
| #11 | US-201 | [Venue Owner Registration](docs/04-USER-STORIES.md#us-201-venue-owner-registration--setup) |
| #12 | US-202 | [Create & List Venues](docs/04-USER-STORIES.md#us-202-create--list-venues) |
| #13 | US-203 | [Search & Filter Venues](docs/04-USER-STORIES.md#us-203-search--filter-venues) |
| #14 | US-204 | [View Venue Details](docs/04-USER-STORIES.md#us-204-view-venue-details) |
| #15 | US-205 | [Edit & Delete Venues](docs/04-USER-STORIES.md#us-205-edit--delete-venues) |
| #16 | US-206 | [Venue Reviews & Ratings](docs/04-USER-STORIES.md#us-206-venue-reviews--ratings) |
| #17 | US-301 | [Submit Booking Request](docs/04-USER-STORIES.md#us-301-submit-booking-request) |
| #18 | US-302 | [View Booking History](docs/04-USER-STORIES.md#us-302-view-booking-history) |
| #19 | US-303 | [Approve/Reject Bookings](docs/04-USER-STORIES.md#us-303-approvereject-bookings-venue-owner) |
| #20 | US-304 | [Cancel Booking](docs/04-USER-STORIES.md#us-304-cancel-booking) |
| #21 | US-305 | [Booking Status Tracking](docs/04-USER-STORIES.md#us-305-booking-status-tracking) |
| #22 | US-401 | [Create Availability Slots](docs/04-USER-STORIES.md#us-401-create-venue-availability-slots) |
| #23 | US-402 | [Block Dates](docs/04-USER-STORIES.md#us-402-block-dates-maintenancespecial-events) |
| #24 | US-403 | [Check Availability](docs/04-USER-STORIES.md#us-403-check-availability) |
| #25 | US-501 | [Admin User Management](docs/04-USER-STORIES.md#us-501-user-management-admin) |
| #26 | US-502 | [Venue Verification](docs/04-USER-STORIES.md#us-502-venue-verification--moderation) |
| #27 | US-503 | [Booking Dispute Resolution](docs/04-USER-STORIES.md#us-503-booking-dispute-resolution) |
| #28 | US-504 | [System Monitoring & Reports](docs/04-USER-STORIES.md#us-504-system-monitoring--reports) |

---

## What You'll Find in Each Story

Each story in `docs/04-USER-STORIES.md` has a **"Technical Details"** section with:

### 1. API Endpoint
```
Endpoint: POST /api/v1/auth/register/
Auth: None
Rate: 5 requests/hour
```

### 2. Request JSON Example
```json
{
  "email": "user@example.com",
  "password": "SecurePass123!",
  "first_name": "John",
  "last_name": "Doe",
  "user_type": "customer"
}
```

### 3. Response JSON Example
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

### 4. Error Codes
- `400` Email exists
- `400` Weak password
- `429` Rate limited

### 5. Database Fields
- id (UUID primary key)
- email (unique)
- password (hashed)
- first_name (CharField)
- last_name (CharField)
- user_type (CharField)
- is_verified (BooleanField)
- created_at (DateTimeField)

### 6. Frontend Components
- `src/pages/Auth/Register.tsx` - Main registration page
- `src/components/PasswordStrengthMeter.tsx` - Password validator component
- `src/hooks/useRegister.ts` - Custom hook for form logic

### 7. Implementation Steps
1. Create User model
2. Create serializer with validation
3. Implement registration endpoint
4. Setup email verification
5. Create registration form component
6. Add password strength meter

---

## Example Workflow

**Scenario:** You're assigned GitHub issue #17 (US-301)

**Step-by-step:**

1. Click here: [docs/04-USER-STORIES.md - US-301](docs/04-USER-STORIES.md#us-301-submit-booking-request)

2. You'll see:
   - The acceptance criteria (what the feature needs to do)
   - The API endpoint: `POST /api/v1/bookings/`
   - Required request fields (venue_id, booking_date, num_guests, notes)
   - Expected response with booking details
   - Error codes and scenarios
   - Database model: Booking table with fields
   - Frontend files to create
   - Step-by-step implementation guide

3. You now have everything needed to implement the feature!

---

## File Organization

```
book-my-venue/
├── docs/
│   ├── 04-USER-STORIES.md          ← Technical details for all 20 stories
│   ├── 01-ARCHITECTURE.md          ← System design
│   ├── 02-DATABASE-SCHEMA.md       ← All table definitions
│   └── 03-API-SPECIFICATION.md     ← Complete API reference
├── GITHUB-ISSUES-TO-DOCS.md        ← Issues mapped to docs
├── HOW-TO-USE-TECHNICAL-DOCS.md    ← This file
└── README.md                        ← Project overview
```

---

## FAQ

**Q: I have GitHub issue #19 assigned. Where do I find the technical specs?**  
A: Click here: [docs/04-USER-STORIES.md - US-303](docs/04-USER-STORIES.md#us-303-approvereject-bookings-venue-owner)

**Q: What's in the "Technical Details" section?**  
A: API endpoint, JSON examples, error codes, database fields, frontend file paths, and implementation steps.

**Q: Can I find the database schema?**  
A: Yes! See [`docs/02-DATABASE-SCHEMA.md`](docs/02-DATABASE-SCHEMA.md)

**Q: Where's the complete API reference?**  
A: See [`docs/03-API-SPECIFICATION.md`](docs/03-API-SPECIFICATION.md)

**Q: Can I see an example of a fully detailed story?**  
A: Yes! See [`docs/08-DETAILED-STORY-EXAMPLE-US101.md`](docs/08-DETAILED-STORY-EXAMPLE-US101.md)

---

## Key Files

- 📋 **User Stories:** [`docs/04-USER-STORIES.md`](docs/04-USER-STORIES.md)
- 🗺️ **Issue Mapping:** [`GITHUB-ISSUES-TO-DOCS.md`](GITHUB-ISSUES-TO-DOCS.md)
- 🏗️ **Architecture:** [`docs/01-ARCHITECTURE.md`](docs/01-ARCHITECTURE.md)
- 🗄️ **Database:** [`docs/02-DATABASE-SCHEMA.md`](docs/02-DATABASE-SCHEMA.md)
- 🔌 **API Specs:** [`docs/03-API-SPECIFICATION.md`](docs/03-API-SPECIFICATION.md)

---

## Next Steps

1. **Open your GitHub issue** - Find your assigned issue number
2. **Use the table above** - Find your story ID
3. **Click the link** - Opens the technical documentation
4. **Read carefully** - You have all the details you need
5. **Start implementing** - Follow the implementation steps
6. **Reference the examples** - Check JSON examples, file paths, database fields

**Happy coding! 🚀**
