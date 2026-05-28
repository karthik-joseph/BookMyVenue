#!/usr/bin/env pwsh
<#
.SYNOPSIS
GitHub Repository Setup Script for Book My Venue MVP
.DESCRIPTION
Automates creation of repository, milestones, labels, and issues
.PARAMETER RepositoryName
Name of the repository
.PARAMETER RepositoryOwner
GitHub username
.PARAMETER RepositoryUrl
Full GitHub repository URL
#>

param(
    [string]$RepositoryName = "book-my-venue",
    [string]$RepositoryOwner = "",
    [string]$RepositoryUrl = ""
)

# Colors for output
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

function Test-GitHubCLI {
    Write-Step "Checking GitHub CLI installation..."
    $ghPath = Get-Command gh -ErrorAction SilentlyContinue
    if (-not $ghPath) {
        Write-Step "GitHub CLI not found. Please install from https://cli.github.com" Error
        exit 1
    }
    Write-Step "GitHub CLI found at $($ghPath.Source)" Success
}

function Test-GitAuthentication {
    Write-Step "Checking GitHub authentication..."
    $auth = gh auth status -t 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-Step "Not authenticated with GitHub. Running: gh auth login" Warning
        gh auth login
    } else {
        Write-Step "GitHub authentication OK" Success
    }
}

function Create-Milestones {
    param([string]$Repo)
    
    Write-Host "`n=== CREATING MILESTONES ===" -ForegroundColor Cyan
    
    $milestones = @(
        @{
            title = "Sprint 1 - Auth & Foundation"
            description = "User authentication, JWT tokens, base infrastructure setup"
            dueDate = (Get-Date).AddDays(14).ToString("yyyy-MM-dd")
        },
        @{
            title = "Sprint 2 - Venues & Bookings"
            description = "Venue management CRUD, booking workflow, availability management"
            dueDate = (Get-Date).AddDays(28).ToString("yyyy-MM-dd")
        },
        @{
            title = "Sprint 3 - Refinement & Admin"
            description = "Feature refinement, admin features, reviews system"
            dueDate = (Get-Date).AddDays(35).ToString("yyyy-MM-dd")
        },
        @{
            title = "Sprint 4 - Testing & Release"
            description = "Comprehensive testing, optimization, production deployment"
            dueDate = (Get-Date).AddDays(42).ToString("yyyy-MM-dd")
        }
    )
    
    foreach ($milestone in $milestones) {
        Write-Step "Creating milestone: $($milestone.title)"
        gh milestone create `
            --repo $Repo `
            --title $milestone.title `
            --description $milestone.description `
            --due-date $milestone.dueDate
        
        if ($LASTEXITCODE -eq 0) {
            Write-Step "  ✓ Created: $($milestone.title)" Success
        } else {
            Write-Step "  ✗ Failed: $($milestone.title)" Warning
        }
    }
}

function Create-Labels {
    param([string]$Repo)
    
    Write-Host "`n=== CREATING LABELS ===" -ForegroundColor Cyan
    
    $labels = @(
        # Type labels
        @{ name = "bug"; color = "d73a49"; description = "Bug report" },
        @{ name = "feature"; color = "28a745"; description = "New feature request" },
        @{ name = "enhancement"; color = "0075ca"; description = "Improvement to existing feature" },
        @{ name = "task"; color = "cccccc"; description = "Implementation task" },
        @{ name = "user-story"; color = "7057ff"; description = "User story from product spec" },
        @{ name = "epic"; color = "4a235a"; description = "Epic (parent of multiple stories)" },
        @{ name = "documentation"; color = "808080"; description = "Documentation update" },
        @{ name = "refactor"; color = "fbca04"; description = "Code refactoring" },
        
        # Module labels
        @{ name = "authentication"; color = "1f77b4"; description = "Auth & user management" },
        @{ name = "venue-management"; color = "2ca02c"; description = "Venue CRUD operations" },
        @{ name = "booking-management"; color = "d62728"; description = "Booking workflow" },
        @{ name = "availability-management"; color = "ff7f0e"; description = "Availability management" },
        @{ name = "admin-dashboard"; color = "8b4513"; description = "Admin features" },
        @{ name = "frontend"; color = "20b2aa"; description = "React/Vite frontend" },
        @{ name = "backend"; color = "4b0082"; description = "Django/DRF backend" },
        @{ name = "database"; color = "696969"; description = "Database/SQL" },
        @{ name = "infrastructure"; color = "2f4f4f"; description = "DevOps/Docker" },
        
        # Priority labels
        @{ name = "P0-Critical"; color = "b60205"; description = "Blocks release" },
        @{ name = "P1-High"; color = "ff6600"; description = "Should do" },
        @{ name = "P2-Medium"; color = "ffff00"; description = "Nice to have" },
        @{ name = "P3-Low"; color = "cccccc"; description = "Future consideration" },
        
        # Status labels
        @{ name = "status/ready"; color = "90ee90"; description = "Ready to start" },
        @{ name = "status/in-progress"; color = "0075ca"; description = "Currently being worked on" },
        @{ name = "status/in-review"; color = "fbca04"; description = "Waiting for code review" },
        @{ name = "status/testing"; color = "ff7f0e"; description = "QA testing" },
        @{ name = "status/blocked"; color = "d73a49"; description = "Blocked by another issue" },
        
        # Skill labels
        @{ name = "skill/django"; color = "0c4b33"; description = "Django-specific" },
        @{ name = "skill/drf"; color = "186a3b"; description = "Django REST Framework" },
        @{ name = "skill/react"; color = "61dafb"; description = "React-specific" },
        @{ name = "skill/typescript"; color = "3178c6"; description = "TypeScript" }
    )
    
    foreach ($label in $labels) {
        Write-Step "Creating label: $($label.name)"
        gh label create `
            --repo $Repo `
            --name $label.name `
            --color $label.color `
            --description $label.description
        
        if ($LASTEXITCODE -eq 0) {
            Write-Step "  ✓ Created: $($label.name)" Success
        } else {
            Write-Step "  ✗ Label may already exist: $($label.name)" Warning
        }
    }
}

function Create-EpicIssue {
    param(
        [string]$Repo,
        [string]$Title,
        [string]$Body,
        [string]$Milestone,
        [array]$Labels
    )
    
    Write-Step "Creating epic: $Title"
    
    $body_file = New-TemporaryFile -Suffix ".md"
    Set-Content -Path $body_file.FullName -Value $Body
    
    $labelStr = $Labels -join ","
    
    gh issue create `
        --repo $Repo `
        --title $Title `
        --body-file $body_file.FullName `
        --milestone $Milestone `
        --label $labelStr
    
    Remove-Item -Path $body_file.FullName -Force
}

function Create-IssuesFromData {
    param([string]$Repo)
    
    Write-Host "`n=== CREATING EPIC ISSUES ===" -ForegroundColor Cyan
    
    # Epic 1: Authentication
    $epic1Body = @"
# [EPIC] Authentication & User Management

## Description
Central epic for user authentication, authorization, and profile management.

## Goals
- Implement JWT-based authentication
- Support user roles (customer, owner, admin)
- Enable secure profile management
- Implement session handling

## User Types Affected
- All users

## Acceptance Criteria
- [ ] All linked user stories are completed
- [ ] Security review passed
- [ ] JWT implementation tested
- [ ] Password requirements enforced
- [ ] API documentation updated

## Related Stories
- US-101: User Registration
- US-102: User Login & JWT
- US-103: User Profile Management
- US-104: Logout & Session
"@

    Create-EpicIssue -Repo $Repo -Title "[EPIC] Authentication & User Management" -Body $epic1Body -Milestone "Sprint 1 - Auth & Foundation" -Labels @("epic", "authentication", "backend")
    
    Write-Step "  ✓ Epic 1 created" Success
    
    # Epic 2: Venue Management
    $epic2Body = @"
# [EPIC] Venue Management

## Description
Epic for venue CRUD operations, search, filtering, and image management.

## Goals
- Enable venue owners to list their venues
- Implement venue search and filtering
- Support image uploads and gallery
- Manage amenities and categories

## Acceptance Criteria
- [ ] All linked user stories completed
- [ ] Search performance < 500ms
- [ ] Image handling robust
- [ ] Admin can verify venues

## Related Stories
- US-201: Venue Owner Registration
- US-202: Create & List Venues
- US-203: Search & Filter Venues
- US-204: View Venue Details
- US-205: Edit & Delete Venues
"@

    Create-EpicIssue -Repo $Repo -Title "[EPIC] Venue Management" -Body $epic2Body -Milestone "Sprint 2 - Venues & Bookings" -Labels @("epic", "venue-management", "backend", "frontend")
    
    Write-Step "  ✓ Epic 2 created" Success
    
    # Epic 3: Booking Management
    $epic3Body = @"
# [EPIC] Booking Management

## Description
Epic for booking submission, approval workflow, and booking history tracking.

## Goals
- Enable customers to submit booking requests
- Implement approval/rejection workflow
- Track booking status transitions
- Support booking cancellation

## Acceptance Criteria
- [ ] Booking workflow operational
- [ ] No double-booking possible
- [ ] Status tracking accurate
- [ ] Notifications sent appropriately

## Related Stories
- US-301: Submit Booking Request
- US-302: View Booking History
- US-303: Approve/Reject Bookings
- US-304: Cancel Booking
"@

    Create-EpicIssue -Repo $Repo -Title "[EPIC] Booking Management" -Body $epic3Body -Milestone "Sprint 2 - Venues & Bookings" -Labels @("epic", "booking-management", "backend", "frontend")
    
    Write-Step "  ✓ Epic 3 created" Success
    
    # Epic 4: Availability Management
    $epic4Body = @"
# [EPIC] Availability Management

## Description
Epic for managing venue availability and date blocking.

## Goals
- Enable venue owners to set availability
- Support date blocking for maintenance
- Validate availability before booking

## Acceptance Criteria
- [ ] All linked stories completed
- [ ] Calendar views working
- [ ] Availability validation accurate

## Related Stories
- US-401: Create Availability Slots
- US-402: Block Dates
- US-403: Check Availability
"@

    Create-EpicIssue -Repo $Repo -Title "[EPIC] Availability Management" -Body $epic4Body -Milestone "Sprint 2 - Venues & Bookings" -Labels @("epic", "availability-management", "backend", "frontend")
    
    Write-Step "  ✓ Epic 4 created" Success
    
    # Epic 5: Admin Dashboard
    $epic5Body = @"
# [EPIC] Admin Dashboard

## Description
Epic for admin features including user management, venue moderation, and analytics.

## Goals
- Enable user management
- Support venue verification
- Provide analytics and monitoring
- Handle booking disputes

## Acceptance Criteria
- [ ] Admin can moderate venues
- [ ] User management working
- [ ] Analytics dashboard functional
- [ ] Audit logging active

## Related Stories
- US-501: User Management
- US-502: Venue Verification
- US-503: Booking Disputes
- US-504: System Monitoring
"@

    Create-EpicIssue -Repo $Repo -Title "[EPIC] Admin Dashboard" -Body $epic5Body -Milestone "Sprint 4 - Testing & Release" -Labels @("epic", "admin-dashboard", "backend", "frontend")
    
    Write-Step "  ✓ Epic 5 created" Success
    
    Write-Host "`n=== CREATING USER STORY ISSUES ===" -ForegroundColor Cyan
    
    # User Stories - Sprint 1
    $stories = @(
        @{
            title = "US-101: User Registration"
            milestone = "Sprint 1 - Auth & Foundation"
            labels = @("user-story", "authentication", "feature", "backend", "frontend", "P0-Critical")
            body = @"
## Story
**As a** potential user
**I want to** create an account with email and password
**So that** I can book venues and manage bookings

## Acceptance Criteria
- [ ] User can sign up with email, password, first name, last name
- [ ] Email validation is enforced
- [ ] Password must meet security requirements (min 8 chars, uppercase, number, special char)
- [ ] Duplicate emails are rejected
- [ ] User receives confirmation email with verification link
- [ ] User type (customer/owner) can be selected during signup
- [ ] User can login immediately after registration

## Story Points
3

## Definition of Done
- [ ] All acceptance criteria met
- [ ] Tests written (>80% coverage)
- [ ] Code reviewed and approved
- [ ] API documented
- [ ] Frontend tested in browsers
"@
        },
        @{
            title = "US-102: User Login & JWT Token Management"
            milestone = "Sprint 1 - Auth & Foundation"
            labels = @("user-story", "authentication", "feature", "backend", "frontend", "P0-Critical")
            body = @"
## Story
**As a** registered user
**I want to** login with email/password and receive JWT tokens
**So that** I can authenticate API requests securely

## Acceptance Criteria
- [ ] User can login with email and password
- [ ] Successful login returns access_token (15 min) and refresh_token (7 days)
- [ ] Tokens are stored securely in localStorage
- [ ] Failed login shows appropriate error message
- [ ] User can refresh their token before expiry
- [ ] Expired token returns 401 Unauthorized
- [ ] Token includes user info (id, email, user_type)

## Story Points
3

## Definition of Done
- [ ] JWT implementation working
- [ ] Token refresh endpoint functional
- [ ] Tests for all scenarios
- [ ] Security review passed
"@
        },
        @{
            title = "US-103: User Profile Management"
            milestone = "Sprint 1 - Auth & Foundation"
            labels = @("user-story", "authentication", "feature", "backend", "frontend", "P1-High")
            body = @"
## Story
**As a** logged-in user
**I want to** view and edit my profile information
**So that** I can keep my details up to date

## Acceptance Criteria
- [ ] User can view their current profile
- [ ] User can edit: first name, last name, phone number, bio
- [ ] User can upload profile picture
- [ ] Changes are saved and reflected immediately
- [ ] User cannot change email or user_type
- [ ] Profile picture is validated (format, size)

## Story Points
2
"@
        },
        @{
            title = "US-104: Logout & Session Management"
            milestone = "Sprint 1 - Auth & Foundation"
            labels = @("user-story", "authentication", "feature", "frontend", "P1-High")
            body = @"
## Story
**As a** logged-in user
**I want to** logout and have my session cleared
**So that** my account is secure on shared devices

## Acceptance Criteria
- [ ] User can logout from any page
- [ ] Tokens are cleared from localStorage
- [ ] User is redirected to home page
- [ ] Expired sessions automatically logout user
- [ ] User can logout on all devices (optional for MVP)

## Story Points
1
"@
        },
        @{
            title = "US-201: Venue Owner Registration & Setup"
            milestone = "Sprint 1 - Auth & Foundation"
            labels = @("user-story", "authentication", "feature", "backend", "frontend", "P0-Critical")
            body = @"
## Story
**As a** venue owner
**I want to** register as a venue owner and set up my profile
**So that** I can list my venues on the platform

## Acceptance Criteria
- [ ] Owner can select "venue_owner" during registration
- [ ] Owner receives owner-specific onboarding
- [ ] Owner can upload business documents (optional for MVP)
- [ ] Owner profile shows "pending verification" status
- [ ] Owner can view verification timeline

## Story Points
3
"@
        },
        @{
            title = "US-202: Create & List Venues"
            milestone = "Sprint 2 - Venues & Bookings"
            labels = @("user-story", "venue-management", "feature", "backend", "frontend", "P0-Critical")
            body = @"
## Story
**As a** venue owner
**I want to** create a new venue listing with details and images
**So that** customers can discover my venue

## Acceptance Criteria
- [ ] Owner can enter venue details: name, description, address, capacity, price
- [ ] Owner can upload multiple images (primary + gallery)
- [ ] Owner can add amenities from predefined list
- [ ] Owner can assign category
- [ ] Venue creation is saved as PENDING verification
- [ ] Owner receives confirmation and can track verification status
- [ ] Venue appears in search only AFTER admin approval

## Story Points
5
"@
        },
        @{
            title = "US-203: Search & Filter Venues"
            milestone = "Sprint 2 - Venues & Bookings"
            labels = @("user-story", "venue-management", "feature", "backend", "frontend", "P0-Critical")
            body = @"
## Story
**As a** customer
**I want to** search venues by location, capacity, and price
**So that** I can find suitable venues easily

## Acceptance Criteria
- [ ] Search results show venues by city
- [ ] Filters available: capacity range, price range, amenities, rating
- [ ] Results show: venue image, name, price, capacity, rating
- [ ] Results are paginated (20 per page)
- [ ] Results sorted by rating, price, or recently added
- [ ] Search is fast (< 500ms)

## Story Points
3
"@
        },
        @{
            title = "US-204: View Venue Details"
            milestone = "Sprint 2 - Venues & Bookings"
            labels = @("user-story", "venue-management", "feature", "backend", "frontend", "P0-Critical")
            body = @"
## Story
**As a** customer
**I want to** view detailed information about a venue
**So that** I can decide if it matches my needs

## Acceptance Criteria
- [ ] Venue details include: images, description, amenities, capacity, price, reviews
- [ ] Customer can see venue owner contact info
- [ ] Customer can view availability calendar
- [ ] Customer can see venue location on map (optional for MVP)
- [ ] Customer can see reviews and ratings
- [ ] Customer can go directly to booking from this page

## Story Points
2
"@
        }
    )
    
    # Create first 8 user stories (Sprint 1 & 2 core)
    foreach ($story in $stories) {
        Write-Step "Creating story: $($story.title)"
        $body_file = New-TemporaryFile -Suffix ".md"
        Set-Content -Path $body_file.FullName -Value $story.body
        
        $labelStr = $story.labels -join ","
        
        gh issue create `
            --repo $Repo `
            --title $story.title `
            --body-file $body_file.FullName `
            --milestone $story.milestone `
            --label $labelStr
        
        Remove-Item -Path $body_file.FullName -Force
        
        if ($LASTEXITCODE -eq 0) {
            Write-Step "  ✓ Created: $($story.title)" Success
        }
    }
    
    Write-Step "Sample user stories created. Create remaining stories in GitHub UI or extend this script." Warning
}

# Main execution
Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "Book My Venue - GitHub Setup Script" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

# Check prerequisites
Test-GitHubCLI
Test-GitAuthentication

# Get repository URL from user
if (-not $RepositoryUrl) {
    Write-Host "`nEnter your GitHub repository URL (e.g., https://github.com/username/book-my-venue):"
    $RepositoryUrl = Read-Host "Repository URL"
}

# Extract repo name in format "owner/repo"
$repoMatch = $RepositoryUrl -match 'github\.com[:/]([^/]+)/(.+?)(?:\.git)?$'
if ($repoMatch) {
    $owner = $Matches[1]
    $repo = $Matches[2]
    $Repo = "$owner/$repo"
} else {
    Write-Step "Invalid repository URL format" Error
    exit 1
}

Write-Step "Working with repository: $Repo" Success

# Create milestones
Create-Milestones -Repo $Repo

# Create labels
Create-Labels -Repo $Repo

# Create issues
Create-IssuesFromData -Repo $Repo

Write-Host "`n========================================" -ForegroundColor Green
Write-Host "✓ GitHub Setup Complete!" -ForegroundColor Green
Write-Host "========================================`n" -ForegroundColor Green

Write-Step "Next steps:" Info
Write-Host "1. Go to: https://github.com/$Repo"
Write-Host "2. Go to Projects tab"
Write-Host "3. Create new project: 'Book My Venue Development'"
Write-Host "4. Configure automation for issue tracking"
Write-Host "5. View all created issues and milestones"
Write-Host ""
