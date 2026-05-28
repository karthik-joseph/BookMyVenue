#!/usr/bin/env pwsh

# Book My Venue - Create GitHub Issues Script
# Creates all user stories and task issues

$repo = "abhijithoyur/book-my-venue"

# Array of user stories to create
$userStories = @(
    @{
        id = "US-101"
        title = "User Registration"
        body = "As a potential user, I want to create an account with email and password, so that I can book venues.`n`nAcceptance Criteria:`n- Can register with email, password, first/last name`n- Email validation enforced`n- Password meets security requirements`n- Duplicate emails rejected`n- Confirmation email sent`n`nStory Points: 3"
    },
    @{
        id = "US-102"
        title = "User Login & JWT Token Management"
        body = "As a registered user, I want to login with email/password and receive JWT tokens.`n`nAcceptance Criteria:`n- Login with email/password`n- Returns access_token (15 min) and refresh_token (7 days)`n- Tokens stored securely`n- Failed login shows error`n- Can refresh before expiry`n- Expired token returns 401`n`nStory Points: 3"
    },
    @{
        id = "US-103"
        title = "User Profile Management"
        body = "As a logged-in user, I want to view and edit my profile information.`n`nAcceptance Criteria:`n- View current profile`n- Edit: first name, last name, phone, bio`n- Upload profile picture`n- Changes saved immediately`n- Cannot change email or user_type`n`nStory Points: 2"
    },
    @{
        id = "US-104"
        title = "Logout & Session Management"
        body = "As a logged-in user, I want to logout and have my session cleared.`n`nAcceptance Criteria:`n- Can logout from any page`n- Tokens cleared from localStorage`n- Redirected to home page`n- Expired sessions automatically logout user`n`nStory Points: 1"
    },
    @{
        id = "US-201"
        title = "Venue Owner Registration & Setup"
        body = "As a venue owner, I want to register as a venue owner and set up my profile.`n`nAcceptance Criteria:`n- Select 'venue_owner' during registration`n- Owner-specific onboarding`n- Upload business documents (optional)`n- Profile shows 'pending verification' status`n`nStory Points: 3"
    },
    @{
        id = "US-202"
        title = "Create & List Venues"
        body = "As a venue owner, I want to create a new venue listing with details and images.`n`nAcceptance Criteria:`n- Enter venue details (name, description, address, capacity, price)`n- Upload multiple images (primary + gallery)`n- Add amenities from predefined list`n- Assign category`n- Saved as PENDING verification`n- Appears in search only AFTER admin approval`n`nStory Points: 5"
    },
    @{
        id = "US-203"
        title = "Search & Filter Venues"
        body = "As a customer, I want to search venues by location, capacity, and price.`n`nAcceptance Criteria:`n- Filter by city, capacity range, price range, amenities`n- Sort results (rating, price, recently added)`n- Results paginated (20 per page)`n- Display image, name, price, capacity, rating`n- Search response less than 500ms`n`nStory Points: 3"
    },
    @{
        id = "US-204"
        title = "View Venue Details"
        body = "As a customer, I want to view detailed information about a venue.`n`nAcceptance Criteria:`n- Show images, description, amenities, capacity, price, reviews`n- Show venue owner contact info`n- Show availability calendar`n- Show location on map (optional)`n- Show reviews and ratings`n- Direct booking from details page`n`nStory Points: 2"
    },
    @{
        id = "US-301"
        title = "Submit Booking Request"
        body = "As a customer, I want to submit a booking request for a venue.`n`nAcceptance Criteria:`n- Select venue and date`n- Enter guest count`n- Add special requirements`n- Submit request`n- Receive confirmation`n- Booking saved as PENDING approval`n`nStory Points: 3"
    },
    @{
        id = "US-302"
        title = "View Booking History"
        body = "As a customer, I want to view my booking history and status.`n`nAcceptance Criteria:`n- List all bookings (past and upcoming)`n- Show booking status (PENDING, APPROVED, REJECTED, CANCELLED)`n- Show booking details`n- Filter by status or venue`n`nStory Points: 2"
    },
    @{
        id = "US-303"
        title = "Approve/Reject Bookings"
        body = "As a venue owner, I want to approve or reject booking requests.`n`nAcceptance Criteria:`n- View pending booking requests`n- Approve or reject request`n- Add notes or rejection reason`n- Customer receives notification`n`nStory Points: 3"
    },
    @{
        id = "US-304"
        title = "Cancel Booking"
        body = "As a customer, I want to cancel a booking.`n`nAcceptance Criteria:`n- Can cancel PENDING or APPROVED bookings`n- Cannot cancel past bookings`n- Cancellation reason required`n- Venue owner notified`n`nStory Points: 2"
    },
    @{
        id = "US-401"
        title = "Create Availability Slots"
        body = "As a venue owner, I want to set availability slots for my venue.`n`nAcceptance Criteria:`n- Define available date ranges`n- Set time slots or full-day availability`n- Bulk create slots`n- Edit existing slots`n`nStory Points: 2"
    },
    @{
        id = "US-402"
        title = "Block Dates"
        body = "As a venue owner, I want to block dates when the venue is unavailable.`n`nAcceptance Criteria:`n- Block specific dates or date ranges`n- Add blocking reason (maintenance, personal, etc.)`n- Remove blocked dates`n`nStory Points: 1"
    },
    @{
        id = "US-403"
        title = "Check Availability"
        body = "As a customer, I want to check venue availability before booking.`n`nAcceptance Criteria:`n- View availability calendar`n- See available and unavailable dates`n- See time slots if applicable`n- Real-time availability check`n`nStory Points: 1"
    },
    @{
        id = "US-501"
        title = "Admin User Management"
        body = "As an admin, I want to manage users and their roles.`n`nAcceptance Criteria:`n- View all users`n- Update user roles`n- Suspend/activate users`n- View user details and activity`n`nStory Points: 3"
    },
    @{
        id = "US-502"
        title = "Admin Venue Verification"
        body = "As an admin, I want to verify and moderate venue listings.`n`nAcceptance Criteria:`n- View pending venues`n- Review venue details and images`n- Approve or reject venues`n- Add moderation notes`n`nStory Points: 3"
    },
    @{
        id = "US-503"
        title = "Handle Booking Disputes"
        body = "As an admin, I want to handle booking disputes.`n`nAcceptance Criteria:`n- View reported disputes`n- Review dispute details and evidence`n- Resolve disputes (approve refund, cancel booking, etc.)`n- Notify involved parties`n`nStory Points: 3"
    },
    @{
        id = "US-504"
        title = "System Monitoring & Analytics"
        body = "As an admin, I want to monitor system health and view analytics.`n`nAcceptance Criteria:`n- View system health metrics`n- See booking statistics`n- View user growth`n- Monitor error rates`n`nStory Points: 2"
    }
)

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "Creating User Story Issues" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

$created = 0
foreach ($story in $userStories) {
    gh issue create --repo $repo `
        --title "$($story.id): $($story.title)" `
        --body $story.body
    $created++
    Write-Host "✓ $($story.id) created" -ForegroundColor Green
}

Write-Host "`n========================================" -ForegroundColor Green
Write-Host "✓ Created $created user story issues" -ForegroundColor Green
Write-Host "========================================`n" -ForegroundColor Green

# Show summary
Write-Host "Summary:" -ForegroundColor Cyan
Write-Host "- 5 Epic issues (already created)"
Write-Host "- 20 User story issues (just created)"
Write-Host "- Total: 25 issues on GitHub"
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "1. Visit: https://github.com/abhijithoyur/book-my-venue"
Write-Host "2. Review issues and add additional labels via web UI"
Write-Host "3. Create GitHub Project Board for kanban tracking"
Write-Host "4. Assign team members to issues"
Write-Host "5. Create ~50 task issues for each user story`n"
