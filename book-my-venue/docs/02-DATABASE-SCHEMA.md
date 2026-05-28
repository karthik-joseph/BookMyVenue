# Database Schema Design

## Overview

```
┌──────────────┐       ┌──────────────┐
│    User      │───┐   │  UserRole    │
└──────────────┘   │   └──────────────┘
       │           └──→ (Links User to Role)
       │
       │   ┌──────────────────────────────────────┐
       │   │                                      │
       ▼   ▼                                      ▼
  ┌──────────────┐                        ┌──────────────┐
  │    Venue     │◄────────────┐          │   Booking    │
  └──────────────┘             │          └──────────────┘
       │                       │                  │
       ├─► VenueAmenity        │                  ├─► BookingHistory
       ├─► VenueImage          │                  │
       ├─► VenueCategory       │                  └─► Notification
       ├─► Availability        │
       │                       └─ venue_owner_id
       │
       ▼
  ┌──────────────┐
  │ Availability │
  └──────────────┘
```

---

## Table Definitions

### 1. Users

**Purpose**: Store user information for customers, venue owners, and admins

```sql
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    username VARCHAR(150) UNIQUE NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    phone_number VARCHAR(20),
    profile_picture_url TEXT,
    bio TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    is_email_verified BOOLEAN DEFAULT FALSE,
    email_verified_at TIMESTAMP WITH TIME ZONE,
    user_type VARCHAR(20) NOT NULL, -- 'customer', 'owner', 'admin'
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    last_login TIMESTAMP WITH TIME ZONE,
    CONSTRAINT valid_user_type CHECK (user_type IN ('customer', 'owner', 'admin'))
);

CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_username ON users(username);
CREATE INDEX idx_users_user_type ON users(user_type);
```

### 2. UserRoles

**Purpose**: Define user roles and permissions

```sql
CREATE TABLE user_roles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    role VARCHAR(50) NOT NULL,
    assigned_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    assigned_by UUID REFERENCES users(id),
    CONSTRAINT valid_role CHECK (role IN ('customer', 'venue_owner', 'admin', 'moderator')),
    UNIQUE(user_id, role)
);

CREATE INDEX idx_user_roles_user_id ON user_roles(user_id);
CREATE INDEX idx_user_roles_role ON user_roles(role);
```

### 3. Venues

**Purpose**: Store venue information

```sql
CREATE TABLE venues (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    owner_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    address VARCHAR(500) NOT NULL,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100),
    postal_code VARCHAR(20),
    country VARCHAR(100) DEFAULT 'India',
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8),
    phone_number VARCHAR(20),
    email VARCHAR(255),
    capacity INTEGER NOT NULL,
    price_per_day DECIMAL(10, 2) NOT NULL,
    category_id UUID REFERENCES venue_categories(id),
    is_verified BOOLEAN DEFAULT FALSE,
    verification_status VARCHAR(50) DEFAULT 'pending', -- 'pending', 'approved', 'rejected'
    is_active BOOLEAN DEFAULT TRUE,
    total_bookings INTEGER DEFAULT 0,
    average_rating DECIMAL(3, 2) DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    CONSTRAINT valid_capacity CHECK (capacity > 0),
    CONSTRAINT valid_price CHECK (price_per_day > 0)
);

CREATE INDEX idx_venues_owner_id ON venues(owner_id);
CREATE INDEX idx_venues_city ON venues(city);
CREATE INDEX idx_venues_verification_status ON venues(verification_status);
CREATE INDEX idx_venues_created_at ON venues(created_at);
CREATE INDEX idx_venues_location ON venues(latitude, longitude);
```

### 4. VenueCategories

**Purpose**: Categorize venues (e.g., banquet hall, conference room, wedding venue)

```sql
CREATE TABLE venue_categories (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) UNIQUE NOT NULL,
    description TEXT,
    icon_url TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_venue_categories_name ON venue_categories(name);
```

### 5. VenueAmenities

**Purpose**: Store amenities offered by venues (AC, WiFi, Parking, etc.)

```sql
CREATE TABLE venue_amenities (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    venue_id UUID NOT NULL REFERENCES venues(id) ON DELETE CASCADE,
    amenity_name VARCHAR(100) NOT NULL,
    amenity_icon_url TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(venue_id, amenity_name)
);

CREATE INDEX idx_venue_amenities_venue_id ON venue_amenities(venue_id);
```

### 6. VenueImages

**Purpose**: Store multiple images for venues

```sql
CREATE TABLE venue_images (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    venue_id UUID NOT NULL REFERENCES venues(id) ON DELETE CASCADE,
    image_url TEXT NOT NULL,
    alt_text VARCHAR(255),
    is_primary BOOLEAN DEFAULT FALSE,
    display_order INTEGER DEFAULT 0,
    uploaded_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(venue_id, is_primary)
);

CREATE INDEX idx_venue_images_venue_id ON venue_images(venue_id);
```

### 7. Availability

**Purpose**: Store availability slots (full-day for MVP)

```sql
CREATE TABLE availability (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    venue_id UUID NOT NULL REFERENCES venues(id) ON DELETE CASCADE,
    available_date DATE NOT NULL,
    status VARCHAR(50) DEFAULT 'available', -- 'available', 'booked', 'blocked'
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(venue_id, available_date),
    CONSTRAINT valid_date CHECK (available_date >= CURRENT_DATE)
);

CREATE INDEX idx_availability_venue_id ON availability(venue_id);
CREATE INDEX idx_availability_date ON availability(available_date);
CREATE INDEX idx_availability_status ON availability(status);
CREATE INDEX idx_availability_venue_date ON availability(venue_id, available_date);
```

### 8. BlockedDates

**Purpose**: Store manually blocked dates (maintenance, special events, etc.)

```sql
CREATE TABLE blocked_dates (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    venue_id UUID NOT NULL REFERENCES venues(id) ON DELETE CASCADE,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    reason VARCHAR(255),
    created_by UUID NOT NULL REFERENCES users(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    CONSTRAINT valid_date_range CHECK (end_date >= start_date)
);

CREATE INDEX idx_blocked_dates_venue_id ON blocked_dates(venue_id);
CREATE INDEX idx_blocked_dates_date_range ON blocked_dates(start_date, end_date);
```

### 9. Bookings

**Purpose**: Store booking requests and their lifecycle

```sql
CREATE TABLE bookings (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    customer_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    venue_id UUID NOT NULL REFERENCES venues(id) ON DELETE CASCADE,
    booking_date DATE NOT NULL,
    number_of_guests INTEGER NOT NULL,
    total_price DECIMAL(10, 2) NOT NULL,
    status VARCHAR(50) NOT NULL DEFAULT 'pending', -- 'pending', 'approved', 'rejected', 'cancelled', 'completed'
    rejection_reason TEXT,
    cancellation_reason TEXT,
    cancelled_by VARCHAR(50), -- 'customer', 'owner', 'admin'
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    approved_at TIMESTAMP WITH TIME ZONE,
    completed_at TIMESTAMP WITH TIME ZONE,
    CONSTRAINT valid_guests CHECK (number_of_guests > 0),
    CONSTRAINT valid_price CHECK (total_price > 0),
    CONSTRAINT valid_status CHECK (status IN ('pending', 'approved', 'rejected', 'cancelled', 'completed'))
);

CREATE INDEX idx_bookings_customer_id ON bookings(customer_id);
CREATE INDEX idx_bookings_venue_id ON bookings(venue_id);
CREATE INDEX idx_bookings_status ON bookings(status);
CREATE INDEX idx_bookings_booking_date ON bookings(booking_date);
CREATE INDEX idx_bookings_created_at ON bookings(created_at);
CREATE INDEX idx_bookings_customer_status ON bookings(customer_id, status);
CREATE INDEX idx_bookings_venue_status ON bookings(venue_id, status);
```

### 10. BookingHistory

**Purpose**: Audit trail for booking status changes

```sql
CREATE TABLE booking_history (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    booking_id UUID NOT NULL REFERENCES bookings(id) ON DELETE CASCADE,
    old_status VARCHAR(50),
    new_status VARCHAR(50) NOT NULL,
    changed_by UUID REFERENCES users(id),
    change_reason TEXT,
    changed_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_booking_history_booking_id ON booking_history(booking_id);
CREATE INDEX idx_booking_history_changed_at ON booking_history(changed_at);
```

### 11. Reviews

**Purpose**: Store venue reviews and ratings

```sql
CREATE TABLE reviews (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    venue_id UUID NOT NULL REFERENCES venues(id) ON DELETE CASCADE,
    booking_id UUID NOT NULL REFERENCES bookings(id) ON DELETE CASCADE,
    customer_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    rating INTEGER NOT NULL, -- 1-5
    title VARCHAR(200),
    content TEXT,
    is_verified BOOLEAN DEFAULT TRUE, -- Only verified bookings can review
    is_moderated BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    CONSTRAINT valid_rating CHECK (rating >= 1 AND rating <= 5),
    UNIQUE(booking_id)
);

CREATE INDEX idx_reviews_venue_id ON reviews(venue_id);
CREATE INDEX idx_reviews_customer_id ON reviews(customer_id);
CREATE INDEX idx_reviews_rating ON reviews(rating);
CREATE INDEX idx_reviews_created_at ON reviews(created_at);
```

### 12. AuditLogs

**Purpose**: Track admin actions and system events

```sql
CREATE TABLE audit_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    admin_id UUID NOT NULL REFERENCES users(id),
    action VARCHAR(100) NOT NULL,
    entity_type VARCHAR(50) NOT NULL, -- 'user', 'venue', 'booking'
    entity_id UUID NOT NULL,
    old_values JSONB,
    new_values JSONB,
    ip_address VARCHAR(45),
    user_agent TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_audit_logs_admin_id ON audit_logs(admin_id);
CREATE INDEX idx_audit_logs_entity_type ON audit_logs(entity_type);
CREATE INDEX idx_audit_logs_created_at ON audit_logs(created_at);
```

---

## Key Design Decisions

### 1. UUID Strategy
- **Primary Keys**: All use UUID (gen_random_uuid())
- **Reason**: Better for distributed systems, privacy, and avoiding enumeration attacks

### 2. Timestamps
- **Format**: TIMESTAMP WITH TIME ZONE for all temporal data
- **Default**: NOW() for created_at, manually updated for updated_at
- **Timezone**: UTC stored, client handles localization

### 3. Status Fields
- **Booking Status**: PENDING → APPROVED/REJECTED → COMPLETED/CANCELLED
- **Venue Verification**: pending, approved, rejected
- **Availability Status**: available, booked, blocked

### 4. Indexes
- **Foreign Keys**: Indexed for JOIN performance
- **Common Filters**: city, status, date range
- **Sorting**: created_at, rating
- **Compound Indexes**: For frequently used WHERE + ORDER BY combinations

### 5. Constraints
- **Domain Validation**: Capacity > 0, Price > 0, Rating 1-5
- **Date Validation**: Booking date >= today, end_date >= start_date
- **Unique Constraints**: One primary image per venue, one review per booking

### 6. Soft Deletes
- **Not Used**: Hard deletes with CASCADE for MVP simplicity
- **Future**: Consider soft deletes if retention/compliance needed

---

## Query Performance Notes

### High-Frequency Queries
```sql
-- Search venues by city and date
SELECT v.* FROM venues v
LEFT JOIN availability a ON v.id = a.venue_id
WHERE v.city = ? AND a.available_date = ? AND a.status = 'available'
ORDER BY v.average_rating DESC;

-- Get user's bookings
SELECT b.* FROM bookings b
WHERE b.customer_id = ? 
ORDER BY b.created_at DESC;

-- Get venue owner's pending bookings
SELECT b.* FROM bookings b
JOIN venues v ON b.venue_id = v.id
WHERE v.owner_id = ? AND b.status = 'pending'
ORDER BY b.created_at ASC;
```

### Migration Path
All tables use Django ORM migrations for version control and team collaboration.

---

## Scalability Considerations

### Phase 1 (Current)
- Single PostgreSQL instance
- Basic indexing
- No partitioning

### Phase 2 (Projected)
- Read replicas for analytics
- Availability table partitioning by year
- Caching layer (Redis)

### Phase 3 (Future)
- Database sharding by region/tenant
- Event sourcing for bookings
- Data warehouse for analytics
