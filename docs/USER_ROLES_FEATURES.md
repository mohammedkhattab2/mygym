# MyGym User Roles & Features

This document outlines the features and capabilities available to each user role within the MyGym platform.

---

## Table of Contents

1. [Member](#1-member)
2. [Guest](#2-guest)
3. [Gym Partner](#3-gym-partner)
4. [Admin](#4-admin)
5. [Feature Comparison Matrix](#feature-comparison-matrix)

---

## 1. Member

**Description:** Regular gym-goers who have an active subscription and use the platform to discover gyms, attend classes, and track their fitness journey.

### Authentication & Profile
- [x] Full account registration and login
- [x] Email/Phone authentication
- [x] Google Sign-In integration
- [x] Profile management ([`profile_view.dart`](lib/src/features/profile/presentation/views/profile_view.dart))
- [x] Edit profile information ([`edit_profile_view.dart`](lib/src/features/profile/presentation/edit_profile_view.dart))

### Subscription Management
- [x] View active subscription details
- [x] Subscription renewal and upgrades
- [x] Access to premium gym facilities based on plan
- [x] Subscription history

### Gym Discovery & Access
- [x] Browse nearby gyms ([`gyms_list_view.dart`](lib/src/features/gyms/presentation/views/gyms_list_view.dart))
- [x] View gym on map ([`gyms_map_view.dart`](lib/src/features/gyms/presentation/views/gyms_map_view.dart))
- [x] Gym details and amenities ([`gym_details_view.dart`](lib/src/features/gyms/presentation/views/gym_details_view.dart))
- [x] Gym reviews and ratings
- [x] Write gym reviews ([`show_add_review_bottom_sheet.dart`](lib/src/features/gyms/presentation/widget/show_add_review_bottom_sheet.dart))
- [x] Check gym crowd levels and working hours

### QR Check-In System
- [x] Generate personal QR code for check-in ([`qr_check_in_view.dart`](lib/src/features/qr_checkin/presentation/views/qr_check_in_view.dart))
- [x] View visit history ([`visit_history_view.dart`](lib/src/features/qr_checkin/presentation/views/visit_history_view.dart))
- [x] Track attendance statistics

### Classes & Booking
- [x] Browse fitness classes ([`classes_calendar_view.dart`](lib/src/features/classes/presentation/views/classes_calendar_view.dart))
- [x] View class schedules and availability
- [x] Book and manage class reservations
- [x] Class reminders and notifications

### Rewards Program
- [x] Earn points for check-ins and activities
- [x] View available rewards
- [x] Redeem points for benefits

### Settings & Support
- [x] App settings management ([`settings_view.dart`](lib/src/features/settings/presentation/views/settings_view.dart))
- [x] Language preferences ([`language_settings_view.dart`](lib/src/features/settings/presentation/views/language_settings_view.dart))
- [x] Notification settings ([`notification_settings_view.dart`](lib/src/features/settings/presentation/views/notification_settings_view.dart))
- [x] FAQ and help center ([`faq_view.dart`](lib/src/features/support/presentation/views/faq_view.dart))
- [x] Support tickets ([`tickets_view.dart`](lib/src/features/support/presentation/views/tickets_view.dart))

---

## 2. Guest

**Description:** Limited access users who are exploring the platform before committing to a subscription. Guests can browse but have restricted functionality.

### Authentication
- [x] Limited browsing without account
- [x] View onboarding content
- [x] Option to register for full access

### Gym Discovery (View Only)
- [x] Browse gym listings
- [x] View gym locations on map
- [x] View gym details and amenities
- [x] View gym reviews (read-only)
- [ ] ~~Write reviews~~ (Requires membership)

### Classes (View Only)
- [x] Browse available classes
- [x] View class schedules
- [ ] ~~Book classes~~ (Requires membership)

### Restricted Features
- [ ] ~~QR Check-In~~ (Requires active subscription)
- [ ] ~~Visit history~~ (Requires membership)
- [ ] ~~Rewards program~~ (Requires membership)
- [ ] ~~Profile management~~ (Requires account)
- [ ] ~~Subscription management~~ (Requires account)

### Conversion Path
- [x] Prominent sign-up prompts
- [x] Feature previews with upgrade suggestions
- [x] Trial subscription offers

---

## 3. Gym Partner

**Description:** Gym owners and staff members who manage their facility through the platform. Partners have access to management tools and analytics.

### Authentication & Account
- [x] Partner account registration
- [x] Multi-user access for staff
- [x] Role-based permissions within gym

### Gym Management
- [x] Edit gym profile and details
- [x] Update working hours
- [x] Manage amenities and facilities list
- [x] Upload gym photos and media
- [x] Set crowd level indicators

### Member Management
- [x] View gym members list
- [x] Scan member QR codes ([`qr_scanner_view.dart`](lib/src/features/qr_checkin/presentation/views/qr_scanner_view.dart))
- [x] Process check-ins
- [x] View member visit history
- [x] Member communication tools

### Class Management
- [x] Create and schedule classes
- [x] Manage class instructors
- [x] Set class capacity limits
- [x] View class bookings
- [x] Cancel or reschedule classes

### Analytics & Reports
- [x] Daily/weekly/monthly attendance reports ([`partner_report.dart`](lib/src/features/partner/domain/entities/partner_report.dart))
- [x] Peak hours analysis
- [x] Member retention metrics
- [x] Revenue tracking
- [x] Class popularity statistics

### Review Management
- [x] View and respond to reviews
- [x] Report inappropriate reviews
- [x] Track overall rating trends

### Settings
- [x] Notification preferences
- [x] Staff access management
- [x] Integration settings

---

## 4. Admin

**Description:** Platform administrators who have full control over the entire MyGym ecosystem. Admins manage all gyms, users, and platform-wide settings.

### Dashboard & Overview
- [x] Platform-wide statistics ([`admin_dashboard_view.dart`](lib/src/features/admin/presentation/views/admin_dashboard_view.dart))
- [x] Real-time metrics ([`admin_stats_cards.dart`](lib/src/features/admin/presentation/widgets/admin_stats_cards.dart))
- [x] System health monitoring
- [x] User activity overview

### Gym Management
- [x] View all registered gyms ([`admin_gym_table.dart`](lib/src/features/admin/presentation/widgets/admin_gym_table.dart))
- [x] Add new gyms ([`gym_form_dialog.dart`](lib/src/features/admin/presentation/widgets/gym_form_dialog.dart))
- [x] Edit gym information
- [x] Approve/reject gym registrations
- [x] Suspend or remove gyms
- [x] Verify gym credentials

### User Management
- [x] View all users (Members, Guests, Partners)
- [x] User account actions (suspend, delete, verify)
- [x] Role assignment and modification
- [x] User complaint resolution

### Subscription & Billing
- [x] Manage subscription plans
- [x] Configure pricing tiers
- [x] Process refunds
- [x] View platform-wide revenue
- [x] Partner payout management

### Content Management
- [x] Manage promotional banners
- [x] Update FAQ content
- [x] Platform announcements
- [x] Terms of service updates

### Support Administration
- [x] View all support tickets
- [x] Assign tickets to team members
- [x] Escalation management
- [x] Response templates

### System Configuration
- [x] Platform settings
- [x] Feature flags
- [x] API management
- [x] Security settings
- [x] Audit logs

### Analytics & Reporting
- [x] Platform growth metrics
- [x] User acquisition data
- [x] Geographic distribution
- [x] Financial reports
- [x] Export capabilities

---

## Feature Comparison Matrix

| Feature | Guest | Member | Gym Partner | Admin |
|---------|:-----:|:------:|:-----------:|:-----:|
| Browse Gyms | ✅ | ✅ | ✅ | ✅ |
| View Gym Details | ✅ | ✅ | ✅ | ✅ |
| Map View | ✅ | ✅ | ✅ | ✅ |
| Write Reviews | ❌ | ✅ | ❌ | ✅ |
| QR Check-In | ❌ | ✅ | ❌ | ❌ |
| Scan QR Codes | ❌ | ❌ | ✅ | ❌ |
| Book Classes | ❌ | ✅ | ❌ | ❌ |
| Manage Classes | ❌ | ❌ | ✅ | ✅ |
| View Analytics | ❌ | ❌ | ✅ | ✅ |
| Manage Gym | ❌ | ❌ | ✅ | ✅ |
| Manage All Gyms | ❌ | ❌ | ❌ | ✅ |
| User Management | ❌ | ❌ | Limited | ✅ |
| Rewards Program | ❌ | ✅ | ❌ | ✅ |
| Support Tickets | ❌ | ✅ | ✅ | ✅ |
| Platform Settings | ❌ | ❌ | ❌ | ✅ |

---

## Role Hierarchy

```
┌─────────────────────────────────────────────────────────┐
│                        ADMIN                            │
│              (Full platform control)                    │
├─────────────────────────────────────────────────────────┤
│                     GYM PARTNER                         │
│            (Facility-level management)                  │
├─────────────────────────────────────────────────────────┤
│                       MEMBER                            │
│           (Full consumer experience)                    │
├─────────────────────────────────────────────────────────┤
│                        GUEST                            │
│              (Limited exploration)                      │
└─────────────────────────────────────────────────────────┘
```

---

## Access Control Implementation

Role-based access is implemented through guards in the routing system:

- **Authentication Guard:** [`auth_guard.dart`](lib/src/core/router/guards/auth_guard.dart) - Ensures user is authenticated
- **Role Guard:** [`role_guard.dart`](lib/src/core/router/guards/role_guard.dart) - Validates user role for protected routes
- **Subscription Guard:** [`subscription_guard.dart`](lib/src/core/router/guards/subscription_guard.dart) - Checks active subscription status

---

## Related Documentation

- [Architecture Report](architectureReport.md)
- [Implementation Guide](IMPLEMENTATION_GUIDE.md)
- [Progress Report](progressReport.md)
- [Project Skeleton](projectSkeleton.md)

---

*Last Updated: January 2026*