# Step-by-Step GitHub Setup Guide

## Prerequisites Check

Before running the setup script, ensure you have:

1. **GitHub Account** - https://github.com (create one if needed)
2. **GitHub CLI** - https://cli.github.com
3. **Authentication** - Run `gh auth login` if not already authenticated

---

## STEP 1: Create GitHub Repository

### Option A: Manual (Web Interface)
1. Go to https://github.com/new
2. **Repository name**: `book-my-venue`
3. **Description**: `Production-grade venue booking platform - MVP`
4. **Visibility**: Public or Private (your choice)
5. **Initialize**: Do NOT initialize with README (we have one)
6. Click **Create Repository**

### Option B: GitHub CLI
```bash
gh repo create book-my-venue --public --source=. --remote=origin --push
```

---

## STEP 2: Push Local Code to GitHub

```bash
# Navigate to project directory
cd C:\Users\SAT-1206\Desktop\projects\Book\ My\ Venue\book-my-venue

# Check git status
git status

# If not initialized
git init

# Add all files
git add .

# Commit
git commit -m "initial: setup project structure and documentation"

# Add remote (replace YOUR-USERNAME)
git remote add origin https://github.com/YOUR-USERNAME/book-my-venue.git

# Rename branch to main (if needed)
git branch -M main

# Push to GitHub
git push -u origin main
```

---

## STEP 3: Run GitHub Setup Script

### Prerequisites for Script

1. **Install GitHub CLI** (if not installed):
   ```bash
   winget install GitHub.cli
   # or download from https://cli.github.com
   ```

2. **Authenticate with GitHub**:
   ```bash
   gh auth login
   # Select: GitHub.com
   # Select: HTTPS
   # Select: Y (Authenticate with your GitHub credentials)
   ```

3. **Verify installation**:
   ```bash
   gh --version
   gh auth status
   ```

### Run the Setup Script

```bash
# Navigate to project
cd C:\Users\SAT-1206\Desktop\projects\Book\ My\ Venue\book-my-venue

# Run the setup script
.\setup-github.ps1

# When prompted, enter your repository URL:
# Example: https://github.com/YOUR-USERNAME/book-my-venue
```

**What the script does:**
- ✅ Creates 4 Milestones (Sprint 1-4)
- ✅ Creates 30+ Labels (type, module, priority, status, skills)
- ✅ Creates 5 Epic Issues
- ✅ Creates 8 User Story Issues
- ✅ Sets up project structure

---

## STEP 4: Create GitHub Project Board (Manual)

After script completes:

1. Go to https://github.com/YOUR-USERNAME/book-my-venue
2. Click **Projects** tab
3. Click **New Project**
4. **Name**: `Book My Venue Development`
5. **Template**: `Table` (or Kanban)
6. Click **Create Project**

### Configure Automation

1. Click **Project settings** (⚙️ icon)
2. Enable **Automation**:
   - Issues opened → Set status to "Backlog"
   - Issues closed → Set status to "Done"
   - Pull requests merged → Set status to "Done"

---

## STEP 5: View Your Setup

After completing all steps, you'll have:

✅ Repository with all documentation  
✅ 4 Milestones (Sprints)  
✅ 30+ Labels for organization  
✅ 5 Epic Issues  
✅ 8 Sample User Stories  
✅ Project board for tracking  

---

## What Gets Created

### Milestones
1. **Sprint 1 - Auth & Foundation** (2 weeks)
2. **Sprint 2 - Venues & Bookings** (2 weeks)
3. **Sprint 3 - Refinement & Admin** (1 week)
4. **Sprint 4 - Testing & Release** (1 week)

### Epics (5 total)
1. [EPIC] Authentication & User Management
2. [EPIC] Venue Management
3. [EPIC] Booking Management
4. [EPIC] Availability Management
5. [EPIC] Admin Dashboard

### User Stories (Sample 8)
- US-101: User Registration
- US-102: User Login & JWT
- US-103: User Profile Management
- US-104: Logout & Session Management
- US-201: Venue Owner Registration
- US-202: Create & List Venues
- US-203: Search & Filter Venues
- US-204: View Venue Details

### Labels (30+)
**Type**: bug, feature, enhancement, task, user-story, epic, documentation, refactor  
**Module**: authentication, venue-management, booking-management, availability-management, admin-dashboard, frontend, backend, database, infrastructure  
**Priority**: P0-Critical, P1-High, P2-Medium, P3-Low  
**Status**: ready, in-progress, in-review, testing, blocked  
**Skills**: django, drf, react, typescript  

---

## Troubleshooting

### GitHub CLI Not Found
```bash
# Install GitHub CLI
winget install GitHub.cli

# Verify installation
gh --version
```

### Not Authenticated
```bash
# Login to GitHub
gh auth login

# Check status
gh auth status
```

### Repository URL Format Error
Use format: `https://github.com/USERNAME/book-my-venue`  
or `https://github.com/USERNAME/book-my-venue.git`

### Label Already Exists
The script will skip labels that already exist. This is fine - they'll be available for use.

### Issue Creation Fails
Ensure:
- Repository URL is correct
- You have permission to create issues
- Repository exists and is accessible

---

## Next Steps After Setup

1. **Review Issues** - Go to GitHub Issues tab
2. **Organize Backlog** - Arrange stories in order of priority
3. **Create Additional Issues** - Add remaining 12+ user stories manually or extend script
4. **Team Communication** - Share repository link with team
5. **Assign Team Members** - Add collaborators and assign issues
6. **Schedule Sprint 1 Planning** - First sprint kickoff meeting

---

## Quick Reference Commands

```bash
# Navigate to project
cd C:\Users\SAT-1206\Desktop\projects\Book\ My\ Venue\book-my-venue

# Check git status
git status

# View all branches
git branch -a

# Check GitHub CLI
gh --version

# Verify authentication
gh auth status

# Run setup script
.\setup-github.ps1

# List all issues
gh issue list --repo YOUR-USERNAME/book-my-venue

# List all milestones
gh milestone list --repo YOUR-USERNAME/book-my-venue
```

---

## Support

If you encounter issues:

1. Check GitHub CLI is installed: `gh --version`
2. Verify authentication: `gh auth status`
3. Check repository URL format
4. Ensure you have internet connectivity
5. Try running script again (idempotent - safe to re-run)
