# Flow Diagrams - Book My Venue

Complete visual flow diagrams for all major workflows in the Book My Venue platform.

---

## 1. Customer Journey Flow

```mermaid
graph TD
    A[User Visits Platform] --> B{Logged In?}
    B -->|No| C[Register/Login]
    B -->|Yes| D[Browse Home]
    C --> D
    D --> E[Search Venues]
    E --> F[View Venue Details]
    F --> G{Interested?}
    G -->|No| E
    G -->|Yes| H[Submit Booking]
    H --> I[Select Date & Guests]
    I --> J[Confirm Booking]
    J --> K[Booking Created - Pending]
    K --> L{Owner Approves?}
    L -->|Rejected| M[Booking Cancelled]
    L -->|Approved| N[Booking Approved]
    N --> O[Make Payment]
    O --> P[Payment Confirmed]
    P --> Q[Event Date Approaches]
    Q --> R[Booking Completed]
    R --> S[Submit Review]
    S --> T[Review Published]
```

---

## 2. Venue Owner Workflow

```mermaid
graph TD
    A[Owner Registration] --> B[Setup Venue Profile]
    B --> C[Add Venue Details]
    C --> D[Upload Images]
    D --> E[Set Amenities]
    E --> F[Set Pricing]
    F --> G[Submit for Verification]
    G --> H{Admin Approves?}
    H -->|Rejected| I[Fix Issues]
    I --> G
    H -->|Approved| J[Venue Live]
    J --> K[Set Availability]
    K --> L[Block Dates if Needed]
    L --> M[Wait for Bookings]
    M --> N[Pending Bookings Arrive]
    N --> O[Review Booking Request]
    O --> P{Approve?}
    P -->|No| Q[Reject Booking]
    P -->|Yes| R[Approve Booking]
    R --> S[Customer Pays]
    S --> T[Booking Confirmed]
    T --> U[Event Date]
    U --> V[Mark Booking Complete]
    V --> W[View Ratings/Reviews]
```

---

## 3. Admin Dashboard Workflow

```mermaid
graph TD
    A[Admin Login] --> B[Admin Dashboard]
    B --> C{Choose Action}
    C -->|User Management| D[View All Users]
    D --> E{User Issues?}
    E -->|Yes| F[Deactivate User]
    C -->|Venue Moderation| G[Pending Venues]
    G --> H{Approve/Reject?}
    H -->|Approve| I[Venue Goes Live]
    H -->|Reject| J[Notify Owner]
    C -->|Dispute Resolution| K[Open Disputes]
    K --> L[Review Dispute Details]
    L --> M{Make Decision}
    M -->|Refund Customer| N[Process Refund]
    M -->|Support Owner| O[Deny Claim]
    C -->|Analytics| P[View Reports]
    P --> Q[System Metrics]
    Q --> R{Export Data?}
    R -->|Yes| S[Download CSV]
```

---

## 4. Booking Process Flow

```mermaid
graph LR
    A[Customer Searches] --> B[Select Venue]
    B --> C[Choose Date]
    C --> D[Add Guests Info]
    D --> E[Add Notes]
    E --> F[Review Booking]
    F --> G{Confirm?}
    G -->|No| B
    G -->|Yes| H[Create Booking]
    H --> I[Status: PENDING]
    I --> J{Owner Action}
    J -->|Reject| K[Status: REJECTED]
    J -->|Approve| L[Status: APPROVED]
    K --> M[Return to Search]
    L --> N[Await Payment]
    N --> O{Payment Received?}
    O -->|No| P[Await Payment]
    O -->|Yes| Q[Status: CONFIRMED]
    Q --> R[Booking Locked]
    R --> S{Event Date Passed?}
    S -->|Yes| T[Status: COMPLETED]
    T --> U[Enable Reviews]
```

---

## 5. API Request Flow

```mermaid
graph TD
    A[Client Request] --> B[API Gateway]
    B --> C[Authentication]
    C --> D{Authenticated?}
    D -->|No| E[Return 401]
    D -->|Yes| F[Authorization Check]
    F --> G{Authorized?}
    G -->|No| H[Return 403]
    G -->|Yes| I[Route to Handler]
    I --> J[Business Logic]
    J --> K[Database Query]
    K --> L{Success?}
    L -->|Error| M[Log Error]
    M --> N[Return 400/500]
    L -->|Success| O[Format Response]
    O --> P[Return 200/201]
    P --> Q[Client Receives Data]
```

---

## 6. Authentication Flow

```mermaid
graph TD
    A[User Registration] --> B[Hash Password]
    B --> C[Store User]
    C --> D[Verification Email Sent]
    D --> E[User Clicks Link]
    E --> F[Mark Email Verified]
    F --> G[User Can Login]
    G --> H[POST /auth/login]
    H --> I{Valid Credentials?}
    I -->|No| J[Return 401]
    I -->|Yes| K[Generate JWT]
    K --> L[Return Access Token & Refresh Token]
    L --> M[Store Tokens Client-Side]
    M --> N[Include Access Token in Requests]
    N --> O{Token Valid?}
    O -->|Expired| P[Use Refresh Token]
    P --> Q[Get New Access Token]
    Q --> N
    O -->|Invalid| R[Return 401 - Logout]
    O -->|Valid| S[Allow Request]
```

---

## 7. Venue Search Flow

```mermaid
graph TD
    A[Enter Search Criteria] --> B[Select City]
    B --> C[Set Date Range]
    C --> D{Filters?}
    D -->|Yes| E[Set Price Range]
    E --> F[Select Amenities]
    F --> G[Set Capacity Min/Max]
    D -->|No| G
    G --> H[Apply Filters]
    H --> I[Query Database]
    I --> J[Check Availability]
    J --> K[Sort Results]
    K --> L{Sort By?}
    L -->|Rating| M[Sort by Rating]
    L -->|Price| N[Sort by Price]
    L -->|Newest| O[Sort by Date Added]
    M --> P[Display Results]
    N --> P
    O --> P
    P --> Q[Show Venue Cards]
    Q --> R[Click Venue Details]
```

---

## 8. Payment & Confirmation Flow

```mermaid
graph TD
    A[Booking Approved] --> B[Generate Invoice]
    B --> C[Send Payment Link]
    C --> D[Customer Clicks Link]
    D --> E[Payment Gateway]
    E --> F[Enter Payment Info]
    F --> G{Valid Payment?}
    G -->|Failed| H[Show Error]
    H --> I[Retry Payment]
    I --> F
    G -->|Success| J[Payment Processed]
    J --> K[Generate Receipt]
    K --> L[Update Booking Status]
    L --> M[Status: CONFIRMED]
    M --> N[Send Confirmation Email]
    N --> O[Customer Gets Details]
    O --> P[Owner Notified]
    P --> Q[Ready for Event]
```

---

## 9. Review & Rating Flow

```mermaid
graph TD
    A[Booking Completed] --> B[Send Review Request Email]
    B --> C[Customer Opens Email]
    C --> D{Wants to Review?}
    D -->|No| E[End]
    D -->|Yes| F[Open Review Form]
    F --> G[Select Rating 1-5]
    G --> H[Write Review Title]
    H --> I[Write Review Content]
    I --> J[Submit Review]
    J --> K[Review Created]
    K --> L[Recalculate Venue Rating]
    L --> M[Update Venue Average]
    M --> N[Review Published]
    N --> O[Show on Venue Page]
    O --> P[Help Other Customers]
```

---

## 10. System Architecture Flow

```mermaid
graph TB
    subgraph Client["Client Layer"]
        A[React Web App]
        B[Mobile Browser]
    end
    
    subgraph API["API Layer"]
        C[Django REST API]
        D[JWT Authentication]
        E[Rate Limiting]
    end
    
    subgraph Service["Service Layer"]
        F[Auth Service]
        G[Venue Service]
        H[Booking Service]
        I[Availability Service]
    end
    
    subgraph Database["Data Layer"]
        J[(PostgreSQL)]
        K[(Redis Cache)]
    end
    
    subgraph Queue["Task Queue"]
        L[Celery]
        M[Email Service]
        N[Notifications]
    end
    
    A --> C
    B --> C
    C --> D
    C --> E
    C --> F
    C --> G
    C --> H
    C --> I
    F --> J
    G --> J
    H --> J
    I --> J
    J --> K
    C --> L
    L --> M
    L --> N
```

---

## 11. Error Handling Flow

```mermaid
graph TD
    A[API Request] --> B{Process}
    B -->|Validation Error| C[Return 400]
    B -->|Auth Error| D[Return 401]
    B -->|Permission Error| E[Return 403]
    B -->|Not Found| F[Return 404]
    B -->|Rate Limited| G[Return 429]
    B -->|Server Error| H[Return 500]
    C --> I[Log Error]
    D --> I
    E --> I
    F --> I
    G --> I
    H --> I
    I --> J{Severity?}
    J -->|Low| K[Monitor]
    J -->|Medium| L[Alert Admin]
    J -->|High| M[Page Admin]
```

---

## 12. Availability Management Flow

```mermaid
graph TD
    A[Owner Dashboard] --> B{Action?}
    B -->|Create Availability| C[Bulk Add Dates]
    C --> D[Select Start Date]
    D --> E[Select End Date]
    E --> F[Set Recurrence]
    F --> G[Create Slots]
    G --> H[Mark Available]
    B -->|Block Dates| I[Select Blocked Dates]
    I --> J[Add Reason]
    J --> K[Mark Blocked]
    K --> L[Update Calendar]
    L --> M[Customers See Status]
    H --> M
    M --> N[Customers Can Filter by Availability]
```

---

## Quick Reference: Status Flows

### Booking Status Flow
```
PENDING → (Owner rejects) → REJECTED
PENDING → (Owner approves) → APPROVED → (Payment) → CONFIRMED → COMPLETED
CONFIRMED → (Customer cancels) → CANCELLED
```

### Venue Status Flow
```
SUBMITTED → (Admin reviews) → APPROVED / REJECTED
APPROVED → (Owner can edit) → PENDING_VERIFICATION
PENDING_VERIFICATION → APPROVED / REJECTED
```

### User Status Flow
```
ACTIVE → (Admin action) → DEACTIVATED
DEACTIVATED → (Can't use platform)
```

---

## Integration Points

### Frontend to API
- All requests include JWT token in header
- Request/response in JSON format
- Error responses include error code and message

### API to Database
- All queries use ORM (Django ORM)
- Connection pooling via Redis
- Indexes on frequently queried fields

### API to External Services
- Email service for notifications
- Payment gateway for transactions
- AWS S3 for image storage

---

## Data Flow Example: Complete Booking

```
1. Customer searches (Client) → API /venues/search
2. API queries Database → Filters venues
3. Customer views details → API /venues/{id}
4. Customer creates booking → API /bookings/
5. API validates availability → Checks database
6. Creates booking record → Saves to DB
7. Sends notification → Celery queue
8. Owner receives email → Email service
9. Owner approves booking → API /bookings/{id}/approve
10. API updates status → Database updated
11. Sends confirmation → Email to customer
12. Customer makes payment → Payment gateway
13. Payment webhook → API /webhooks/payment
14. API confirms booking → Database updated
15. Sends confirmation emails → Both parties
```

---

**Last Updated:** May 25, 2026  
**Version:** 1.0  
**Status:** Complete
