# GitHub Issues to Documentation Mapping

This file maps each GitHub issue to the corresponding technical documentation in `docs/04-USER-STORIES.md`.

## Issue Links to Technical Documentation

| Issue # | Story ID | Title | Technical Details Location |
|---------|----------|-------|---------------------------|
| #7 | US-101 | User Registration | [docs/04-USER-STORIES.md - US-101](docs/04-USER-STORIES.md#us-101-user-registration) |
| #8 | US-102 | User Login & JWT | [docs/04-USER-STORIES.md - US-102](docs/04-USER-STORIES.md#us-102-user-login--jwt-token-management) |
| #9 | US-103 | User Profile | [docs/04-USER-STORIES.md - US-103](docs/04-USER-STORIES.md#us-103-user-profile-management) |
| #10 | US-104 | User Logout | [docs/04-USER-STORIES.md - US-104](docs/04-USER-STORIES.md#us-104-logout--session-management) |
| #11 | US-201 | Venue Owner Registration | [docs/04-USER-STORIES.md - US-201](docs/04-USER-STORIES.md#us-201-venue-owner-registration--setup) |
| #12 | US-202 | Create & List Venues | [docs/04-USER-STORIES.md - US-202](docs/04-USER-STORIES.md#us-202-create--list-venues) |
| #13 | US-203 | Search & Filter Venues | [docs/04-USER-STORIES.md - US-203](docs/04-USER-STORIES.md#us-203-search--filter-venues) |
| #14 | US-204 | View Venue Details | [docs/04-USER-STORIES.md - US-204](docs/04-USER-STORIES.md#us-204-view-venue-details) |
| #15 | US-205 | Edit & Delete Venues | [docs/04-USER-STORIES.md - US-205](docs/04-USER-STORIES.md#us-205-edit--delete-venues) |
| #16 | US-206 | Venue Reviews & Ratings | [docs/04-USER-STORIES.md - US-206](docs/04-USER-STORIES.md#us-206-venue-reviews--ratings) |
| #17 | US-301 | Submit Booking Request | [docs/04-USER-STORIES.md - US-301](docs/04-USER-STORIES.md#us-301-submit-booking-request) |
| #18 | US-302 | View Booking History | [docs/04-USER-STORIES.md - US-302](docs/04-USER-STORIES.md#us-302-view-booking-history) |
| #19 | US-303 | Approve/Reject Bookings | [docs/04-USER-STORIES.md - US-303](docs/04-USER-STORIES.md#us-303-approvereject-bookings-venue-owner) |
| #20 | US-304 | Cancel Booking | [docs/04-USER-STORIES.md - US-304](docs/04-USER-STORIES.md#us-304-cancel-booking) |
| #21 | US-305 | Booking Status Tracking | [docs/04-USER-STORIES.md - US-305](docs/04-USER-STORIES.md#us-305-booking-status-tracking) |
| #22 | US-401 | Create Availability Slots | [docs/04-USER-STORIES.md - US-401](docs/04-USER-STORIES.md#us-401-create-venue-availability-slots) |
| #23 | US-402 | Block Dates | [docs/04-USER-STORIES.md - US-402](docs/04-USER-STORIES.md#us-402-block-dates-maintenancespecial-events) |
| #24 | US-403 | Check Availability | [docs/04-USER-STORIES.md - US-403](docs/04-USER-STORIES.md#us-403-check-availability) |
| #25 | US-501 | Admin User Management | [docs/04-USER-STORIES.md - US-501](docs/04-USER-STORIES.md#us-501-user-management-admin) |
| #26 | US-502 | Venue Verification | [docs/04-USER-STORIES.md - US-502](docs/04-USER-STORIES.md#us-502-venue-verification--moderation) |
| #27 | US-503 | Booking Dispute Resolution | [docs/04-USER-STORIES.md - US-503](docs/04-USER-STORIES.md#us-503-booking-dispute-resolution) |
| #28 | US-504 | System Monitoring & Reports | [docs/04-USER-STORIES.md - US-504](docs/04-USER-STORIES.md#us-504-system-monitoring--reports) |

---

## How to Use This File

1. **For Developers:** Click the link in the "Technical Details Location" column to go directly to the story's technical specifications
2. **For Project Managers:** Use this as a quick reference to understand which documentation covers which GitHub issue
3. **For PR Reviews:** Reference this file when reviewing PRs to ensure implementation matches the technical specification

---

## What's in Each Story's Technical Details

Each story in `docs/04-USER-STORIES.md` includes:

✅ **API Endpoint** - HTTP method, path, authentication, rate limits
✅ **Request/Response** - JSON examples for success cases  
✅ **Error Responses** - HTTP status codes and error scenarios
✅ **Database Model** - Field names and types for all tables
✅ **Frontend Components** - Exact file paths for React components
✅ **Implementation Steps** - Numbered breakdown of tasks

---

## Quick Links to Documentation

- 📋 **Main User Stories:** [docs/04-USER-STORIES.md](docs/04-USER-STORIES.md)
- 🏗️ **Architecture:** [docs/01-ARCHITECTURE.md](docs/01-ARCHITECTURE.md)  
- 🗄️ **Database Schema:** [docs/02-DATABASE-SCHEMA.md](docs/02-DATABASE-SCHEMA.md)
- 🔌 **API Specification:** [docs/03-API-SPECIFICATION.md](docs/03-API-SPECIFICATION.md)
- 📚 **Detailed Story Guide:** [docs/07-DETAILED-USER-STORIES-GUIDE.md](docs/07-DETAILED-USER-STORIES-GUIDE.md)
- 📖 **Detailed Story Example:** [docs/08-DETAILED-STORY-EXAMPLE-US101.md](docs/08-DETAILED-STORY-EXAMPLE-US101.md)
