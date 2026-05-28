#!/usr/bin/env pwsh
<#
.SYNOPSIS
GitHub Repository Setup Script for Book My Venue MVP
.DESCRIPTION
Automates creation of milestones, labels, and issues
#>

param(
    [string]$Repo = "abhijithoyur/book-my-venue"
)

$colors = @{
    Success = "Green"
    Error = "Red"
    Warning = "Yellow"
    Info = "Cyan"
}

function Write-Step {
    param([string]$Message, [string]$Type = "Info")
    Write-Host ">> $Message" -ForegroundColor $colors[$Type]
}

# Refresh PATH
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "Book My Venue - GitHub Setup Script" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

Write-Step "Creating Milestones..." Info

# Sprint 1
gh milestone create --repo $Repo --title "Sprint 1 - Auth & Foundation" --description "User authentication, JWT tokens, base infrastructure setup" --due-date (Get-Date).AddDays(14).ToString("yyyy-MM-dd")
Write-Step "  ✓ Sprint 1" Success

# Sprint 2
gh milestone create --repo $Repo --title "Sprint 2 - Venues & Bookings" --description "Venue management CRUD, booking workflow, availability management" --due-date (Get-Date).AddDays(28).ToString("yyyy-MM-dd")
Write-Step "  ✓ Sprint 2" Success

# Sprint 3
gh milestone create --repo $Repo --title "Sprint 3 - Refinement & Admin" --description "Feature refinement, admin features, reviews system" --due-date (Get-Date).AddDays(35).ToString("yyyy-MM-dd")
Write-Step "  ✓ Sprint 3" Success

# Sprint 4
gh milestone create --repo $Repo --title "Sprint 4 - Testing & Release" --description "Comprehensive testing, optimization, production deployment" --due-date (Get-Date).AddDays(42).ToString("yyyy-MM-dd")
Write-Step "  ✓ Sprint 4" Success

Write-Host "`n" -ForegroundColor Cyan
Write-Step "Creating Labels..." Info

# Type labels
gh label create --repo $Repo --name "bug" --color "d73a49" --description "Bug report"
gh label create --repo $Repo --name "feature" --color "28a745" --description "New feature request"
gh label create --repo $Repo --name "enhancement" --color "0075ca" --description "Improvement to existing feature"
gh label create --repo $Repo --name "task" --color "cccccc" --description "Implementation task"
gh label create --repo $Repo --name "user-story" --color "7057ff" --description "User story from product spec"
gh label create --repo $Repo --name "epic" --color "4a235a" --description "Epic (parent of multiple stories)"
gh label create --repo $Repo --name "documentation" --color "808080" --description "Documentation update"
gh label create --repo $Repo --name "refactor" --color "fbca04" --description "Code refactoring"
Write-Step "  ✓ Type labels" Success

# Module labels
gh label create --repo $Repo --name "authentication" --color "1f77b4" --description "Auth user management"
gh label create --repo $Repo --name "venue-management" --color "2ca02c" --description "Venue CRUD operations"
gh label create --repo $Repo --name "booking-management" --color "d62728" --description "Booking workflow"
gh label create --repo $Repo --name "availability-management" --color "ff7f0e" --description "Availability management"
gh label create --repo $Repo --name "admin-dashboard" --color "8b4513" --description "Admin features"
gh label create --repo $Repo --name "frontend" --color "20b2aa" --description "React/Vite frontend"
gh label create --repo $Repo --name "backend" --color "4b0082" --description "Django/DRF backend"
gh label create --repo $Repo --name "database" --color "696969" --description "Database/SQL"
gh label create --repo $Repo --name "infrastructure" --color "2f4f4f" --description "DevOps/Docker"
Write-Step "  ✓ Module labels" Success

# Priority labels
gh label create --repo $Repo --name "P0-Critical" --color "b60205" --description "Blocks release"
gh label create --repo $Repo --name "P1-High" --color "ff6600" --description "Should do"
gh label create --repo $Repo --name "P2-Medium" --color "ffff00" --description "Nice to have"
gh label create --repo $Repo --name "P3-Low" --color "cccccc" --description "Future consideration"
Write-Step "  ✓ Priority labels" Success

# Status labels
gh label create --repo $Repo --name "status/ready" --color "90ee90" --description "Ready to start"
gh label create --repo $Repo --name "status/in-progress" --color "0075ca" --description "Currently being worked on"
gh label create --repo $Repo --name "status/in-review" --color "fbca04" --description "Waiting for code review"
gh label create --repo $Repo --name "status/testing" --color "ff7f0e" --description "QA testing"
gh label create --repo $Repo --name "status/blocked" --color "d73a49" --description "Blocked by another issue"
Write-Step "  ✓ Status labels" Success

# Skill labels
gh label create --repo $Repo --name "skill/django" --color "0c4b33" --description "Django-specific"
gh label create --repo $Repo --name "skill/drf" --color "186a3b" --description "Django REST Framework"
gh label create --repo $Repo --name "skill/react" --color "61dafb" --description "React-specific"
gh label create --repo $Repo --name "skill/typescript" --color "3178c6" --description "TypeScript"
Write-Step "  ✓ Skill labels" Success

Write-Host "`n" -ForegroundColor Cyan
Write-Step "Creating Epic Issues..." Info

# Epic 1
$body1 = @"
## Description
Central epic for user authentication, authorization, and profile management.

## Goals
- Implement JWT-based authentication
- Support user roles (customer, owner, admin)
- Enable secure profile management
- Implement session handling

## Acceptance Criteria
- All linked user stories are completed
- Security review passed
- JWT implementation tested
- Password requirements enforced
- API documentation updated
"@

gh issue create --repo $Repo --title "[EPIC] Authentication & User Management" --body $body1 --milestone "Sprint 1 - Auth & Foundation" --label "epic,authentication,backend"
Write-Step "  ✓ Epic 1: Authentication" Success

# Epic 2
$body2 = @"
## Description
Epic for venue CRUD operations, search, filtering, and image management.

## Goals
- Enable venue owners to list their venues
- Implement venue search and filtering
- Support image uploads and gallery
- Manage amenities and categories

## Acceptance Criteria
- All linked user stories completed
- Search performance less than 500ms
- Image handling robust
- Admin can verify venues
"@

gh issue create --repo $Repo --title "[EPIC] Venue Management" --body $body2 --milestone "Sprint 2 - Venues & Bookings" --label "epic,venue-management,backend,frontend"
Write-Step "  ✓ Epic 2: Venue Management" Success

# Epic 3
$body3 = @"
## Description
Epic for booking submission, approval workflow, and booking history tracking.

## Goals
- Enable customers to submit booking requests
- Implement approval/rejection workflow
- Track booking status transitions
- Support booking cancellation

## Acceptance Criteria
- Booking workflow operational
- No double-booking possible
- Status tracking accurate
- Notifications sent appropriately
"@

gh issue create --repo $Repo --title "[EPIC] Booking Management" --body $body3 --milestone "Sprint 2 - Venues & Bookings" --label "epic,booking-management,backend,frontend"
Write-Step "  ✓ Epic 3: Booking Management" Success

# Epic 4
$body4 = @"
## Description
Epic for managing venue availability and date blocking.

## Goals
- Enable venue owners to set availability
- Support date blocking for maintenance
- Validate availability before booking

## Acceptance Criteria
- All linked stories completed
- Calendar views working
- Availability validation accurate
"@

gh issue create --repo $Repo --title "[EPIC] Availability Management" --body $body4 --milestone "Sprint 2 - Venues & Bookings" --label "epic,availability-management,backend,frontend"
Write-Step "  ✓ Epic 4: Availability Management" Success

# Epic 5
$body5 = @"
## Description
Epic for admin features including user management, venue moderation, and analytics.

## Goals
- Enable user management
- Support venue verification
- Provide analytics and monitoring
- Handle booking disputes

## Acceptance Criteria
- Admin can moderate venues
- User management working
- Analytics dashboard functional
- Audit logging active
"@

gh issue create --repo $Repo --title "[EPIC] Admin Dashboard" --body $body5 --milestone "Sprint 4 - Testing & Release" --label "epic,admin-dashboard,backend,frontend"
Write-Step "  ✓ Epic 5: Admin Dashboard" Success

Write-Host "`n" -ForegroundColor Cyan
Write-Step "Creating User Story Issues..." Info

# US-101
$us101 = @"
## Story
As a potential user, I want to create an account with email and password, so that I can book venues and manage bookings.

## Acceptance Criteria
- User can sign up with email, password, first name, last name
- Email validation is enforced
- Password must meet security requirements
- Duplicate emails are rejected
- User receives confirmation email
- User type (customer/owner) can be selected
- User can login immediately after registration

## Story Points: 3
"@

gh issue create --repo $Repo --title "US-101: User Registration" --body $us101 --milestone "Sprint 1 - Auth & Foundation" --label "user-story,authentication,feature,backend,frontend,P0-Critical"
Write-Step "  ✓ US-101: User Registration" Success

# US-102
$us102 = @"
## Story
As a registered user, I want to login with email/password and receive JWT tokens, so that I can authenticate API requests securely.

## Acceptance Criteria
- User can login with email and password
- Successful login returns access_token (15 min) and refresh_token (7 days)
- Tokens are stored securely in localStorage
- Failed login shows appropriate error message
- User can refresh their token before expiry
- Expired token returns 401 Unauthorized
- Token includes user info (id, email, user_type)

## Story Points: 3
"@

gh issue create --repo $Repo --title "US-102: User Login & JWT Token Management" --body $us102 --milestone "Sprint 1 - Auth & Foundation" --label "user-story,authentication,feature,backend,frontend,P0-Critical"
Write-Step "  ✓ US-102: User Login & JWT" Success

# US-103
$us103 = @"
## Story
As a logged-in user, I want to view and edit my profile information, so that I can keep my details up to date.

## Acceptance Criteria
- User can view their current profile
- User can edit: first name, last name, phone number, bio
- User can upload profile picture
- Changes are saved and reflected immediately
- User cannot change email or user_type
- Profile picture is validated (format, size)

## Story Points: 2
"@

gh issue create --repo $Repo --title "US-103: User Profile Management" --body $us103 --milestone "Sprint 1 - Auth & Foundation" --label "user-story,authentication,feature,backend,frontend,P1-High"
Write-Step "  ✓ US-103: User Profile Management" Success

# US-104
$us104 = @"
## Story
As a logged-in user, I want to logout and have my session cleared, so that my account is secure on shared devices.

## Acceptance Criteria
- User can logout from any page
- Tokens are cleared from localStorage
- User is redirected to home page
- Expired sessions automatically logout user
- User can logout on all devices (optional for MVP)

## Story Points: 1
"@

gh issue create --repo $Repo --title "US-104: Logout & Session Management" --body $us104 --milestone "Sprint 1 - Auth & Foundation" --label "user-story,authentication,feature,frontend,P1-High"
Write-Step "  ✓ US-104: Logout & Session Management" Success

# US-201
$us201 = @"
## Story
As a venue owner, I want to register as a venue owner and set up my profile, so that I can list my venues on the platform.

## Acceptance Criteria
- Owner can select 'venue_owner' during registration
- Owner receives owner-specific onboarding
- Owner can upload business documents (optional for MVP)
- Owner profile shows 'pending verification' status
- Owner can view verification timeline

## Story Points: 3
"@

gh issue create --repo $Repo --title "US-201: Venue Owner Registration & Setup" --body $us201 --milestone "Sprint 1 - Auth & Foundation" --label "user-story,authentication,feature,backend,frontend,P0-Critical"
Write-Step "  ✓ US-201: Venue Owner Registration" Success

# US-202
$us202 = @"
## Story
As a venue owner, I want to create a new venue listing with details and images, so that customers can discover my venue.

## Acceptance Criteria
- Owner can enter venue details: name, description, address, capacity, price
- Owner can upload multiple images (primary + gallery)
- Owner can add amenities from predefined list
- Owner can assign category
- Venue creation is saved as PENDING verification
- Owner receives confirmation and can track verification status
- Venue appears in search only AFTER admin approval

## Story Points: 5
"@

gh issue create --repo $Repo --title "US-202: Create & List Venues" --body $us202 --milestone "Sprint 2 - Venues & Bookings" --label "user-story,venue-management,feature,backend,frontend,P0-Critical"
Write-Step "  ✓ US-202: Create & List Venues" Success

# US-203
$us203 = @"
## Story
As a customer, I want to search venues by location, capacity, and price, so that I can find suitable venues easily.

## Acceptance Criteria
- Search results show venues by city
- Filters available: capacity range, price range, amenities, rating
- Results show: venue image, name, price, capacity, rating
- Results are paginated (20 per page)
- Results sorted by rating, price, or recently added
- Search is fast (less than 500ms)

## Story Points: 3
"@

gh issue create --repo $Repo --title "US-203: Search & Filter Venues" --body $us203 --milestone "Sprint 2 - Venues & Bookings" --label "user-story,venue-management,feature,backend,frontend,P0-Critical"
Write-Step "  ✓ US-203: Search & Filter Venues" Success

# US-204
$us204 = @"
## Story
As a customer, I want to view detailed information about a venue, so that I can decide if it matches my needs.

## Acceptance Criteria
- Venue details include: images, description, amenities, capacity, price, reviews
- Customer can see venue owner contact info
- Customer can view availability calendar
- Customer can see venue location on map (optional for MVP)
- Customer can see reviews and ratings
- Customer can go directly to booking from this page

## Story Points: 2
"@

gh issue create --repo $Repo --title "US-204: View Venue Details" --body $us204 --milestone "Sprint 2 - Venues & Bookings" --label "user-story,venue-management,feature,backend,frontend,P0-Critical"
Write-Step "  ✓ US-204: View Venue Details" Success

Write-Host "`n========================================" -ForegroundColor Green
Write-Host "✓ GitHub Setup Complete!" -ForegroundColor Green
Write-Host "========================================`n" -ForegroundColor Green

Write-Step "Summary:" Info
Write-Host "  ✓ 4 Milestones created (Sprint 1-4)"
Write-Host "  ✓ 30+ Labels created (type, module, priority, status, skills)"
Write-Host "  ✓ 5 Epic Issues created"
Write-Host "  ✓ 8 User Story Issues created"
Write-Host ""
Write-Step "Next Steps:" Info
Write-Host "1. Go to: https://github.com/abhijithoyur/book-my-venue"
Write-Host "2. View Issues tab to see all created issues"
Write-Host "3. Create GitHub Project Board for tracking"
Write-Host "4. Assign team members to issues"
Write-Host "5. Begin Sprint 1 development"
Write-Host ""
