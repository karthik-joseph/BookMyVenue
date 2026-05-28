#!/usr/bin/env pwsh

$repo = "abhijithoyur/book-my-venue"

Write-Host "`nCreating User Story Issues...`n" -ForegroundColor Cyan

# US-101
gh issue create --repo $repo --title "US-101: User Registration" --body "As a potential user, I want to create an account with email and password.`n`nAcceptance Criteria: Can register with email/password/name, Email validation, Password requirements, Duplicate emails rejected, Confirmation email`n`nStory Points: 3"

# US-102
gh issue create --repo $repo --title "US-102: User Login & JWT Tokens" --body "As a registered user, I want to login and receive JWT tokens.`n`nAcceptance Criteria: Login with email/password, Access/refresh tokens, Secure storage, Failed login error, Refresh before expiry, 401 on expired`n`nStory Points: 3"

# US-103
gh issue create --repo $repo --title "US-103: User Profile Management" --body "As a logged-in user, I want to view and edit my profile.`n`nAcceptance Criteria: View profile, Edit name/phone/bio, Upload picture, Save immediately, Cannot change email`n`nStory Points: 2"

# US-104
gh issue create --repo $repo --title "US-104: Logout & Session Management" --body "As a logged-in user, I want to logout and clear my session.`n`nAcceptance Criteria: Logout from any page, Tokens cleared, Redirected to home, Auto-logout on expiry`n`nStory Points: 1"

# US-201
gh issue create --repo $repo --title "US-201: Venue Owner Registration" --body "As a venue owner, I want to register and set up my profile.`n`nAcceptance Criteria: Select owner role, Owner onboarding, Upload documents, Pending verification status`n`nStory Points: 3"

# US-202
gh issue create --repo $repo --title "US-202: Create & List Venues" --body "As a venue owner, I want to create venue listings with details and images.`n`nAcceptance Criteria: Enter details, Upload images, Add amenities, Assign category, Pending verification, Appears after approval`n`nStory Points: 5"

# US-203
gh issue create --repo $repo --title "US-203: Search & Filter Venues" --body "As a customer, I want to search venues by location, capacity, and price.`n`nAcceptance Criteria: Filter by city/capacity/price/amenities, Sort results, Pagination, Fast response (less than 500ms)`n`nStory Points: 3"

# US-204
gh issue create --repo $repo --title "US-204: View Venue Details" --body "As a customer, I want to view detailed venue information.`n`nAcceptance Criteria: Images/description/amenities/price/reviews, Owner contact, Availability calendar, Direct booking`n`nStory Points: 2"

# US-301
gh issue create --repo $repo --title "US-301: Submit Booking Request" --body "As a customer, I want to submit a booking request.`n`nAcceptance Criteria: Select venue/date, Enter guest count, Special requirements, Submit, Receive confirmation, Pending approval`n`nStory Points: 3"

# US-302
gh issue create --repo $repo --title "US-302: View Booking History" --body "As a customer, I want to view my booking history and status.`n`nAcceptance Criteria: List all bookings, Show status, Display details, Filter by status/venue`n`nStory Points: 2"

# US-303
gh issue create --repo $repo --title "US-303: Approve/Reject Bookings" --body "As a venue owner, I want to approve or reject booking requests.`n`nAcceptance Criteria: View pending requests, Approve/reject, Add notes, Customer notification`n`nStory Points: 3"

# US-304
gh issue create --repo $repo --title "US-304: Cancel Booking" --body "As a customer, I want to cancel a booking.`n`nAcceptance Criteria: Cancel pending/approved bookings, Not past bookings, Reason required, Owner notified`n`nStory Points: 2"

# US-401
gh issue create --repo $repo --title "US-401: Create Availability Slots" --body "As a venue owner, I want to set availability slots.`n`nAcceptance Criteria: Define date ranges, Set time slots, Bulk create, Edit slots`n`nStory Points: 2"

# US-402
gh issue create --repo $repo --title "US-402: Block Dates" --body "As a venue owner, I want to block dates when unavailable.`n`nAcceptance Criteria: Block dates/ranges, Add reason, Remove blocks`n`nStory Points: 1"

# US-403
gh issue create --repo $repo --title "US-403: Check Availability" --body "As a customer, I want to check venue availability.`n`nAcceptance Criteria: View availability calendar, See available/unavailable dates, See time slots, Real-time check`n`nStory Points: 1"

# US-501
gh issue create --repo $repo --title "US-501: Admin User Management" --body "As an admin, I want to manage users and roles.`n`nAcceptance Criteria: View all users, Update roles, Suspend/activate, View details and activity`n`nStory Points: 3"

# US-502
gh issue create --repo $repo --title "US-502: Admin Venue Verification" --body "As an admin, I want to verify and moderate venues.`n`nAcceptance Criteria: View pending venues, Review details/images, Approve/reject, Add notes`n`nStory Points: 3"

# US-503
gh issue create --repo $repo --title "US-503: Handle Booking Disputes" --body "As an admin, I want to handle booking disputes.`n`nAcceptance Criteria: View disputes, Review details, Resolve, Notify parties`n`nStory Points: 3"

# US-504
gh issue create --repo $repo --title "US-504: System Monitoring & Analytics" --body "As an admin, I want to monitor system health and analytics.`n`nAcceptance Criteria: View health metrics, Booking statistics, User growth, Error rates`n`nStory Points: 2"

Write-Host "`n✓ 20 User story issues created`n" -ForegroundColor Green
Write-Host "Total GitHub issues created: 25" -ForegroundColor Green
