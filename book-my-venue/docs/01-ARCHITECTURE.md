# Book My Venue - Architecture Documentation

## 1. Product Architecture Overview

### System Components

```
┌─────────────────────────────────────────────────────────────┐
│                     Book My Venue MVP                        │
├─────────────────────────────────────────────────────────────┤
│                                                               │
│  ┌──────────────┐         ┌──────────────┐                 │
│  │   Web App    │         │   Mobile     │                 │
│  │  (React      │         │   (Future)   │                 │
│  │   Vite)      │         │              │                 │
│  └──────┬───────┘         └──────────────┘                 │
│         │                                                   │
│         │       HTTP/HTTPS with JWT                        │
│         └──────────────────┬─────────────────────┐         │
│                            │                     │         │
│                    ┌───────▼────────┐             │         │
│                    │  API Gateway   │             │         │
│                    │  (Django DRF)  │             │         │
│                    │  Port: 8000    │             │         │
│                    └───────┬────────┘             │         │
│                            │                     │         │
│         ┌──────────────────┼──────────────────┐  │         │
│         │                  │                  │  │         │
│    ┌────▼─────┐   ┌────────▼────────┐  ┌────▼──┴─┐       │
│    │   Auth   │   │  Core Business  │  │  Admin  │       │
│    │ Module   │   │   Modules       │  │ Module  │       │
│    │          │   │                 │  │         │       │
│    │ - Users  │   │ - Venues        │  │ - Users │       │
│    │ - JWT    │   │ - Bookings      │  │ - Audit │       │
│    │ - Roles  │   │ - Availability  │  │ - Logs  │       │
│    └────┬─────┘   └────────┬────────┘  └────┬───┘       │
│         │                  │                 │           │
│         └──────────────────┼────────────────┘           │
│                            │                            │
│                    ┌───────▼──────────┐                 │
│                    │  PostgreSQL DB   │                 │
│                    │  (Dockerized)    │                 │
│                    └──────────────────┘                 │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

---

## 2. Module Breakdown

### Backend Modules

#### **Authentication Module**
- **Responsibility**: User authentication, authorization, JWT token management
- **Key Services**:
  - User registration/login
  - JWT token generation and validation
  - Role-based access control (RBAC)
  - Password reset
- **Database Entities**: `User`, `UserRole`
- **API Endpoints**: `/api/v1/auth/register`, `/api/v1/auth/login`, `/api/v1/auth/refresh`

#### **Venue Management Module**
- **Responsibility**: Venue CRUD operations, search, filters
- **Key Services**:
  - Create/update/delete venues
  - Venue search and filtering
  - Venue images management
  - Amenities management
- **Database Entities**: `Venue`, `VenueAmenity`, `VenueImage`, `VenueCategory`
- **API Endpoints**: `/api/v1/venues/`, `/api/v1/venues/{id}/`

#### **Booking Management Module**
- **Responsibility**: Booking lifecycle management (PENDING → APPROVED/REJECTED → COMPLETED/CANCELLED)
- **Key Services**:
  - Create booking requests
  - Approve/reject bookings
  - Cancel bookings
  - Booking history
- **Database Entities**: `Booking`, `BookingHistory`
- **API Endpoints**: `/api/v1/bookings/`, `/api/v1/bookings/{id}/approve/`, `/api/v1/bookings/{id}/reject/`

#### **Availability Management Module**
- **Responsibility**: Manage venue availability (full-day slots for MVP)
- **Key Services**:
  - Create availability slots
  - Check availability
  - Block dates
- **Database Entities**: `Availability`, `BlockedDate`
- **API Endpoints**: `/api/v1/venues/{id}/availability/`, `/api/v1/venues/{id}/availability/check/`

#### **Admin Module**
- **Responsibility**: System administration, moderation, monitoring
- **Key Services**:
  - User management
  - Venue moderation
  - Booking reports
  - System logs
- **Database Entities**: Uses all above tables
- **API Endpoints**: `/api/v1/admin/users/`, `/api/v1/admin/venues/`, `/api/v1/admin/bookings/`

---

## 3. Backend Architecture

### Technology Stack
- **Framework**: Django 4.2+
- **API**: Django REST Framework
- **Database**: PostgreSQL 14+
- **Authentication**: JWT (djangorestframework-simplejwt)
- **Task Queue**: Celery (for future notifications)
- **Caching**: Redis (for future optimization)

### Directory Structure
```
apps/api/
├── manage.py
├── requirements.txt
├── Dockerfile
├── docker-compose.yml
├── config/
│   ├── settings/
│   │   ├── base.py
│   │   ├── dev.py
│   │   ├── prod.py
│   │   └── test.py
│   ├── urls.py
│   └── wsgi.py
├── apps/
│   ├── auth/
│   │   ├── models.py
│   │   ├── views.py
│   │   ├── serializers.py
│   │   ├── urls.py
│   │   └── tests.py
│   ├── venues/
│   │   ├── models.py
│   │   ├── views.py
│   │   ├── serializers.py
│   │   ├── urls.py
│   │   └── tests.py
│   ├── bookings/
│   │   ├── models.py
│   │   ├── views.py
│   │   ├── serializers.py
│   │   ├── urls.py
│   │   └── tests.py
│   ├── availability/
│   │   ├── models.py
│   │   ├── views.py
│   │   ├── serializers.py
│   │   ├── urls.py
│   │   └── tests.py
│   └── admin/
│       ├── models.py
│       ├── views.py
│       ├── serializers.py
│       ├── urls.py
│       └── tests.py
├── shared/
│   ├── permissions.py
│   ├── pagination.py
│   ├── exceptions.py
│   ├── utils.py
│   └── validators.py
└── tests/
    └── conftest.py
```

### Service Layer Pattern
```
View/Serializer
    ↓
Service Layer (business logic)
    ↓
Model/Repository Layer
    ↓
Database
```

---

## 4. Frontend Architecture

### Technology Stack
- **Framework**: React 18+
- **Build Tool**: Vite
- **Language**: TypeScript
- **Styling**: TailwindCSS
- **State Management**: React Query (server state)
- **HTTP Client**: Axios
- **Routing**: React Router v6
- **UI Components**: Custom + shadcn/ui

### Directory Structure
```
apps/web/
├── public/
├── src/
│   ├── index.tsx
│   ├── App.tsx
│   ├── main.tsx
│   ├── types/
│   │   ├── auth.ts
│   │   ├── venue.ts
│   │   ├── booking.ts
│   │   └── api.ts
│   ├── api/
│   │   ├── client.ts
│   │   ├── auth.ts
│   │   ├── venues.ts
│   │   ├── bookings.ts
│   │   └── availability.ts
│   ├── hooks/
│   │   ├── useAuth.ts
│   │   ├── useVenues.ts
│   │   ├── useBookings.ts
│   │   └── useVenueAvailability.ts
│   ├── stores/
│   │   ├── authStore.ts
│   │   └── userStore.ts
│   ├── components/
│   │   ├── common/
│   │   │   ├── Header.tsx
│   │   │   ├── Sidebar.tsx
│   │   │   ├── LoadingSpinner.tsx
│   │   │   └── ErrorBoundary.tsx
│   │   ├── auth/
│   │   │   ├── LoginForm.tsx
│   │   │   ├── RegisterForm.tsx
│   │   │   └── ProtectedRoute.tsx
│   │   ├── venues/
│   │   │   ├── VenueCard.tsx
│   │   │   ├── VenueList.tsx
│   │   │   ├── VenueDetails.tsx
│   │   │   └── VenueForm.tsx
│   │   ├── bookings/
│   │   │   ├── BookingForm.tsx
│   │   │   ├── BookingList.tsx
│   │   │   ├── BookingStatus.tsx
│   │   │   └── BookingHistory.tsx
│   │   └── admin/
│   │       ├── AdminDashboard.tsx
│   │       ├── UserManagement.tsx
│   │       └── VenueModerationPanel.tsx
│   ├── pages/
│   │   ├── Home.tsx
│   │   ├── Login.tsx
│   │   ├── Register.tsx
│   │   ├── VenueListing.tsx
│   │   ├── VenueDetail.tsx
│   │   ├── BookingRequest.tsx
│   │   ├── Dashboard/
│   │   │   ├── UserDashboard.tsx
│   │   │   ├── OwnerDashboard.tsx
│   │   │   └── AdminDashboard.tsx
│   │   └── NotFound.tsx
│   ├── utils/
│   │   ├── axios.ts
│   │   ├── localStorage.ts
│   │   ├── formatters.ts
│   │   └── validators.ts
│   ├── styles/
│   │   └── globals.css
│   └── config/
│       └── constants.ts
├── vite.config.ts
├── tsconfig.json
├── tailwind.config.js
├── postcss.config.js
└── package.json
```

### Feature-Based Organization
- **pages/**: Route-level components
- **components/**: Reusable UI components by feature
- **hooks/**: Custom React hooks
- **api/**: API client functions
- **types/**: TypeScript type definitions
- **utils/**: Helper functions

---

## 5. Infrastructure Architecture

### Docker Compose Setup
```yaml
Services:
  - PostgreSQL (db)
  - Django API (api)
  - React Frontend (web)
  - Nginx (reverse proxy) - future
```

### Environment Separation
- **Development**: docker-compose.yml (local development)
- **Testing**: docker-compose.test.yml (CI/CD)
- **Production**: Kubernetes-ready (future)

### CI/CD Pipeline (GitHub Actions)
```
Code Push
  ↓
Lint & Format Check
  ↓
Run Tests (Backend + Frontend)
  ↓
Build Docker Images
  ↓
Deploy to Staging (if main branch)
  ↓
Deploy to Production (on release tag)
```

---

## 6. Scalability Considerations

### Phase 1 MVP (Current)
- Single monorepo
- Shared database
- JWT authentication
- In-process task handling

### Phase 2 (Scalability)
- API service separation
- Celery for async tasks
- Redis caching
- Message queue (RabbitMQ)
- Load balancing

### Phase 3 (Advanced)
- Microservices (if needed)
- Database sharding
- Event-driven architecture
- Multi-region deployment

---

## 7. Data Flow

### Booking Flow
```
User Submits Booking Request
  ↓
API Validates Request
  ↓
Create Booking (PENDING status)
  ↓
Notify Venue Owner
  ↓
Owner Reviews → Approve/Reject
  ↓
Update Booking Status
  ↓
Notify User
  ↓
User Sees Updated Status
```

### Authentication Flow
```
User Registers/Logs In
  ↓
API Validates Credentials
  ↓
Generate JWT Token Pair (access + refresh)
  ↓
Return Tokens to Client
  ↓
Client Stores Tokens in localStorage
  ↓
Client Includes Token in API Requests
  ↓
API Validates Token
  ↓
Grant/Deny Access
```

---

## 8. API Versioning Strategy

- **Current Version**: `/api/v1/`
- **Versioning Approach**: URL-based versioning
- **Backward Compatibility**: Maintain at least 1 version back
- **Deprecation Policy**: 6-month notice before removing old versions

---

## 9. Security Considerations

- ✅ JWT authentication with expiration
- ✅ HTTPS enforcement (production)
- ✅ CORS configuration (frontend origin)
- ✅ CSRF protection (Django middleware)
- ✅ Role-based access control (RBAC)
- ✅ Input validation on all endpoints
- ✅ Rate limiting on auth endpoints
- ✅ Password hashing (bcrypt)
- ✅ Environment variables for secrets
- ✅ SQL injection prevention (ORM)

---

## 10. Deployment Architecture

### Development
```
Local Docker Compose
├── PostgreSQL
├── Django Dev Server
└── React Dev Server (Vite)
```

### Production (Future)
```
Cloud Provider (AWS/GCP/Azure)
├── Load Balancer
├── Django API Cluster (Gunicorn + Nginx)
├── React Static Site (CloudFront/CDN)
├── RDS (PostgreSQL)
└── S3/Blob Storage (Images)
```

---

## Summary

This architecture is:
- ✅ **Modular**: Clean separation of concerns
- ✅ **Scalable**: Ready for horizontal scaling in Phase 2
- ✅ **Maintainable**: Clear patterns and organization
- ✅ **Production-Grade**: Security, logging, error handling
- ✅ **Testable**: Isolated layers for unit/integration tests
- ✅ **Future-Proof**: Can evolve without major rewrites
