# GitHub Setup - Manual Instructions

Since the current GitHub token has limited permissions, here are the manual steps to complete the setup:

## Option 1: Create a New Token with Full Permissions

1. Go to: https://github.com/settings/tokens
2. Click "Generate new token (classic)"
3. Give it a name: "Book My Venue Setup"
4. Select these scopes:
   - `repo` (full control of private repositories)
   - `workflow` (Actions)
   - `admin:org_hook` (Organization webhooks)
5. Copy the token
6. Run: `gh auth login` and use the new token

## Option 2: Create Issues Via GitHub Web UI (Quickest)

Go to: https://github.com/abhijithoyur/book-my-venue/issues/new

### Create 5 Epics (Copy & Paste):

**EPIC 1: Authentication & User Management**
```
Central epic for user authentication and authorization.

## Goals
- Implement JWT authentication
- Support user roles (customer, owner, admin)
- Enable secure profile management
- Implement session handling

## Acceptance Criteria
- All linked user stories completed
- Security review passed
- JWT implementation tested
- Password requirements enforced
```

**EPIC 2: Venue Management**
```
Epic for venue CRUD operations, search, filtering, and image management.

## Goals
- Enable venue owners to list their venues
- Implement venue search and filtering
- Support image uploads and gallery
- Manage amenities and categories

## Acceptance Criteria
- All linked user stories completed
- Search performance < 500ms
- Image handling robust
- Admin can verify venues
```

**EPIC 3: Booking Management**
```
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
```

**EPIC 4: Availability Management**
```
Epic for managing venue availability and date blocking.

## Goals
- Enable venue owners to set availability
- Support date blocking for maintenance
- Validate availability before booking

## Acceptance Criteria
- All linked stories completed
- Calendar views working
- Availability validation accurate
```

**EPIC 5: Admin Dashboard**
```
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
```

### Create 8 User Stories:

**US-101: User Registration**
```
## Story
As a potential user, I want to create an account with email and password, so that I can book venues.

## Acceptance Criteria
- Can register with email, password, first/last name
- Email validation enforced
- Password meets security requirements
- Duplicate emails rejected
- Confirmation email sent
- User type (customer/owner) selectable

## Story Points: 3
```

**US-102: User Login & JWT Token Management**
```
## Story
As a registered user, I want to login with email/password and receive JWT tokens.

## Acceptance Criteria
- Login with email/password
- Returns access_token (15 min) and refresh_token (7 days)
- Tokens stored securely
- Failed login shows error
- Can refresh before expiry
- Expired token returns 401

## Story Points: 3
```

**US-103: User Profile Management**
```
## Story
As a logged-in user, I want to view and edit my profile information.

## Acceptance Criteria
- View current profile
- Edit: first name, last name, phone, bio
- Upload profile picture
- Changes saved immediately
- Cannot change email or user_type
- Picture validated (format, size)

## Story Points: 2
```

**US-104: Logout & Session Management**
```
## Story
As a logged-in user, I want to logout and clear my session.

## Acceptance Criteria
- Can logout from any page
- Tokens cleared from localStorage
- Redirected to home page
- Expired sessions auto-logout
- Can logout on all devices (optional)

## Story Points: 1
```

**US-201: Venue Owner Registration & Setup**
```
## Story
As a venue owner, I want to register as an owner and set up my profile.

## Acceptance Criteria
- Select 'venue_owner' during registration
- Owner-specific onboarding
- Upload business documents (optional)
- Profile shows 'pending verification'
- View verification timeline

## Story Points: 3
```

**US-202: Create & List Venues**
```
## Story
As a venue owner, I want to create a new venue listing with details and images.

## Acceptance Criteria
- Enter venue details (name, description, address, capacity, price)
- Upload multiple images
- Add amenities from list
- Assign category
- Saved as PENDING verification
- Appears in search only AFTER admin approval

## Story Points: 5
```

**US-203: Search & Filter Venues**
```
## Story
As a customer, I want to search venues by location, capacity, and price.

## Acceptance Criteria
- Filter by city, capacity range, price range, amenities
- Sort by rating, price, recently added
- Results paginated (20 per page)
- Display: image, name, price, capacity, rating
- Search response < 500ms

## Story Points: 3
```

**US-204: View Venue Details**
```
## Story
As a customer, I want to view detailed information about a venue.

## Acceptance Criteria
- Show images, description, amenities, capacity, price, reviews
- Show venue owner contact info
- Show availability calendar
- Show location on map (optional)
- Show reviews and ratings
- Direct booking from details page

## Story Points: 2
```

## Option 3: Using GitHub API Directly

You can also use `curl` to create issues:

```powershell
$headers = @{
    "Authorization" = "Bearer github_pat_11AWL3YBQ0RLirkb87DH9A_..."
    "Accept" = "application/vnd.github+json"
    "X-GitHub-Api-Version" = "2022-11-28"
}

$body = @{
    title = "[EPIC] Authentication & User Management"
    body = "Central epic for user authentication..."
} | ConvertTo-Json

Invoke-WebRequest -Uri "https://api.github.com/repos/abhijithoyur/book-my-venue/issues" `
    -Method POST `
    -Headers $headers `
    -Body $body
```

## Recommended Next Steps

1. **Create a new token** with proper permissions
2. **Run the setup script** with the new token
3. **Create GitHub Project Board** at: https://github.com/abhijithoyur/book-my-venue/projects
4. **Invite team members** to the repository
5. **Start development** with Sprint 1

## Documentation Files Available

All documentation is in the `/docs` folder:
- `01-ARCHITECTURE.md` - System design and modules
- `02-DATABASE-SCHEMA.md` - Database structure
- `03-API-SPECIFICATION.md` - REST API endpoints
- `04-USER-STORIES.md` - All user stories and acceptance criteria
- `05-GITHUB-ISSUES-TEMPLATE.md` - Issue templates and labels
- `06-SPRINT-PLAN.md` - 4-week sprint roadmap

## File Structure

```
book-my-venue/
├── docs/
│   ├── 01-ARCHITECTURE.md
│   ├── 02-DATABASE-SCHEMA.md
│   ├── 03-API-SPECIFICATION.md
│   ├── 04-USER-STORIES.md
│   ├── 05-GITHUB-ISSUES-TEMPLATE.md
│   └── 06-SPRINT-PLAN.md
├── docker-compose.yml
├── .env.example
├── .gitignore
├── README.md
├── CONTRIBUTING.md
├── setup-github-fixed.ps1
├── create-issues.sh
└── GITHUB-SETUP-GUIDE.md
```

## Token Permissions Issue Resolved

The original token had limited scopes. For full functionality:
- ✗ Current token: Read-only access
- ✓ Needed: repo, workflow, admin:org_hook scopes

Create a new PAT with `repo` scope to enable issue/label creation.
