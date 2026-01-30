# MyGym Backend Requirements & Scope Document

**Document Version:** 1.0  
**Date:** January 29, 2026  
**Prepared By:** Senior Software Architect & Backend Analyst  
**Status:** Ready for Backend Engineer Handoff

---

## Table of Contents

1. [Executive Summary](#1-executive-summary)
2. [System Roles & Permissions](#2-system-roles--permissions)
3. [Authentication & Security Design](#3-authentication--security-design)
4. [Backend Modules Breakdown](#4-backend-modules-breakdown)
5. [API Specification (Initial Draft)](#5-api-specification-initial-draft)
6. [Data Models Overview](#6-data-models-overview)
7. [Backend-Owned Business Logic](#7-backend-owned-business-logic)
8. [Background Jobs & Notifications](#8-background-jobs--notifications)
9. [Open Questions & Missing Decisions](#9-open-questions--missing-decisions)
10. [Handoff Notes for Backend Engineer](#10-handoff-notes-for-backend-engineer)

---

## 1. Executive Summary

### 1.1 Project Overview

**MyGym** is a comprehensive gym management platform that allows users to discover gyms, purchase subscriptions, check-in via QR codes, book fitness classes, earn rewards, and manage their fitness journey. The platform supports multiple user roles across mobile (iOS/Android) and web interfaces.

### 1.2 Backend Scope

The backend must provide:
- **RESTful API** services for all client applications
- **Real-time capabilities** for QR check-in validation and crowd data
- **Payment gateway integrations** (Kashier, Paymob, PayTabs, InstaPay)
- **Push notification** infrastructure
- **Analytics and reporting** for partners and admins
- **Multi-tenant architecture** supporting network-wide and gym-specific subscriptions

### 1.3 Technology Recommendations

| Component | Recommendation | Rationale |
|-----------|----------------|-----------|
| **API Framework** | Node.js (NestJS) or Python (FastAPI) | Type safety, async support, scalability |
| **Database** | PostgreSQL | Relational integrity, JSONB for flexible data |
| **Cache** | Redis | Session management, rate limiting, real-time data |
| **Message Queue** | RabbitMQ or AWS SQS | Background jobs, notifications |
| **File Storage** | AWS S3 / Cloudflare R2 | Gym images, user avatars |
| **Search** | Elasticsearch or PostgreSQL FTS | Gym search with geo-queries |

### 1.4 Scale Expectations

- **Expected Users:** 10,000-100,000 members (initial)
- **Partner Gyms:** 50-500 gyms
- **Daily Check-ins:** 1,000-10,000
- **API Requests:** ~100 requests/second peak
- **Uptime SLA:** 99.9%

---

## 2. System Roles & Permissions

### 2.1 Role Definitions

| Role | Description | Access Level |
|------|-------------|--------------|
| **Guest** | Unauthenticated user exploring the platform | Read-only (gyms, classes, bundles) |
| **Member** | Registered gym-goer with/without subscription | Full consumer features |
| **Partner** | Gym owner/staff managing a single facility | Gym-scoped management |
| **Admin** | Platform administrator | Full system access |

### 2.2 Permission Matrix

| Resource | Guest | Member | Partner | Admin |
|----------|:-----:|:------:|:-------:|:-----:|
| View gyms | ✅ | ✅ | ✅ | ✅ |
| View gym details | ✅ | ✅ | ✅ | ✅ |
| Search gyms | ✅ | ✅ | ✅ | ✅ |
| View classes | ✅ | ✅ | ✅ | ✅ |
| Book classes | ❌ | ✅ | ❌ | ❌ |
| Generate QR code | ❌ | ✅ | ❌ | ❌ |
| Scan QR code | ❌ | ❌ | ✅ | ❌ |
| View own profile | ❌ | ✅ | ✅ | ✅ |
| Purchase subscription | ❌ | ✅ | ❌ | ❌ |
| Submit gym review | ❌ | ✅ | ❌ | ❌ |
| View visit history | ❌ | ✅ | ❌ | ❌ |
| Manage rewards/points | ❌ | ✅ | ❌ | ✅ |
| View gym reports | ❌ | ❌ | ✅ (own gym) | ✅ (all) |
| Manage gym settings | ❌ | ❌ | ✅ (own gym) | ✅ (all) |
| Block users | ❌ | ❌ | ✅ (own gym) | ✅ |
| Manage all gyms | ❌ | ❌ | ❌ | ✅ |
| Manage users | ❌ | ❌ | ❌ | ✅ |
| Platform settings | ❌ | ❌ | ❌ | ✅ |

### 2.3 Partner Sub-Roles (Future Consideration)

⚠️ **UNDEFINED:** The current app does not clearly define partner sub-roles. Consider:
- **Partner Owner:** Full gym management
- **Partner Staff:** QR scanning, basic reporting
- **Partner Manager:** Reports, settings, no billing

---

## 3. Authentication & Security Design

### 3.1 Authentication Methods Required

| Method | Priority | Implementation Notes |
|--------|----------|----------------------|
| **Email/Password** | High | Standard registration flow |
| **Google Sign-In** | High | OAuth 2.0, Firebase Auth integration |
| **Apple Sign-In** | High | Required for iOS App Store |
| **Phone OTP** | High | SMS verification, primary for Egyptian market |
| **Guest Mode** | Medium | Anonymous session with upgrade path |
| **Facebook** | Low | Optional, assess market need |

### 3.2 Token Strategy

```
┌─────────────────────────────────────────────────────────────┐
│                    TOKEN ARCHITECTURE                        │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  Access Token (JWT)           Refresh Token                  │
│  ┌─────────────────┐         ┌─────────────────┐            │
│  │ exp: 15 minutes │         │ exp: 30 days    │            │
│  │ userId          │         │ userId          │            │
│  │ role            │         │ tokenId         │            │
│  │ subscriptionId  │         │ deviceId        │            │
│  └─────────────────┘         └─────────────────┘            │
│                                                              │
│  Storage: Memory/App State    Storage: Secure Storage       │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

**Token Payload (Access Token):**
```json
{
  "sub": "user_uuid",
  "email": "user@example.com",
  "role": "member",
  "subscriptionId": "sub_uuid",
  "subscriptionStatus": "active",
  "gymId": null,
  "iat": 1706540400,
  "exp": 1706541300
}
```

### 3.3 Session Handling

- **Multi-device support:** Track active sessions per user
- **Session limit:** Maximum 5 concurrent devices
- **Forced logout:** Admin can invalidate all user sessions
- **Remember me:** 30-day refresh token (vs 7-day default)

### 3.4 Role-Based Access Control (RBAC)

```
Endpoint Pattern: /api/v1/{domain}/{resource}

Protected Routes:
├── /api/v1/auth/*              → Public (except /logout, /refresh)
├── /api/v1/gyms/*              → Public read, Auth for write
├── /api/v1/member/*            → Member role required
├── /api/v1/partner/*           → Partner role required + gym scope
├── /api/v1/admin/*             → Admin role required
└── /api/v1/webhooks/*          → Signature verification
```

### 3.5 Security Requirements

| Requirement | Implementation |
|-------------|----------------|
| Password hashing | bcrypt with cost factor 12 |
| Rate limiting | 100 req/min per IP, 1000 req/min per user |
| Input validation | Strict schema validation on all endpoints |
| SQL injection | Parameterized queries only |
| XSS prevention | Content-Type enforcement, sanitization |
| CORS | Whitelist specific domains |
| HTTPS | Enforce TLS 1.2+ |
| API versioning | URL path versioning (/api/v1/) |
| Secrets management | Environment variables, vault integration |

---

## 4. Backend Modules Breakdown

### 4.1 Authentication Module

**Responsibilities:**
- User registration and login
- Social authentication (Google, Apple, Facebook)
- Phone OTP generation and verification
- Token issuance and refresh
- Password reset
- Account deletion (GDPR compliance)
- Guest session management

**Key Endpoints:**
```
POST   /api/v1/auth/register
POST   /api/v1/auth/login
POST   /api/v1/auth/google
POST   /api/v1/auth/apple
POST   /api/v1/auth/otp/request
POST   /api/v1/auth/otp/verify
POST   /api/v1/auth/refresh
POST   /api/v1/auth/logout
POST   /api/v1/auth/password/reset/request
POST   /api/v1/auth/password/reset/confirm
POST   /api/v1/auth/guest
DELETE /api/v1/auth/account
```

### 4.2 User Management Module

**Responsibilities:**
- User profile CRUD
- Onboarding completion (city, interests)
- Avatar upload
- Notification preferences
- Privacy settings

**Key Endpoints:**
```
GET    /api/v1/users/me
PATCH  /api/v1/users/me
PATCH  /api/v1/users/me/preferences
POST   /api/v1/users/me/avatar
GET    /api/v1/users/me/settings
PATCH  /api/v1/users/me/settings/notifications
PATCH  /api/v1/users/me/settings/privacy
```

### 4.3 Gym Management Module

**Responsibilities:**
- Gym CRUD (admin)
- Gym search and filtering
- Nearby gym discovery (geo-queries)
- Gym details with working hours
- Real-time crowd data
- Gym reviews and ratings
- Favorites management

**Key Endpoints:**
```
# Public
GET    /api/v1/gyms
GET    /api/v1/gyms/:id
GET    /api/v1/gyms/nearby
GET    /api/v1/gyms/search
GET    /api/v1/gyms/:id/reviews
GET    /api/v1/gyms/:id/crowd
GET    /api/v1/gyms/:id/classes

# Member
GET    /api/v1/member/favorites
POST   /api/v1/member/favorites/:gymId
DELETE /api/v1/member/favorites/:gymId
POST   /api/v1/gyms/:id/reviews
POST   /api/v1/gyms/:id/crowd/report

# Admin
POST   /api/v1/admin/gyms
PATCH  /api/v1/admin/gyms/:id
DELETE /api/v1/admin/gyms/:id
PATCH  /api/v1/admin/gyms/:id/status
```

### 4.4 Subscription & Payments Module

**Responsibilities:**
- Bundle/plan management
- Checkout session creation
- Payment webhook handling
- Subscription lifecycle (activate, cancel, pause, renew)
- Auto-renewal processing
- Invoice generation
- Promo code validation

**Key Endpoints:**
```
# Public
GET    /api/v1/bundles
GET    /api/v1/bundles/:id

# Member
GET    /api/v1/member/subscription
POST   /api/v1/member/subscription/checkout
POST   /api/v1/member/subscription/verify
POST   /api/v1/member/subscription/cancel
PATCH  /api/v1/member/subscription/auto-renew
GET    /api/v1/member/invoices
GET    /api/v1/member/invoices/:id
POST   /api/v1/member/promo/validate

# Webhooks
POST   /api/v1/webhooks/kashier
POST   /api/v1/webhooks/paymob
POST   /api/v1/webhooks/paytabs
```

### 4.5 QR Check-In Module

**Responsibilities:**
- QR token generation (JWT-based, 30-60 second expiry)
- QR token validation
- Check-in processing
- Visit recording
- Visit limits enforcement
- Geofence validation (optional)
- Nonce tracking (one-time use)

**Key Endpoints:**
```
# Member
POST   /api/v1/member/qr/generate
GET    /api/v1/member/visits
GET    /api/v1/member/visits/stats

# Partner
POST   /api/v1/partner/checkin/validate
GET    /api/v1/partner/checkins
```

**QR Token Structure:**
```json
{
  "header": { "alg": "HS256", "typ": "JWT" },
  "payload": {
    "userId": "user_uuid",
    "gymId": "gym_uuid",
    "subscriptionId": "sub_uuid",
    "timestamp": 1706540400,
    "nonce": "random_uuid",
    "exp": 1706540430
  }
}
```

### 4.6 Classes & Booking Module

**Responsibilities:**
- Class schedule management
- Class booking and cancellation
- Waitlist management
- Booking reminders
- Instructor management

**Key Endpoints:**
```
# Public
GET    /api/v1/classes
GET    /api/v1/classes/:id
GET    /api/v1/classes/schedule

# Member
GET    /api/v1/member/bookings
POST   /api/v1/member/bookings
DELETE /api/v1/member/bookings/:id
POST   /api/v1/member/bookings/:id/checkin

# Partner
GET    /api/v1/partner/classes
POST   /api/v1/partner/classes
PATCH  /api/v1/partner/classes/:id
DELETE /api/v1/partner/classes/:id
GET    /api/v1/partner/classes/:id/participants
```

### 4.7 Rewards & Referrals Module

**Responsibilities:**
- Points earning rules
- Points balance tracking
- Points transactions
- Reward catalog management
- Reward redemption
- Referral code generation
- Referral tracking and attribution
- Tier progression (Bronze → Platinum)

**Key Endpoints:**
```
# Member
GET    /api/v1/member/rewards
GET    /api/v1/member/rewards/balance
GET    /api/v1/member/rewards/history
POST   /api/v1/member/rewards/:id/redeem
GET    /api/v1/member/rewards/redemptions
GET    /api/v1/member/referral
POST   /api/v1/member/referral/apply

# Admin
GET    /api/v1/admin/rewards
POST   /api/v1/admin/rewards
PATCH  /api/v1/admin/rewards/:id
GET    /api/v1/admin/rewards/rules
POST   /api/v1/admin/rewards/rules
```

### 4.8 Support & Tickets Module

**Responsibilities:**
- FAQ content management
- Support ticket creation
- Ticket messaging
- Ticket status management
- Staff assignment

**Key Endpoints:**
```
# Public
GET    /api/v1/support/faq
GET    /api/v1/support/about

# Member
GET    /api/v1/member/tickets
POST   /api/v1/member/tickets
GET    /api/v1/member/tickets/:id
POST   /api/v1/member/tickets/:id/messages

# Admin
GET    /api/v1/admin/tickets
PATCH  /api/v1/admin/tickets/:id/assign
PATCH  /api/v1/admin/tickets/:id/status
POST   /api/v1/admin/tickets/:id/messages
```

### 4.9 Partner Dashboard Module

**Responsibilities:**
- Partner gym overview
- Visit reports and analytics
- Revenue tracking
- Peak hours analysis
- User management (block/unblock)
- Working hours management
- QR scanner configuration

**Key Endpoints:**
```
GET    /api/v1/partner/dashboard
GET    /api/v1/partner/reports/visits
GET    /api/v1/partner/reports/revenue
GET    /api/v1/partner/reports/peak-hours
GET    /api/v1/partner/settings
PATCH  /api/v1/partner/settings
PATCH  /api/v1/partner/settings/hours
GET    /api/v1/partner/users/blocked
POST   /api/v1/partner/users/:id/block
DELETE /api/v1/partner/users/:id/block
```

### 4.10 Admin Dashboard Module

**Responsibilities:**
- Platform-wide statistics
- Gym management (CRUD)
- User management
- Subscription plan management
- Revenue reports
- System configuration
- Audit logging

**Key Endpoints:**
```
GET    /api/v1/admin/dashboard
GET    /api/v1/admin/stats

# Gyms
GET    /api/v1/admin/gyms
POST   /api/v1/admin/gyms
PATCH  /api/v1/admin/gyms/:id
DELETE /api/v1/admin/gyms/:id
PATCH  /api/v1/admin/gyms/:id/status
POST   /api/v1/admin/gyms/export

# Users
GET    /api/v1/admin/users
GET    /api/v1/admin/users/:id
PATCH  /api/v1/admin/users/:id/status
DELETE /api/v1/admin/users/:id

# Bundles
GET    /api/v1/admin/bundles
POST   /api/v1/admin/bundles
PATCH  /api/v1/admin/bundles/:id
DELETE /api/v1/admin/bundles/:id

# Reports
GET    /api/v1/admin/reports/revenue
GET    /api/v1/admin/reports/users
GET    /api/v1/admin/reports/gyms
```

### 4.11 Notifications Module

**Responsibilities:**
- Push notification sending (FCM)
- Email notifications
- SMS notifications
- Notification preferences
- Notification templates
- Scheduled notifications

**Internal Services (not direct API):**
- `NotificationService.sendPush()`
- `NotificationService.sendEmail()`
- `NotificationService.sendSMS()`
- `NotificationService.scheduleReminder()`

---

## 5. API Specification (Initial Draft)

### 5.1 Common Response Format

**Success Response:**
```json
{
  "success": true,
  "data": { ... },
  "meta": {
    "page": 1,
    "limit": 20,
    "total": 150,
    "hasMore": true
  }
}
```

**Error Response:**
```json
{
  "success": false,
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Invalid input data",
    "details": [
      { "field": "email", "message": "Invalid email format" }
    ]
  },
  "requestId": "req_abc123"
}
```

### 5.2 Error Codes

| Code | HTTP Status | Description |
|------|-------------|-------------|
| `VALIDATION_ERROR` | 400 | Invalid request payload |
| `UNAUTHORIZED` | 401 | Missing or invalid token |
| `FORBIDDEN` | 403 | Insufficient permissions |
| `NOT_FOUND` | 404 | Resource not found |
| `CONFLICT` | 409 | Resource already exists |
| `RATE_LIMITED` | 429 | Too many requests |
| `INTERNAL_ERROR` | 500 | Server error |
| `SERVICE_UNAVAILABLE` | 503 | Temporary unavailability |

### 5.3 Detailed Endpoint Specifications

#### 5.3.1 POST /api/v1/auth/register

**Request:**
```json
{
  "email": "user@example.com",
  "password": "SecurePass123!",
  "name": "John Doe",
  "phone": "+201234567890"
}
```

**Response (201 Created):**
```json
{
  "success": true,
  "data": {
    "user": {
      "id": "uuid",
      "email": "user@example.com",
      "name": "John Doe",
      "role": "member",
      "isEmailVerified": false,
      "createdAt": "2026-01-29T10:00:00Z"
    },
    "tokens": {
      "accessToken": "eyJ...",
      "refreshToken": "eyJ...",
      "expiresIn": 900
    }
  }
}
```

#### 5.3.2 GET /api/v1/gyms

**Query Parameters:**
| Parameter | Type | Description |
|-----------|------|-------------|
| `lat` | float | User latitude (required for distance) |
| `lng` | float | User longitude (required for distance) |
| `radius` | float | Search radius in km (default: 10) |
| `city` | string | Filter by city |
| `facilities` | string | Comma-separated facility IDs |
| `minRating` | float | Minimum rating (1-5) |
| `openNow` | boolean | Only open gyms |
| `crowdLevel` | string | low, medium, high |
| `sort` | string | distance, rating, popularity |
| `page` | int | Page number (default: 1) |
| `limit` | int | Items per page (default: 20) |

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "id": "gym_uuid",
      "name": "Gold's Gym Maadi",
      "address": "123 Road 9, Maadi, Cairo",
      "latitude": 29.9602,
      "longitude": 31.2569,
      "city": "cairo",
      "images": ["https://..."],
      "facilities": ["weights", "cardio", "pool"],
      "rating": 4.5,
      "reviewCount": 127,
      "crowdLevel": "medium",
      "isOpen": true,
      "distance": 2.3,
      "workingHours": {
        "monday": { "open": "06:00", "close": "23:00" },
        "tuesday": { "open": "06:00", "close": "23:00" }
      }
    }
  ],
  "meta": { "page": 1, "limit": 20, "total": 45, "hasMore": true }
}
```

#### 5.3.3 POST /api/v1/member/qr/generate

**Request:** (empty body, uses auth token)

**Response:**
```json
{
  "success": true,
  "data": {
    "token": "eyJ...",
    "qrData": "base64_encoded_payload",
    "issuedAt": "2026-01-29T10:00:00Z",
    "expiresAt": "2026-01-29T10:00:30Z",
    "remainingVisits": 15,
    "subscriptionType": "Premium"
  }
}
```

#### 5.3.4 POST /api/v1/partner/checkin/validate

**Request:**
```json
{
  "qrData": "base64_encoded_payload"
}
```

**Response (Success):**
```json
{
  "success": true,
  "data": {
    "isAllowed": true,
    "status": "allowed",
    "message": "Check-in successful!",
    "user": {
      "id": "user_uuid",
      "name": "John Doe",
      "photoUrl": "https://...",
      "subscriptionType": "Premium",
      "remainingVisits": 14
    },
    "checkedInAt": "2026-01-29T10:00:05Z"
  }
}
```

**Response (Rejected):**
```json
{
  "success": true,
  "data": {
    "isAllowed": false,
    "status": "no_remaining_visits",
    "message": "No remaining visits on plan",
    "user": {
      "id": "user_uuid",
      "name": "John Doe"
    }
  }
}
```

#### 5.3.5 POST /api/v1/member/subscription/checkout

**Request:**
```json
{
  "bundleId": "bundle_uuid",
  "provider": "kashier",
  "promoCode": "SAVE20"
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "sessionId": "session_uuid",
    "paymentUrl": "https://checkout.kashier.io/...",
    "provider": "kashier",
    "amount": 799.00,
    "originalAmount": 999.00,
    "discount": 200.00,
    "currency": "EGP",
    "expiresAt": "2026-01-29T10:30:00Z"
  }
}
```

---

## 6. Data Models Overview

### 6.1 Core Entities

#### Users
```sql
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email VARCHAR(255) UNIQUE NOT NULL,
  password_hash VARCHAR(255),
  phone VARCHAR(20),
  display_name VARCHAR(100),
  first_name VARCHAR(50),
  last_name VARCHAR(50),
  photo_url TEXT,
  role VARCHAR(20) NOT NULL DEFAULT 'member', -- guest, member, partner, admin
  is_email_verified BOOLEAN DEFAULT FALSE,
  is_phone_verified BOOLEAN DEFAULT FALSE,
  city VARCHAR(50),
  interests TEXT[], -- JSONB array of strings
  points_balance INT DEFAULT 0,
  referral_code VARCHAR(20) UNIQUE,
  membership_tier VARCHAR(20) DEFAULT 'bronze',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  last_login_at TIMESTAMPTZ,
  deleted_at TIMESTAMPTZ
);

CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_phone ON users(phone);
CREATE INDEX idx_users_role ON users(role);
CREATE INDEX idx_users_city ON users(city);
```

#### Gyms
```sql
CREATE TABLE gyms (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name VARCHAR(200) NOT NULL,
  name_ar VARCHAR(200),
  description TEXT,
  description_ar TEXT,
  address VARCHAR(500) NOT NULL,
  address_ar VARCHAR(500),
  city VARCHAR(50) NOT NULL,
  latitude DECIMAL(10, 8) NOT NULL,
  longitude DECIMAL(11, 8) NOT NULL,
  images TEXT[],
  facilities TEXT[],
  rating DECIMAL(2, 1) DEFAULT 0,
  review_count INT DEFAULT 0,
  max_capacity INT DEFAULT 100,
  current_occupancy INT DEFAULT 0,
  crowd_level VARCHAR(20),
  status VARCHAR(20) DEFAULT 'pending', -- pending, active, suspended, blocked
  is_partner BOOLEAN DEFAULT FALSE,
  partner_since DATE,
  revenue_share_percentage DECIMAL(5, 2) DEFAULT 70.00,
  contact_phone VARCHAR(20),
  contact_email VARCHAR(255),
  website VARCHAR(255),
  whatsapp VARCHAR(20),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_gyms_city ON gyms(city);
CREATE INDEX idx_gyms_status ON gyms(status);
CREATE INDEX idx_gyms_location ON gyms USING GIST (
  ll_to_earth(latitude, longitude)
);
```

#### Gym Working Hours
```sql
CREATE TABLE gym_working_hours (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  gym_id UUID NOT NULL REFERENCES gyms(id) ON DELETE CASCADE,
  day_of_week INT NOT NULL, -- 1-7 (Monday-Sunday)
  open_time TIME,
  close_time TIME,
  is_closed BOOLEAN DEFAULT FALSE,
  UNIQUE (gym_id, day_of_week)
);
```

#### Subscription Bundles
```sql
CREATE TABLE subscription_bundles (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name VARCHAR(100) NOT NULL,
  name_ar VARCHAR(100),
  description TEXT,
  type VARCHAR(20) NOT NULL, -- basic, plus, premium, custom
  period VARCHAR(20) NOT NULL, -- perVisit, weekly, monthly, quarterly, yearly
  duration_days INT NOT NULL,
  price DECIMAL(10, 2) NOT NULL,
  original_price DECIMAL(10, 2),
  currency VARCHAR(3) DEFAULT 'EGP',
  visit_limit INT, -- NULL for unlimited
  features TEXT[],
  included_facilities TEXT[],
  gym_id UUID REFERENCES gyms(id), -- NULL for network-wide
  is_popular BOOLEAN DEFAULT FALSE,
  is_active BOOLEAN DEFAULT TRUE,
  sort_order INT DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);
```

#### User Subscriptions
```sql
CREATE TABLE user_subscriptions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id),
  bundle_id UUID NOT NULL REFERENCES subscription_bundles(id),
  status VARCHAR(20) NOT NULL DEFAULT 'pending', -- pending, active, expired, cancelled, paused
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  total_visits INT,
  used_visits INT DEFAULT 0,
  auto_renew BOOLEAN DEFAULT FALSE,
  payment_method_id UUID,
  next_billing_date DATE,
  next_billing_amount DECIMAL(10, 2),
  cancelled_at TIMESTAMPTZ,
  cancellation_reason TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_subscriptions_user ON user_subscriptions(user_id);
CREATE INDEX idx_subscriptions_status ON user_subscriptions(status);
CREATE INDEX idx_subscriptions_end_date ON user_subscriptions(end_date);
```

#### Visits
```sql
CREATE TABLE visits (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id),
  gym_id UUID NOT NULL REFERENCES gyms(id),
  subscription_id UUID REFERENCES user_subscriptions(id),
  check_in_time TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  check_out_time TIMESTAMPTZ,
  visit_type VARCHAR(20) DEFAULT 'regular', -- regular, classAttendance, guestPass, trialVisit
  points_earned INT DEFAULT 0,
  was_deducted BOOLEAN DEFAULT FALSE,
  qr_nonce VARCHAR(50) NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_visits_user ON visits(user_id);
CREATE INDEX idx_visits_gym ON visits(gym_id);
CREATE INDEX idx_visits_date ON visits(check_in_time);
CREATE UNIQUE INDEX idx_visits_nonce ON visits(qr_nonce);
```

#### Fitness Classes
```sql
CREATE TABLE fitness_classes (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  gym_id UUID NOT NULL REFERENCES gyms(id),
  name VARCHAR(100) NOT NULL,
  description TEXT,
  category VARCHAR(50) NOT NULL, -- yoga, cardio, strength, etc.
  difficulty VARCHAR(20) NOT NULL, -- beginner, intermediate, advanced, allLevels
  instructor_id UUID REFERENCES instructors(id),
  duration_minutes INT NOT NULL,
  max_participants INT NOT NULL,
  equipment TEXT[],
  tags TEXT[],
  image_url TEXT,
  is_recurring BOOLEAN DEFAULT FALSE,
  recurring_pattern TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE class_schedules (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  class_id UUID NOT NULL REFERENCES fitness_classes(id),
  start_time TIMESTAMPTZ NOT NULL,
  end_time TIMESTAMPTZ NOT NULL,
  room VARCHAR(50),
  is_cancelled BOOLEAN DEFAULT FALSE,
  cancellation_reason TEXT,
  substitute_instructor_id UUID REFERENCES instructors(id),
  current_participants INT DEFAULT 0,
  waitlist_count INT DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE class_bookings (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id),
  schedule_id UUID NOT NULL REFERENCES class_schedules(id),
  status VARCHAR(20) NOT NULL DEFAULT 'confirmed', -- confirmed, waitlisted, cancelled, completed, noShow
  booked_at TIMESTAMPTZ DEFAULT NOW(),
  cancelled_at TIMESTAMPTZ,
  cancellation_reason TEXT,
  waitlist_position INT,
  reminder_sent BOOLEAN DEFAULT FALSE,
  checked_in_at TIMESTAMPTZ,
  UNIQUE (user_id, schedule_id)
);
```

#### Points & Rewards
```sql
CREATE TABLE points_transactions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id),
  type VARCHAR(20) NOT NULL, -- earned, redeemed, expired, bonus, referral, adjustment
  points INT NOT NULL,
  balance_after INT NOT NULL,
  description TEXT,
  reference_id UUID,
  reference_type VARCHAR(50),
  expires_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE reward_items (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name VARCHAR(100) NOT NULL,
  description TEXT,
  type VARCHAR(20) NOT NULL, -- points, freeVisit, discount, merchandise, classPass, guestPass
  points_cost INT NOT NULL,
  image_url TEXT,
  is_available BOOLEAN DEFAULT TRUE,
  stock_count INT,
  valid_until TIMESTAMPTZ,
  applicable_gym_ids UUID[],
  required_tier VARCHAR(20),
  max_redemptions_per_user INT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE redemptions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id),
  reward_id UUID NOT NULL REFERENCES reward_items(id),
  points_spent INT NOT NULL,
  code VARCHAR(50),
  status VARCHAR(20) DEFAULT 'active', -- active, used, expired, cancelled
  redeemed_at TIMESTAMPTZ DEFAULT NOW(),
  used_at TIMESTAMPTZ,
  expires_at TIMESTAMPTZ NOT NULL
);

CREATE TABLE referrals (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  referrer_id UUID NOT NULL REFERENCES users(id),
  referee_id UUID REFERENCES users(id),
  referral_code VARCHAR(20) NOT NULL,
  status VARCHAR(20) DEFAULT 'pending', -- pending, registered, subscribed, completed, expired
  points_earned INT DEFAULT 0,
  bonus_points_earned INT DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  completed_at TIMESTAMPTZ
);
```

#### Support Tickets
```sql
CREATE TABLE support_tickets (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id),
  subject VARCHAR(200) NOT NULL,
  description TEXT NOT NULL,
  category VARCHAR(50) NOT NULL, -- general, billing, technical, complaint, suggestion
  priority VARCHAR(20) DEFAULT 'normal', -- low, normal, high, urgent
  status VARCHAR(20) DEFAULT 'open', -- open, inProgress, waitingOnUser, resolved, closed
  assigned_to UUID REFERENCES users(id),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  resolved_at TIMESTAMPTZ
);

CREATE TABLE ticket_messages (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  ticket_id UUID NOT NULL REFERENCES support_tickets(id),
  sender_id UUID NOT NULL REFERENCES users(id),
  message TEXT NOT NULL,
  is_from_staff BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);
```

### 6.2 Entity Relationships

```
┌─────────────┐     ┌─────────────────┐     ┌─────────────┐
│    Users    │────<│ User Subscriptions│────>│   Bundles   │
└─────────────┘     └─────────────────┘     └─────────────┘
      │                     │
      │                     │
      ▼                     ▼
┌─────────────┐     ┌─────────────────┐
│   Visits    │────>│      Gyms       │
└─────────────┘     └─────────────────┘
      │                     │
      │                     │
      ▼                     ▼
┌─────────────┐     ┌─────────────────┐
│  Bookings   │────>│ Class Schedules │
└─────────────┘     └─────────────────┘
                           │
                           │
                           ▼
                    ┌─────────────────┐
                    │ Fitness Classes │
                    └─────────────────┘
```

---

## 7. Backend-Owned Business Logic

### 7.1 Critical Backend Responsibilities

| Logic | Location | Reason |
|-------|----------|--------|
| Subscription validation | Backend | Security-critical, tamper-proof |
| Visit limit enforcement | Backend | Prevents fraud |
| QR token generation/validation | Backend | Security (JWT signing) |
| Payment processing | Backend | PCI compliance |
| Points calculation | Backend | Prevent manipulation |
| Promo code validation | Backend | Business rules |
| Geofence validation | Backend | Accuracy, security |
| Rate limiting | Backend | DDoS protection |

### 7.2 Business Rules to Enforce

#### Subscription Rules
```
1. Only ONE active subscription per user at a time
2. Visit deduction only for valid subscriptions:
   - Status = 'active'
   - end_date >= today
   - remaining_visits > 0 (if limited)
3. Auto-renewal:
   - Process 1 day before expiry
   - Retry up to 3 times on payment failure
   - Notify user 7 days, 3 days, 1 day before expiry
4. Cancellation:
   - No refund for used portion
   - Access continues until end_date
   - Disable auto-renewal
```

#### QR Check-In Rules
```
1. Token validity: 30-60 seconds
2. Nonce tracking: Prevent replay attacks
3. Daily visit limit: Max 1 visit per gym per day
4. Weekly visit limit: Configurable per gym (default: 7)
5. Subscription check on scan:
   - Active subscription
   - Gym is in subscription scope
   - Remaining visits > 0
6. Geofence (optional): Within 100m of gym location
7. Points award: Only on first check-in of the day
```

#### Points & Rewards Rules
```
1. Points earning:
   - Check-in: 10 points (tier multiplier applies)
   - Class attendance: 15 points
   - Referral completion: 500 points
   - Subscription purchase: 5% of price in points
2. Tier progression:
   - Bronze: 0 points (1.0x multiplier)
   - Silver: 1,000 lifetime points (1.25x)
   - Gold: 5,000 lifetime points (1.5x)
   - Platinum: 15,000 lifetime points (2.0x)
3. Points expiry: 12 months from earning
4. Redemption validation:
   - Sufficient balance
   - Tier requirement met
   - Stock available
   - Not expired
```

### 7.3 Logic Incorrectly in Frontend (to be moved)

| Current Location | Should Be | Notes |
|------------------|-----------|-------|
| Visit limit calculation | Backend | Frontend shows dummy remaining visits |
| Subscription status check | Backend | Always returns true in dev |
| QR token generation | Backend | Frontend generates fake tokens |
| Points display | Backend | Hardcoded in frontend |
| Crowd level calculation | Backend | Should be real-time |

---

## 8. Background Jobs & Notifications

### 8.1 Scheduled Jobs

| Job | Schedule | Description |
|-----|----------|-------------|
| `subscription:expire` | Daily 00:00 | Mark expired subscriptions |
| `subscription:reminder` | Daily 09:00 | Send expiry reminders (7, 3, 1 day) |
| `subscription:auto-renew` | Daily 23:00 | Process auto-renewals |
| `points:expire` | Daily 00:00 | Expire old points |
| `booking:reminder` | Every 30 min | Send class reminders |
| `booking:mark-no-show` | Every hour | Mark missed bookings |
| `reports:daily` | Daily 02:00 | Generate partner daily reports |
| `reports:weekly` | Monday 02:00 | Generate weekly digests |
| `crowd:update` | Every 5 min | Update gym crowd levels |
| `cleanup:tokens` | Every hour | Remove expired QR nonces |

### 8.2 Push Notification Triggers

| Event | Recipients | Template |
|-------|------------|----------|
| Subscription purchased | User | "Welcome! Your {bundle} subscription is active." |
| Subscription expiring | User | "Your subscription expires in {days} days." |
| Subscription expired | User | "Your subscription has expired. Renew now!" |
| Check-in success | User | "Checked in at {gym}. Enjoy your workout!" |
| Class reminder | User | "Your {class} starts in 30 minutes at {gym}." |
| Class cancelled | Booked users | "Unfortunately, {class} has been cancelled." |
| Waitlist promotion | User | "Good news! You're now booked for {class}." |
| Points earned | User | "You earned {points} points!" |
| Reward redeemed | User | "Your reward is ready: {reward}" |
| Referral completed | Referrer | "{name} joined! You earned {points} points." |
| New review | Partner | "New {rating}★ review from {user}" |

### 8.3 Email Notifications

| Type | Trigger | Content |
|------|---------|---------|
| Welcome | Registration | Onboarding guide, app features |
| Email verification | Registration | Verification link |
| Password reset | Request | Reset link (expires 1 hour) |
| Invoice | Payment success | PDF invoice attached |
| Subscription receipt | Purchase | Payment details, bundle info |
| Weekly digest | Cron | Visit stats, points summary |
| Monthly summary | Cron | Monthly stats, achievements |

### 8.4 SMS Notifications

| Type | Trigger | Content |
|------|---------|---------|
| OTP | Login/verify | "Your MyGym code is: {code}" |
| Subscription expiry | 1 day before | "Your subscription expires tomorrow" |
| Critical alerts | Payment failure | "Payment failed for subscription" |

---

## 9. Open Questions & Missing Decisions

### 9.1 Product Decisions Required

| Question | Options | Impact |
|----------|---------|--------|
| **Partner sub-roles** | Single role vs Owner/Manager/Staff | Partner management complexity |
| **Guest to member upgrade** | Keep history vs fresh start | Data migration |
| **Refund policy** | No refund vs prorated vs full | Payment flow |
| **Subscription pause** | Allow vs not allow | Subscription logic |
| **Class no-show penalty** | None vs points deduction vs temp ban | Booking rules |
| **Review moderation** | Auto-publish vs manual approval | Content management |
| **Multi-gym same-day visits** | Allow vs restrict | Visit tracking |
| **Offline check-in** | Support vs online only | QR validation |

### 9.2 Technical Decisions Required

| Question | Options | Impact |
|----------|---------|--------|
| **Real-time protocol** | WebSocket vs SSE vs Polling | Crowd data, notifications |
| **File storage** | S3 vs R2 vs GCS | Cost, performance |
| **Search engine** | PostgreSQL FTS vs Elasticsearch | Gym search performance |
| **SMS provider** | Twilio vs local provider | Cost for Egypt |
| **Payment retry strategy** | Immediate vs exponential backoff | Failed payments |
| **Audit logging** | Application vs DB triggers | Compliance |
| **Data residency** | Egypt vs EU vs US | GDPR, local laws |

### 9.3 Undefined Flows

| Flow | What's Missing |
|------|----------------|
| **Onboarding completion** | What happens if user skips city/interests? |
| **Guest upgrade** | Data retention when guest becomes member |
| **Partner onboarding** | How does a gym become a partner? |
| **Subscription overlap** | What if user buys new bundle before expiry? |
| **Class booking conflict** | User books two overlapping classes |
| **Account deletion** | Data retention for legal/financial records |
| **Partner blocking user** | Cross-gym ban or single gym only? |

### 9.4 Missing Feature Specifications

| Feature | Status |
|---------|--------|
| **Search functionality** | Basic structure, no detailed spec |
| **Rating algorithm** | Simple average, consider weighted |
| **Crowd prediction** | ML model or historical averages |
| **Promo code types** | Percentage, fixed, first-purchase |
| **Wallet/Credits** | Mentioned but not detailed |
| **Freeze subscription** | Mentioned but not implemented |
| **Trial period** | Not specified |
| **Instructor profiles** | Entity exists but sparse |

---

## 10. Handoff Notes for Backend Engineer

### 10.1 Priority Implementation Order

```
Phase 1: Foundation (Weeks 1-2)
├── Database setup & migrations
├── Authentication (email, Google, OTP)
├── User management
└── Basic gym CRUD

Phase 2: Core Features (Weeks 3-4)
├── Subscription bundles
├── Payment integration (start with Kashier)
├── QR check-in flow
└── Visit tracking

Phase 3: Member Features (Weeks 5-6)
├── Class booking
├── Gym reviews
├── Favorites
└── Visit history

Phase 4: Rewards & Partner (Weeks 7-8)
├── Points system
├── Rewards catalog
├── Referral system
├── Partner dashboard

Phase 5: Admin & Polish (Weeks 9-10)
├── Admin dashboard
├── Reports & analytics
├── Notifications
└── Final integrations
```

### 10.2 Integration Points

| System | Integration Method | Notes |
|--------|-------------------|-------|
| Firebase Auth | SDK | Google/Apple sign-in tokens |
| Kashier | REST API + Webhooks | Payment processing |
| Paymob | REST API + Webhooks | Alternative payment |
| Firebase Cloud Messaging | SDK | Push notifications |
| SendGrid / Mailgun | REST API | Email delivery |
| Twilio / SMS Misr | REST API | SMS delivery |
| Google Maps | Client-side only | No backend integration needed |

### 10.3 Testing Requirements

| Type | Coverage Target |
|------|-----------------|
| Unit tests | 80% on business logic |
| Integration tests | All API endpoints |
| E2E tests | Critical flows (auth, payment, check-in) |
| Load tests | 100 concurrent users |
| Security tests | OWASP Top 10 |

### 10.4 Documentation Required

- [ ] OpenAPI/Swagger spec for all endpoints
- [ ] Database schema documentation
- [ ] Webhook payload documentation
- [ ] Error code reference
- [ ] Admin guide for managing the platform
- [ ] Partner guide for dashboard usage

### 10.5 Environment Setup

```
Environments:
├── Development (dev-api.mygym.app)
├── Staging (staging-api.mygym.app)
└── Production (api.mygym.app)

Required Environment Variables:
├── DATABASE_URL
├── REDIS_URL
├── JWT_SECRET
├── JWT_REFRESH_SECRET
├── FIREBASE_PROJECT_ID
├── FIREBASE_PRIVATE_KEY
├── KASHIER_API_KEY
├── KASHIER_WEBHOOK_SECRET
├── PAYMOB_API_KEY
├── SENDGRID_API_KEY
├── TWILIO_ACCOUNT_SID
├── TWILIO_AUTH_TOKEN
├── AWS_ACCESS_KEY_ID
├── AWS_SECRET_ACCESS_KEY
├── S3_BUCKET_NAME
└── SENTRY_DSN
```

### 10.6 Key Risks & Mitigations

| Risk | Mitigation |
|------|------------|
| Payment fraud | Implement webhook signature verification |
| QR replay attacks | Nonce tracking + short expiry |
| DDoS | Rate limiting + CDN |
| Data breach | Encryption at rest, TLS, audit logging |
| Third-party failures | Circuit breakers, fallback strategies |

---

## Appendix A: API Quick Reference

### Authentication Endpoints
| Method | Endpoint | Auth Required |
|--------|----------|---------------|
| POST | /api/v1/auth/register | ❌ |
| POST | /api/v1/auth/login | ❌ |
| POST | /api/v1/auth/google | ❌ |
| POST | /api/v1/auth/apple | ❌ |
| POST | /api/v1/auth/otp/request | ❌ |
| POST | /api/v1/auth/otp/verify | ❌ |
| POST | /api/v1/auth/refresh | ✅ |
| POST | /api/v1/auth/logout | ✅ |

### Gym Endpoints
| Method | Endpoint | Auth Required |
|--------|----------|---------------|
| GET | /api/v1/gyms | ❌ |
| GET | /api/v1/gyms/:id | ❌ |
| GET | /api/v1/gyms/nearby | ❌ |
| GET | /api/v1/gyms/search | ❌ |
| GET | /api/v1/gyms/:id/reviews | ❌ |
| POST | /api/v1/gyms/:id/reviews | ✅ Member |

### Subscription Endpoints
| Method | Endpoint | Auth Required |
|--------|----------|---------------|
| GET | /api/v1/bundles | ❌ |
| GET | /api/v1/member/subscription | ✅ Member |
| POST | /api/v1/member/subscription/checkout | ✅ Member |
| POST | /api/v1/member/subscription/verify | ✅ Member |
| POST | /api/v1/member/subscription/cancel | ✅ Member |

### Check-In Endpoints
| Method | Endpoint | Auth Required |
|--------|----------|---------------|
| POST | /api/v1/member/qr/generate | ✅ Member |
| POST | /api/v1/partner/checkin/validate | ✅ Partner |

---

## Appendix B: Glossary

| Term | Definition |
|------|------------|
| **Bundle** | A subscription plan/package |
| **Check-in** | Recording a gym visit via QR scan |
| **Nonce** | One-time-use identifier for QR tokens |
| **Partner** | A gym that participates in the MyGym network |
| **Tier** | Member loyalty level (Bronze, Silver, Gold, Platinum) |
| **Visit** | A recorded gym attendance session |

---

**Document End**

*This document should be reviewed with the Product team to clarify open questions before backend implementation begins.*