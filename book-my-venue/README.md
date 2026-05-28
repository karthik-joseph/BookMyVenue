# Book My Venue

**Production-grade venue booking platform - MVP**

A comprehensive platform enabling customers to discover and book venues, while venue owners manage their properties and bookings. Includes admin dashboard for moderation and analytics.

---

## 🎯 Quick Start

### For Developers
1. **Understand the system:** Read [docs/01-ARCHITECTURE.md](docs/01-ARCHITECTURE.md)
2. **Review the database:** See [docs/02-DATABASE-SCHEMA.md](docs/02-DATABASE-SCHEMA.md)
3. **Learn the API:** Check [docs/03-API-SPECIFICATION.md](docs/03-API-SPECIFICATION.md)
4. **View workflows:** Explore [docs/05-FLOW-DIAGRAMS.md](docs/05-FLOW-DIAGRAMS.md)
5. **Pick a feature:** Find your issue in [GITHUB-ISSUES-TO-DOCS.md](GITHUB-ISSUES-TO-DOCS.md)
6. **Get technical details:** See [docs/04-USER-STORIES.md](docs/04-USER-STORIES.md) for specs
7. **Start coding:** Follow [HOW-TO-USE-TECHNICAL-DOCS.md](HOW-TO-USE-TECHNICAL-DOCS.md)

### For Project Managers
- 📋 **20 User Stories** across 5 epics (51 story points)
- 📅 **4-sprint roadmap** (8 weeks, MVP complete)
- 👥 **3-person team** recommended
- 📊 **25+ GitHub issues** ready for assignment

---

## 📚 Documentation

### Complete Technical Specifications
| Document | Purpose |
|----------|---------|
| [docs/01-ARCHITECTURE.md](docs/01-ARCHITECTURE.md) | System design, modules, data flows, security |
| [docs/02-DATABASE-SCHEMA.md](docs/02-DATABASE-SCHEMA.md) | 12 tables, relationships, indexes, constraints |
| [docs/03-API-SPECIFICATION.md](docs/03-API-SPECIFICATION.md) | 25+ endpoints with JSON examples |
| [docs/04-USER-STORIES.md](docs/04-USER-STORIES.md) | 20 stories with API specs, DB fields, code paths |
| [docs/05-FLOW-DIAGRAMS.md](docs/05-FLOW-DIAGRAMS.md) | 12 workflow diagrams (customer, owner, admin, API) |
| [docs/07-DETAILED-USER-STORIES-GUIDE.md](docs/07-DETAILED-USER-STORIES-GUIDE.md) | How to write developer-ready stories |
| [docs/08-DETAILED-STORY-EXAMPLE-US101.md](docs/08-DETAILED-STORY-EXAMPLE-US101.md) | Complete example of detailed story |

### Developer Resources
| File | Purpose |
|------|---------|
| [HOW-TO-USE-TECHNICAL-DOCS.md](HOW-TO-USE-TECHNICAL-DOCS.md) | 30-second guide to find technical specs for your issue |
| [GITHUB-ISSUES-TO-DOCS.md](GITHUB-ISSUES-TO-DOCS.md) | Maps all 20 GitHub issues (#7-#28) to documentation |
| [CONTRIBUTING.md](CONTRIBUTING.md) | Contribution guidelines and setup |

---

## 🏗️ Tech Stack

### Backend
- **Framework:** Django 4.2+ with Django REST Framework
- **Database:** PostgreSQL 14+
- **Auth:** djangorestframework-simplejwt (JWT tokens)
- **Cache:** Redis
- **Task Queue:** Celery
- **API:** REST with URL versioning (/api/v1/)

### Frontend
- **Framework:** React 18+ with TypeScript
- **Build Tool:** Vite
- **State:** React Query
- **Forms:** react-hook-form
- **Styling:** TailwindCSS

### Infrastructure
- **Local:** Docker Compose (PostgreSQL, Django, React)
- **Deployment:** Gunicorn + Nginx
- **Storage:** AWS S3 for images
- **CI/CD:** GitHub Actions (ready to implement)

---

## 📦 Project Structure

```
book-my-venue/
├── docs/
│   ├── 01-ARCHITECTURE.md              ← System design
│   ├── 02-DATABASE-SCHEMA.md           ← Database design
│   ├── 03-API-SPECIFICATION.md         ← API reference
│   ├── 04-USER-STORIES.md             ← Technical specs for all 20 stories
│   ├── 05-FLOW-DIAGRAMS.md            ← Workflow diagrams
│   ├── 07-DETAILED-USER-STORIES-GUIDE.md
│   └── 08-DETAILED-STORY-EXAMPLE-US101.md
├── apps/                               ← (To be created)
│   ├── api/                           ← Django backend
│   └── web/                           ← React frontend
├── .github/
│   └── workflows/                     ← CI/CD pipelines
├── docker-compose.yml                 ← Local development
├── .env.example                       ← Environment template
├── HOW-TO-USE-TECHNICAL-DOCS.md      ← Developer workflow guide
├── GITHUB-ISSUES-TO-DOCS.md          ← Issue mapping
├── CONTRIBUTING.md                    ← Contribution guidelines
└── README.md                          ← This file
```

---

## 🎬 Key Features

### For Customers
✅ User registration with email verification  
✅ Browse and search venues with filters  
✅ View detailed venue information  
✅ Submit booking requests  
✅ Manage booking history  
✅ Cancel bookings  
✅ Submit reviews and ratings  

### For Venue Owners
✅ Owner registration and verification  
✅ Create and manage venues  
✅ Set pricing and amenities  
✅ Manage availability and blocked dates  
✅ Review and approve/reject bookings  
✅ View booking history  
✅ Track ratings and reviews  

### For Admins
✅ User management and deactivation  
✅ Venue verification and moderation  
✅ Booking dispute resolution  
✅ System analytics and reporting  
✅ Revenue tracking  
✅ User and venue activity monitoring  

---

## 📊 User Stories (MVP)

### Epic 1: Authentication (4 stories, 13 points)
- US-101: User Registration
- US-102: User Login & JWT Management
- US-103: User Profile Management
- US-104: Logout & Session Management

### Epic 2: Venue Management (5 stories, 16 points)
- US-201: Venue Owner Registration
- US-202: Create & List Venues
- US-203: Search & Filter Venues
- US-204: View Venue Details
- US-205: Edit & Delete Venues
- US-206: Venue Reviews & Ratings

### Epic 3: Booking Management (5 stories, 15 points)
- US-301: Submit Booking Request
- US-302: View Booking History
- US-303: Approve/Reject Bookings
- US-304: Cancel Booking
- US-305: Booking Status Tracking

### Epic 4: Availability Management (3 stories, 4 points)
- US-401: Create Venue Availability Slots
- US-402: Block Dates
- US-403: Check Availability

### Epic 5: Admin Features (3 stories, 3 points)
- US-501: User Management
- US-502: Venue Verification & Moderation
- US-503: Booking Dispute Resolution
- US-504: System Monitoring & Reports

**Total:** 20 stories, 51 story points

---

## 🚀 Development Roadmap

### Sprint 1 (Week 1-2)
- Setup development environment
- User authentication (registration, login, JWT)
- User profile management
- Database setup

### Sprint 2 (Week 3-4)
- Venue management (create, list, search)
- Venue details and images
- Venue reviews and ratings

### Sprint 3 (Week 5-6)
- Booking management (create, approve, cancel)
- Availability management
- Booking history and status tracking

### Sprint 4 (Week 7-8)
- Admin dashboard
- User and venue moderation
- Analytics and reporting
- Testing and bug fixes

---

## 💻 Getting Started (Local Development)

### Prerequisites
- Docker and Docker Compose
- Git

### Setup
```bash
# Clone repository
git clone https://github.com/abhijithoyur/book-my-venue.git
cd book-my-venue

# Copy environment template
cp .env.example .env

# Start development environment
docker-compose up

# Backend runs on: http://localhost:8000
# Frontend runs on: http://localhost:5173
# Database: localhost:5432
```

---

## 📋 GitHub Issues

### How to Get Started
1. **Pick an issue:** Browse [GitHub Issues](https://github.com/abhijithoyur/book-my-venue/issues)
2. **Understand the story:** Reference [HOW-TO-USE-TECHNICAL-DOCS.md](HOW-TO-USE-TECHNICAL-DOCS.md)
3. **Find the specs:** Use [GITHUB-ISSUES-TO-DOCS.md](GITHUB-ISSUES-TO-DOCS.md) to locate documentation
4. **Get the details:** Open [docs/04-USER-STORIES.md](docs/04-USER-STORIES.md) for API specs
5. **Review the flow:** Check [docs/05-FLOW-DIAGRAMS.md](docs/05-FLOW-DIAGRAMS.md) for workflows
6. **Start implementing:** Follow the step-by-step guide in your story

### Issue Categories
- **Epics:** #1-5 (high-level features)
- **User Stories:** #7-28 (implementable features with technical specs)
- **Technical:** Additional task-level issues (coming soon)

---

## 🔑 Key API Endpoints

### Authentication
```
POST   /api/v1/auth/register/
POST   /api/v1/auth/login/
POST   /api/v1/auth/logout/
POST   /api/v1/auth/refresh/
```

### Venues
```
GET    /api/v1/venues/
POST   /api/v1/venues/
GET    /api/v1/venues/{id}/
PATCH  /api/v1/venues/{id}/
DELETE /api/v1/venues/{id}/
GET    /api/v1/venues/{id}/availability/
GET    /api/v1/venues/{id}/reviews/
```

### Bookings
```
GET    /api/v1/bookings/
POST   /api/v1/bookings/
GET    /api/v1/bookings/{id}/
PATCH  /api/v1/bookings/{id}/approve/
PATCH  /api/v1/bookings/{id}/reject/
PATCH  /api/v1/bookings/{id}/cancel/
GET    /api/v1/bookings/{id}/history/
```

### Admin
```
GET    /api/v1/admin/users/
PATCH  /api/v1/admin/users/{id}/deactivate/
GET    /api/v1/admin/venues/pending/
PATCH  /api/v1/admin/venues/{id}/approve/
PATCH  /api/v1/admin/venues/{id}/reject/
GET    /api/v1/admin/disputes/
PATCH  /api/v1/admin/disputes/{id}/resolve/
GET    /api/v1/admin/analytics/
```

---

## 🛠️ Configuration

### Environment Variables
See [.env.example](.env.example) for all 35+ environment variables:
- Database credentials
- Django settings
- JWT configuration
- Email service
- AWS S3 configuration
- Celery and Redis
- Feature flags

---

## 📞 Support

### Documentation
- **Architecture:** [docs/01-ARCHITECTURE.md](docs/01-ARCHITECTURE.md)
- **Database:** [docs/02-DATABASE-SCHEMA.md](docs/02-DATABASE-SCHEMA.md)
- **API Spec:** [docs/03-API-SPECIFICATION.md](docs/03-API-SPECIFICATION.md)
- **Workflows:** [docs/05-FLOW-DIAGRAMS.md](docs/05-FLOW-DIAGRAMS.md)

### Developer Guides
- **How to Start:** [HOW-TO-USE-TECHNICAL-DOCS.md](HOW-TO-USE-TECHNICAL-DOCS.md)
- **Issue Mapping:** [GITHUB-ISSUES-TO-DOCS.md](GITHUB-ISSUES-TO-DOCS.md)
- **Contributing:** [CONTRIBUTING.md](CONTRIBUTING.md)

---

## 📄 License

MIT License - See LICENSE file for details

---

## 👥 Team

**Project:** Book My Venue MVP  
**Status:** Ready for Development  
**Last Updated:** May 25, 2026  

---

## 🎯 What's Next?

1. ✅ **MVP Planning Complete** - All documentation ready
2. ✅ **GitHub Issues Created** - 25 issues ready for assignment
3. ✅ **Technical Specs Written** - All 20 user stories detailed
4. ✅ **Flow Diagrams Ready** - Complete workflow visualization
5. ⏭️ **Assign Issues** - Invite team members
6. ⏭️ **Setup Development Env** - Docker compose ready
7. ⏭️ **Start Sprint 1** - Begin implementation

**Ready to start developing?** Pick an issue from [GitHub Issues](https://github.com/abhijithoyur/book-my-venue/issues) and reference [HOW-TO-USE-TECHNICAL-DOCS.md](HOW-TO-USE-TECHNICAL-DOCS.md)!

---

**Questions?** Check the [docs/](docs/) folder or review [CONTRIBUTING.md](CONTRIBUTING.md).
