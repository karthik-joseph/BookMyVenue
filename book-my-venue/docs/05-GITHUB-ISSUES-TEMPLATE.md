# GitHub Issues Template & Import Guide

This document provides templates and instructions for creating GitHub issues for the Book My Venue project.

---

## How to Use These Templates

### Option 1: Create Issues Manually (Recommended for Planning)
1. Go to your GitHub repository
2. Click **Issues** tab
3. Click **New Issue**
4. Use the templates below
5. Assign labels, milestone, and assignee

### Option 2: Use GitHub Issue Forms (Built-in)
Create `.github/ISSUE_TEMPLATE/` directory with template files (see examples below)

### Option 3: GitHub CLI
```bash
gh issue create --title "US-101: User Registration" \
  --body "..." \
  --label "feature,backend" \
  --milestone "Sprint 1"
```

---

## Issue Templates

### Epic Issue Template

```markdown
# [EPIC] Authentication & User Management

## Description
Central epic for all authentication-related features including user registration, login, token management, and profile management.

## Goals
- Implement JWT-based authentication
- Support user roles (customer, owner, admin)
- Enable profile management
- Secure session handling

## User Types Affected
- All users

## Acceptance Criteria
- [ ] All linked user stories are completed
- [ ] Security review passed
- [ ] API documentation updated

## Related Issues
- Links to all child user stories

## Labels
- `epic`, `authentication`, `backend`

## Milestone
Sprint 1

---
```

### User Story Template

```markdown
# US-101: User Registration

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

## Implementation Tasks
See linked tasks below

## Story Points
3

## Priority
P0 (Critical)

## Labels
- `user-story`, `authentication`, `feature`, `backend`, `frontend`

## Linked Tasks
- Task 1: Backend - Create User model and serializer
- Task 2: Backend - Implement registration endpoint with validation
- Task 3: Frontend - Create registration form with validation

## Related Issues
- Parent Epic: [EPIC] Authentication & User Management

---
```

### Task/Technical Issue Template

```markdown
# [TASK] Backend - Create User Model and Serializer (US-101)

## Description
Create Django User model with all required fields and DRF serializer for registration and profile endpoints.

## Related User Story
US-101: User Registration

## Requirements
- User model with fields: username, email, password_hash, first_name, last_name, phone_number, user_type, etc.
- UUID primary key
- Timestamps (created_at, updated_at)
- Validation: email uniqueness, password strength
- DRF UserSerializer for registration and profile
- Password hashing using Django's built-in utilities

## Definition of Done
- [ ] Model created with all fields
- [ ] Serializer implemented with validation
- [ ] Tests written (model and serializer)
- [ ] Database migration created
- [ ] Code review approved
- [ ] Documentation updated

## Implementation Notes
- Use Django's AbstractBaseUser for custom user model
- Password validation in serializer
- Use Django signals for post-save actions

## Acceptance Criteria
- [ ] Model can be instantiated with required fields
- [ ] Serializer validates email format
- [ ] Serializer validates password strength
- [ ] Duplicate emails raise validation error
- [ ] Tests achieve 90%+ coverage

## Labels
- `task`, `backend`, `django`, `database`

## Story Points
3

## Assigned To
[Developer Name]

## Due Date
[Sprint 1 end date]

---
```

### Bug Report Template

```markdown
# [BUG] Booking Status Not Updating After Owner Approval

## Description
When a venue owner approves a booking, the status doesn't update on the customer's dashboard immediately.

## Steps to Reproduce
1. Customer submits booking request
2. Venue owner approves booking
3. Customer refreshes dashboard
4. Status shows as PENDING instead of APPROVED

## Expected Behavior
Booking status should immediately update to APPROVED after owner approval

## Actual Behavior
Booking status remains PENDING until page refresh

## Environment
- Browser: Chrome 90
- Backend: Django 4.2
- Frontend: React 18

## Severity
High

## Labels
- `bug`, `booking-management`, `high-priority`

## Related Issues
- Parent Epic: Booking Management

---
```

---

## Issue Labels Guide

### By Type
- `bug` - Bug report
- `feature` - New feature request
- `enhancement` - Improvement to existing feature
- `task` - Implementation task
- `user-story` - User story (from product spec)
- `epic` - Epic (parent of multiple stories)
- `documentation` - Documentation update
- `refactor` - Code refactoring

### By Module
- `authentication` - Auth & user management
- `venue-management` - Venue CRUD
- `booking-management` - Bookings
- `availability-management` - Availability
- `admin` - Admin features
- `frontend` - React/Vite
- `backend` - Django/DRF
- `database` - Database schema
- `infrastructure` - DevOps/Docker

### By Priority
- `P0` - Critical (blocks release)
- `P1` - High (should do)
- `P2` - Medium (nice to have)
- `P3` - Low (future consideration)

### By Status
- `backlog` - In backlog
- `ready` - Ready to start
- `in-progress` - Currently being worked on
- `in-review` - Waiting for code review
- `testing` - QA testing
- `blocked` - Blocked by another issue
- `done` - Completed

### By Skill
- `django` - Django-specific
- `drf` - Django REST Framework
- `react` - React-specific
- `typescript` - TypeScript
- `database` - Database/SQL
- `devops` - DevOps/Docker

---

## Milestone Structure

### Sprint 1: Authentication & Core Setup
- **Duration**: Week 1-2
- **Goals**: Auth system, base API, frontend setup
- **Stories**: US-101, US-102, US-103, US-104, US-201

### Sprint 2: Venue & Booking Management
- **Duration**: Week 3-4
- **Goals**: Venue CRUD, booking submission, availability
- **Stories**: US-202, US-203, US-204, US-205, US-301, US-302, US-303, US-401, US-402, US-403

### Sprint 3: Refinement & Polish
- **Duration**: Week 5
- **Goals**: Reviews, cancellation, vendor dashboard
- **Stories**: US-206, US-304, US-502

### Sprint 4: Admin & Testing
- **Duration**: Week 6
- **Goals**: Admin features, comprehensive testing
- **Stories**: US-501, US-503, US-504

---

## Issue Linking

### Link Issues
Use GitHub's linking syntax:
```markdown
Closes #123
Fixes #456
Related to #789
Depends on #101
```

### Create Relationships
- Use "Linked issues" section in issue details
- Parent/child relationships for epics and stories
- Related issues for cross-cutting concerns

---

## Example Issues to Create

### EPIC Issues

1. [EPIC] Authentication & User Management
2. [EPIC] Venue Management
3. [EPIC] Booking Management
4. [EPIC] Availability Management
5. [EPIC] Admin Dashboard

### Sprint 1 Stories

1. US-101: User Registration → Link 5 backend/frontend tasks
2. US-102: User Login & JWT → Link 5 backend/frontend tasks
3. US-103: User Profile Management → Link 3 backend/frontend tasks
4. US-104: Logout & Session → Link 2 backend/frontend tasks
5. US-201: Venue Owner Registration → Link 2 backend/frontend tasks

### Total for Sprint 1: 5 Epics + 5 Stories + ~25 Tasks = 35 issues

---

## Creating Issues in Bulk (Using GitHub CLI)

```bash
# First install GitHub CLI: https://cli.github.com

# Create Epic
gh issue create --title "[EPIC] Authentication & User Management" \
  --body "$(cat << 'EOF'
## Description
Central epic for all authentication-related features

## Goals
- Implement JWT-based authentication
- Support user roles (customer, owner, admin)
EOF
)" \
  --label "epic,authentication" \
  --milestone "Sprint 1"

# Create User Story
gh issue create --title "US-101: User Registration" \
  --body "$(cat << 'EOF'
## Story
**As a** potential user
**I want to** create an account
**So that** I can book venues

## Acceptance Criteria
- User can sign up
- Email validation works
- Password is secure
EOF
)" \
  --label "user-story,feature" \
  --milestone "Sprint 1"
```

---

## Issue Workflow

```
┌─────────────────┐
│    Backlog      │
│  (Not Started)  │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Ready (Open)   │
│  (Prioritized)  │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  In Progress    │
│ (Assigned, WIP) │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  In Review      │
│  (PR Created)   │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Testing/QA     │
│  (Test Ready)   │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│    Closed       │
│    (Done/PR)    │
└─────────────────┘
```

---

## Best Practices

### Issue Titles
✅ Good:
- `[EPIC] Authentication & User Management`
- `US-101: User Registration`
- `[TASK] Backend - Create User Model`
- `[BUG] Booking status not updating`

❌ Avoid:
- `Fix auth`
- `Feature`
- `Task 1`

### Issue Description
✅ Good:
- Clear context
- Linked user story
- Acceptance criteria
- Implementation notes
- Related issues

❌ Avoid:
- Too vague
- No criteria
- No links
- Too long (use Details toggle)

### Labels
✅ Good:
- 3-5 labels per issue
- Consistent naming
- Type + Module + Priority

❌ Avoid:
- Too many labels
- Inconsistent naming
- Redundant labels

---

## Next Steps

1. **Create Milestones** (Sprints 1-4)
2. **Create Epic Issues** (5 total)
3. **Create Story Issues** (20-25 stories)
4. **Create Task Issues** (50-70 tasks)
5. **Assign Labels** to all issues
6. **Link Issues** (parent/child, related)
7. **Set Priorities** and order in backlog
8. **Assign to Sprint** milestones
9. **Start Sprint 1** planning meeting
10. **Assign developers** to first sprint tasks

---

## GitHub Project Board Setup

1. Go to Projects tab
2. Create new project: "Book My Venue - Development"
3. Use automation:
   - Issues added → In Backlog
   - PR linked → In Progress
   - PR merged → Done
4. Configure columns:
   - Backlog
   - Ready
   - In Progress
   - In Review
   - Testing
   - Done

---

## Example: Creating First Issue

```bash
# Clone the structure locally first
git clone <your-repo>
cd book-my-venue

# Create and switch to dev branch
git checkout -b feature/setup

# Add issue template
mkdir -p .github/ISSUE_TEMPLATE

# Create issue template file
cat > .github/ISSUE_TEMPLATE/user-story.md << 'EOF'
---
name: User Story
about: Create a new user story
title: 'US-XXX: [Story Title]'
labels: 'user-story'
---

## Story
**As a** [user type]
**I want to** [action]
**So that** [benefit]

## Acceptance Criteria
- [ ] Criterion 1
- [ ] Criterion 2

## Story Points
[1-13]

## Labels
- user-story
- [module]
- [priority]
EOF

# Commit and push
git add .github/
git commit -m "Add issue templates"
git push origin feature/setup

# Create PR and merge
```

This standardizes issue creation for your team!
