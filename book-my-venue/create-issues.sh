#!/bin/bash
# GitHub Issues Creation Script

REPO="abhijithoyur/book-my-venue"

# Create Labels
echo "Creating labels..."
gh label create --repo $REPO --name "epic" --color "4a235a" --description "Epic issue" 2>/dev/null
gh label create --repo $REPO --name "user-story" --color "7057ff" --description "User story" 2>/dev/null
gh label create --repo $REPO --name "task" --color "cccccc" --description "Implementation task" 2>/dev/null
gh label create --repo $REPO --name "bug" --color "d73a49" --description "Bug report" 2>/dev/null
gh label create --repo $REPO --name "feature" --color "28a745" --description "New feature" 2>/dev/null

gh label create --repo $REPO --name "authentication" --color "1f77b4" --description "Authentication module" 2>/dev/null
gh label create --repo $REPO --name "venue-management" --color "2ca02c" --description "Venue management" 2>/dev/null
gh label create --repo $REPO --name "booking-management" --color "d62728" --description "Booking management" 2>/dev/null
gh label create --repo $REPO --name "backend" --color "4b0082" --description "Backend" 2>/dev/null
gh label create --repo $REPO --name "frontend" --color "20b2aa" --description "Frontend" 2>/dev/null

gh label create --repo $REPO --name "P0-Critical" --color "b60205" --description "Critical priority" 2>/dev/null
gh label create --repo $REPO --name "P1-High" --color "ff6600" --description "High priority" 2>/dev/null
gh label create --repo $REPO --name "P2-Medium" --color "ffff00" --description "Medium priority" 2>/dev/null

echo "✓ Labels created"

# Create Epic Issues
echo "Creating epic issues..."

gh issue create --repo $REPO \
  --title "[EPIC] Authentication & User Management" \
  --body "## Description\nCentral epic for user authentication and authorization.\n\n## Goals\n- Implement JWT authentication\n- Support user roles\n- Enable profile management\n\n## Acceptance Criteria\n- All linked stories completed\n- Security review passed" \
  --label "epic,authentication,backend"

gh issue create --repo $REPO \
  --title "[EPIC] Venue Management" \
  --body "## Description\nEpic for venue CRUD and search functionality.\n\n## Goals\n- Enable venue creation\n- Implement search and filtering\n- Support image uploads\n\n## Acceptance Criteria\n- All linked stories completed" \
  --label "epic,venue-management,backend,frontend"

gh issue create --repo $REPO \
  --title "[EPIC] Booking Management" \
  --body "## Description\nEpic for booking submission and approval workflow.\n\n## Goals\n- Enable booking requests\n- Implement approval workflow\n- Track booking status\n\n## Acceptance Criteria\n- Workflow operational\n- No double-booking" \
  --label "epic,booking-management,backend,frontend"

gh issue create --repo $REPO \
  --title "[EPIC] Availability Management" \
  --body "## Description\nEpic for managing venue availability.\n\n## Goals\n- Set availability slots\n- Support date blocking\n- Validate availability\n\n## Acceptance Criteria\n- All linked stories completed" \
  --label "epic,availability-management,backend,frontend"

gh issue create --repo $REPO \
  --title "[EPIC] Admin Dashboard" \
  --body "## Description\nEpic for admin features and monitoring.\n\n## Goals\n- User management\n- Venue verification\n- Analytics and monitoring\n\n## Acceptance Criteria\n- Admin can moderate venues" \
  --label "epic,admin-dashboard,backend,frontend"

echo "✓ Epics created"

# Create Sample User Stories
echo "Creating user stories..."

gh issue create --repo $REPO \
  --title "US-101: User Registration" \
  --body "## Story\nAs a user, I want to sign up with email/password to create an account.\n\n## Acceptance Criteria\n- Can register with email, password, name\n- Email validation enforced\n- Password meets security requirements\n- Confirmation email sent\n\n## Story Points: 3" \
  --label "user-story,authentication,feature,backend,frontend,P0-Critical"

gh issue create --repo $REPO \
  --title "US-102: User Login & JWT Token Management" \
  --body "## Story\nAs a user, I want to login and receive JWT tokens for authentication.\n\n## Acceptance Criteria\n- Email/password login\n- Returns access and refresh tokens\n- Tokens expire appropriately\n- Failed login shows error\n\n## Story Points: 3" \
  --label "user-story,authentication,feature,backend,frontend,P0-Critical"

gh issue create --repo $REPO \
  --title "US-103: User Profile Management" \
  --body "## Story\nAs a logged-in user, I can view and edit my profile.\n\n## Acceptance Criteria\n- View current profile\n- Edit name, phone, bio\n- Upload profile picture\n- Changes saved immediately\n\n## Story Points: 2" \
  --label "user-story,authentication,feature,backend,frontend,P1-High"

gh issue create --repo $REPO \
  --title "US-202: Create & List Venues" \
  --body "## Story\nAs a venue owner, I can create venues with details and images.\n\n## Acceptance Criteria\n- Enter venue details\n- Upload images\n- Add amenities\n- Assign category\n- Venue pending verification\n\n## Story Points: 5" \
  --label "user-story,venue-management,feature,backend,frontend,P0-Critical"

gh issue create --repo $REPO \
  --title "US-203: Search & Filter Venues" \
  --body "## Story\nAs a customer, I can search and filter venues.\n\n## Acceptance Criteria\n- Filter by city, capacity, price\n- Sort results\n- Paginated results\n- Fast search response\n\n## Story Points: 3" \
  --label "user-story,venue-management,feature,backend,frontend,P0-Critical"

echo "✓ User stories created"
echo ""
echo "=========================================="
echo "✓ GitHub setup complete!"
echo "=========================================="
echo ""
echo "Next steps:"
echo "1. Visit: https://github.com/abhijithoyur/book-my-venue"
echo "2. View Issues tab to see all created issues"
echo "3. Create GitHub Project Board"
echo "4. Assign team members"
echo "5. Begin development!"
echo ""
