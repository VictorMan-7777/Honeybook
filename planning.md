# Micro-SaaS CRM - Comprehensive Project Planning

## Table of Contents
1. [Project Overview](#project-overview)
2. [Functional Requirements](#functional-requirements)
3. [Non-Functional Requirements](#non-functional-requirements)
4. [User Stories & Acceptance Criteria](#user-stories--acceptance-criteria)
5. [Technical Architecture](#technical-architecture)
6. [Database Schema](#database-schema)
7. [API Specifications](#api-specifications)
8. [Detailed Task Breakdown](#detailed-task-breakdown)
9. [Testing Strategy](#testing-strategy)
10. [Deployment Plan](#deployment-plan)
11. [Risk Management & Mitigation](#risk-management--mitigation)
12. [Timeline & Milestones](#timeline--milestones)

---

## Project Overview

### Product Definition
**Micro-SaaS CRM for Creative Entrepreneurs** - A lightweight, intuitive customer relationship management system designed for solo/small-team creative professionals (photographers, event planners, freelancers, etc.).

### Target Users
- **Primary**: Self-employed creative professionals with 50-500 active clients
- **Personas**:
  - **Sarah (Photographer)**: Manages client bookings, portfolios, and follow-ups across 200+ past clients
  - **Marcus (Event Planner)**: Needs centralized pipeline for leads through vendor coordination and event execution
  - **Priya (Freelancer)**: Tracks projects, client communication, and scheduling across multiple time zones

### MVP Scope
The MVP focuses on three core pillars:
1. **Client Management**: Store, organize, and track client information with notes and activity history
2. **Lead Pipeline**: Visualize and manage leads through status stages (hot/warm/cold)
3. **Scheduling**: Calendar integration with Google Calendar for bookings and reminders

### Deferred Items (Post-MVP)

| Feature | Prerequisite | Priority | Estimated Add Time | Rationale |
|---------|--------------|----------|-------------------|-----------|
| **Stripe Payments** | API keys, business verification | High | 1-2 weeks | Core monetization, requires Stripe setup & webhook handling |
| **SMS Reminders** | Twilio account, SMS gateway | Medium | 3-5 days | Nice-to-have, email reminders sufficient for MVP |
| **Time Tracking** | Core scheduling complete | Medium | 2-3 weeks | Requires timer UI, billing integration (post-Stripe) |
| **Workflow Automations** | Pipeline system mature, webhooks | Low | 3-4 weeks | Complex, needs rule engine; users don't expect in MVP |
| **Advanced Analytics** | Sufficient user data, BI tools | Low | 2-3 weeks | Requires 3+ months data; basic metrics sufficient now |
| **Mobile App (Native)** | Web version mature, user base | Low | 6-8 weeks | Web PWA covers most use cases; app after user validation |
| **Slack Integration** | Booking system mature | Low | 1-2 weeks | Nice-to-have notification channel |
| **Zapier Integration** | Stable API, webhook support | Low | 2-3 weeks | Allows users to build custom automations

### Business Goals
- **Timeline**: Ship MVP in 12 weeks (3-month aggressive sprint)
- **Success Metrics**:
  - Functional MVP with 5-10 beta users by Week 12
  - Positive feedback on core workflows (client management, pipeline, scheduling)
  - <2 second page load times
  - Zero critical bugs in production

### Assumptions

- **Solo Development Model**: Assumes one developer using Claude Code/AI acceleration as primary tool for rapid implementation. Manual code review + pair programming for critical sections.
- **Google API Quotas**: Assumes Google Calendar API quota is sufficient for MVP (~100 users). Action: Request quota increase Week 1 if concerned; fallback to polling reduces quota usage.
- **Stripe Integration Deferred**: Assumes basic Stripe setup post-MVP (no complex subscriptions, recurring billing, or payment plans initially). Initial payment: simple one-time or monthly flat rate.
- **Team Availability**: Assumes ability to dedicate 15 hrs/week solo development + AI acceleration. Timeline extends proportionally if fewer hours available.
- **No Existing Users to Migrate**: Assumes greenfield launch; no complex data migration from legacy systems required.
- **Email Delivery**: Assumes SendGrid/Mailgun account available; no custom SMTP server needed.
- **Browser Support**: Assumes primary users on modern browsers (Chrome, Firefox, Safari); IE11 support not required.

### Technology Stack
| Layer | Technology | Rationale |
|-------|-----------|-----------|
| **Frontend** | React 18 + TypeScript + Vite | Component reusability, type safety; Vite: <1s dev build, <400KB prod bundle |
| **Backend** | Ruby on Rails 7+ | Rapid API development, ORM efficiency, built-in testing |
| **Database** | PostgreSQL 14+ | Relational data integrity, JSONB support for flexible fields |
| **Auth** | JWT + Devise + OmniAuth | Secure token auth, email/password + Google OAuth |
| **Build Tool** | Vite | Fast dev server (HMR), optimized production builds |
| **Styling** | Tailwind CSS 3 | Utility-first, responsive, minimal custom CSS |
| **HTTP Client** | Axios | Request/response interceptors, error handling |
| **Form Handling** | React Hook Form + Zod | Lightweight, performant, TypeScript validation |
| **UI Components** | Headless UI + custom Tailwind | Accessible, unstyled components for customization |
| **Hosting** | Docker + Railway/Heroku | Reproducible environments, automated CI/CD, easy scaling |
| **Calendar** | Google Calendar API | Integration with user's existing workflows |
| **Email** | SendGrid or Mailgun | Reliable transactional email delivery |
| **Error Tracking** | Sentry | Real-time error monitoring, source maps |
| **APM** | New Relic or DataDog | Performance monitoring, database query analysis |

---

## Functional Requirements

### FR1: Authentication & Account Management
| Requirement | Description |
|-------------|-------------|
| FR1.1 | User can register with email and password (min 8 chars, complexity rules) |
| FR1.2 | User can log in with email/password credentials |
| FR1.3 | User can authenticate via Google OAuth (Google Sign-In) |
| FR1.4 | User can reset forgotten password via email link |
| FR1.5 | Session management: JWT tokens with 24-hour expiry |
| FR1.6 | User can log out and invalidate session |
| FR1.7 | User account profile: name, email, timezone, company name |

### FR2: Client Management
| Requirement | Description |
|-------------|-------------|
| FR2.1 | Create new client: name, email, phone, company, notes |
| FR2.2 | View all clients in paginated list (20 per page) with sorting |
| FR2.3 | Search clients by name, email, phone, or company |
| FR2.4 | Filter clients by status (active/inactive/archived) |
| FR2.5 | View detailed client profile with full history |
| FR2.6 | Edit client information (name, contact details, tags) |
| FR2.7 | Delete/archive clients (soft delete by default) |
| FR2.8 | Add notes to client (timestamp, user attribution) |
| FR2.9 | View activity log: last contact, interactions, events |
| FR2.10 | Assign tags to clients (e.g., "photography", "referral") |
| FR2.11 | Export clients to CSV format |
| FR2.12 | Import clients from CSV (bulk create with validation) |

### FR3: Lead Pipeline Management
| Requirement | Description |
|-------------|-------------|
| FR3.1 | Create lead status stages: Hot, Warm, Cold (customizable in future) |
| FR3.2 | Assign client/lead to a pipeline stage |
| FR3.3 | Drag-and-drop move clients between pipeline stages |
| FR3.4 | View Kanban board with clients grouped by stage |
| FR3.5 | Add lead tags for categorization (e.g., "wedding", "portrait") |
| FR3.6 | View lead conversion metrics: count by stage, age in stage |
| FR3.7 | Filter pipeline by tag or status |
| FR3.8 | Bulk-move multiple clients between stages |

### FR4: Scheduling & Calendar Integration
| Requirement | Description |
|-------------|-------------|
| FR4.1 | Create appointment/booking for a client with date/time |
| FR4.2 | View calendar in month/week/day view |
| FR4.3 | Authenticate with Google Calendar (OAuth) |
| FR4.4 | One-way sync: Create booking in app → syncs to Google Calendar |
| FR4.5 | Two-way sync: Changes in Google Calendar reflect in app (poll every 5 min) |
| FR4.6 | Set booking status (proposed, confirmed, completed, cancelled) |
| FR4.7 | Send email reminder 24 hours before booking |
| FR4.8 | Reschedule bookings (move date/time) |
| FR4.9 | Cancel bookings with optional client notification |
| FR4.10 | View client's past/upcoming bookings in client detail page |

### FR5: User Interface & Navigation
| Requirement | Description |
|-------------|-------------|
| FR5.1 | Top navigation bar with user menu, logout, settings |
| FR5.2 | Sidebar with navigation to Clients, Pipeline, Calendar, Settings |
| FR5.3 | Responsive design: works on mobile (375px), tablet (768px), desktop (1024px+) |
| FR5.4 | Dark mode toggle (optional for MVP, store in user preferences) |
| FR5.5 | Empty states with clear CTAs (e.g., "No clients yet. Create one.") |
| FR5.6 | Toast notifications for success/error feedback |
| FR5.7 | Loading states on async operations |

## Non-Functional Requirements

### Performance & Scalability

| Category | Requirement | Details |
|----------|-------------|---------|
| **Page Load Time** | <2 seconds on 4G network | Measured via Lighthouse, WebPageTest; First Contentful Paint <1.5s |
| **API Response Time** | <200ms p99, <100ms p50 | Monitor via New Relic; slow queries logged |
| **Bundle Size** | <400 KB gzipped (frontend) | Tree-shake unused dependencies, code splitting |
| **Database Queries** | <100ms p99 for complex queries | Proper indexing, eager loading, connection pooling |
| **Concurrent Users** | Support 100+ concurrent users | Load testing at Week 8 with k6 or Apache Bench |
| **Scalability** | Support 500+ clients per user without degradation | Pagination from start, Redis caching, connection pooling (20 connections) |
| **Availability** | 99.5% uptime SLA (post-MVP target) | Monitoring, alerting, auto-restart on failure |

### Security

| Category | Requirement | Implementation |
|----------|-------------|-----------------|
| **Transport Security** | HTTPS only, TLS 1.2+ | Enforce via headers, Cloudflare configuration |
| **Password Storage** | Bcrypt with cost ≥10 | Devise gem default, no plaintext storage |
| **Authentication** | JWT tokens with 24h expiry | Secure secret key (≥32 chars), no storage in localStorage |
| **Authorization** | Role-based access (user owns data) | CanCanCan gem, verify user_id on all requests |
| **SQL Injection** | Parameterized queries only | Rails ORM, no string concatenation |
| **XSS Prevention** | Content Security Policy headers | CSP-Nonce for inline scripts, sanitize user input |
| **CSRF Protection** | CSRF token on forms | Rails default, verify origin header |
| **GDPR Compliance** | Data export, right to deletion, consent | `/users/export` endpoint, soft delete, cookie banner |
| **Data Encryption** | Sensitive fields encrypted at rest | PII encrypted (first/last name optional) |
| **Audit Logging** | Activity log for all client access | `activity_logs` table, 1-year retention for compliance |
| **Rate Limiting** | 1000 requests/hour per user | Rack::Attack gem, return 429 on limit |

### Accessibility

| Category | Requirement |
|----------|-------------|
| **Standards Compliance** | WCAG 2.1 Level AA (target) |
| **Keyboard Navigation** | All features accessible via keyboard (Tab, Enter, Esc) |
| **Screen Readers** | Proper ARIA labels, semantic HTML |
| **Color Contrast** | >4.5:1 ratio for text; color not sole identifier |
| **Focus Indicators** | Clear focus rings on all interactive elements |
| **Mobile Accessibility** | Touch-friendly (48px+ tap targets), screen reader support |

### Browser & Device Support

| Category | Requirement |
|----------|-------------|
| **Desktop Browsers** | Chrome, Firefox, Safari, Edge (last 2 versions) |
| **Mobile Browsers** | iOS Safari (14+), Chrome Android (90+) |
| **Responsive Design** | Works at 375px (mobile), 768px (tablet), 1024px+ (desktop) |
| **Progressive Web App (PWA)** | Installable, basic offline fallback (deferred: full offline in Phase 2) |

### Data Management

| Category | Requirement | Details |
|----------|-------------|---------|
| **Backup** | Automated daily PostgreSQL backups | 30-day rolling window, stored on S3 with encryption |
| **Recovery** | RTO <1 hour, RPO <1 day | Test recovery monthly, maintain runbook |
| **Data Retention** | User can export all data | CSV export, JSON API, GDPR-compliant |
| **Soft Delete** | Clients can be archived, not permanently deleted | Keep for 90 days before purge (configurable) |
| **Connection Pooling** | 20 DB connections per Rails process | Handle 500+ clients across concurrent requests |

### GDPR & Privacy

| Category | Requirement | Implementation |
|----------|-------------|-----------------|
| **Consent Banner** | Ask permission for analytics/marketing cookies | On landing page + settings page |
| **Data Export** | User can export their data | `GET /users/export` returns JSON/CSV with all data |
| **Account Deletion** | User can delete account + all data | Hard delete after 30-day grace period |
| **Cookie Policy** | Clear, accessible cookie disclosure | Link in footer, detailed breakdown |
| **Third-Party Services** | Disclose all third-party data sharing | Email, Google APIs, SendGrid listed in privacy policy |

---

## User Stories & Acceptance Criteria

### Story 1: User Registration & Login
**As a** creative entrepreneur
**I want to** create an account and log in securely
**So that** my client data is personal to me and protected

**Acceptance Criteria:**
- [ ] User can enter email and password on registration form
- [ ] System validates email format and password strength (8+ chars, mixed case/numbers)
- [ ] User receives confirmation email with verification link
- [ ] User can click link to activate account
- [ ] User can log in with email/password after activation
- [ ] Invalid credentials show clear error message
- [ ] User can reset password via email link
- [ ] Session persists for 24 hours; user stays logged in across page refreshes
- [ ] User can log out and session is cleared

**Acceptance Criteria (Google OAuth):**
- [ ] "Sign in with Google" button visible on login page
- [ ] Clicking button opens Google consent flow
- [ ] User can grant permissions for email and profile
- [ ] New account created automatically with Google email
- [ ] Existing user is logged in
- [ ] OAuth token stored securely (no storage in localStorage)

---

### Story 2: Client Creation & Management
**As a** photographer
**I want to** add clients to my CRM with their contact info and notes
**So that** I have a centralized directory of all my past and potential clients

**Acceptance Criteria:**
- [ ] "Create Client" button visible on Clients page
- [ ] Modal/form opens with fields: name, email, phone, company, tags, notes
- [ ] All fields except notes are required
- [ ] Email format is validated before submit
- [ ] Submit button disabled until required fields filled
- [ ] Client created and added to list view
- [ ] Toast notification confirms "Client created successfully"
- [ ] User can immediately see new client in list
- [ ] Client can be edited after creation
- [ ] Client can be archived/deleted (soft delete)

**Edge Cases:**
- **Duplicate Email**: User tries to create client with email already in database
  - Expected: Error "Email already exists. View existing client or use different email"
  - Future: Merge/link detection in Phase 2
- **Invalid Email Format**: User enters "john@" or "john@.com"
  - Expected: Client-side validation error before submit: "Please enter a valid email"
- **Special Characters in Name**: User enters "José María O'Reilly" or "李明"
  - Expected: Accepted and stored correctly (UTF-8 support)
- **Phone Number Formats**: User enters "+1 (555) 123-4567", "5551234567", "+44 20 7946 0958"
  - Expected: Stored as-is, no normalization in MVP (future: E.164 formatting)
- **Very Long Notes**: User pastes 50,000 character biography
  - Expected: Accepted (TEXT field unlimited); UI may need scrolling
- **Tags Auto-Create vs Select**: User types new tag "urgent-2024" not in dropdown
  - Expected: Creates new tag automatically; saved to tags table
- **Editing Client Email to Existing Email**: User edits client1@example.com to existing client2@example.com
  - Expected: Error "Email already in use"
- **Archiving Client with Active Bookings**: User archives client with upcoming appointment
  - Expected: Allowed (bookings not auto-cancelled); warning: "Client has 3 upcoming bookings"

---

### Story 3: Lead Pipeline Visualization
**As an** event planner
**I want to** see my leads organized in stages (Hot/Warm/Cold)
**So that** I can prioritize follow-ups and track conversion

**Acceptance Criteria:**
- [ ] Kanban board displays three columns: Hot, Warm, Cold
- [ ] Clients assigned to a stage appear in respective column
- [ ] Client card shows name, company, tags, and last contact date
- [ ] User can drag client card between columns
- [ ] Stage change is saved immediately
- [ ] Metrics show count of leads in each stage
- [ ] Filter button allows filtering by tag (e.g., show only "wedding" leads)
- [ ] Empty state message if no clients exist

**Edge Cases:**
- **Duplicate Leads**: User accidentally creates 2 clients for same person
  - Expected: No deduplication in MVP; manual merge deferred to Phase 2
  - Workaround: Archive one duplicate, note in first client's notes
- **Bulk Move Misclick**: User drags and accidentally moves 50 clients to wrong stage
  - Expected: No undo button in MVP; users encouraged to double-check before drag
  - Future: Implement undo/batch operations
- **Stale Stage Indicator**: User drags client to "Hot", page doesn't refresh, others see old state
  - Expected: WebSocket updates deferred; page refresh shows current state (5-min acceptable latency)
- **No Clients in Stage**: User filters to "Closed" deals (not a stage, doesn't exist)
  - Expected: Empty state: "No leads match this filter. Try different criteria."
- **Network Delay During Drag**: User drags client, loses connection before save completes
  - Expected: UI reverts to previous state; error toast: "Failed to update. Try again."

---

### Story 4: Calendar Booking & Google Sync
**As a** freelancer
**I want to** book appointments with clients and sync them to Google Calendar
**So that** all my scheduling is in one place

**Acceptance Criteria:**
- [ ] "Create Booking" button visible on Calendar page
- [ ] Modal opens with client selector, date/time picker, and description field
- [ ] User selects client from dropdown
- [ ] Date/time picker prevents booking in the past
- [ ] Submit creates booking and shows it on calendar
- [ ] Booking appears in Google Calendar (after OAuth)
- [ ] Changes in Google Calendar reflect in app within 5 minutes
- [ ] User can reschedule booking by dragging or editing
- [ ] User can cancel booking with optional client notification
- [ ] 24-hour reminder email sent before confirmed bookings

**Edge Cases:**
- **Overlapping with Existing Booking**: User tries to create 2-hour booking at 2pm when 2:30pm booking exists
  - Expected: Prevent double-booking same time slot for same client. Error: "Time slot unavailable. Closest available: 4pm"
  - Validation: Client-side check before submit + server-side enforce (UNIQUE constraint on client_id, starts_at window)
- **Calendar Sync Conflict**: User edits same booking in Google Calendar and app simultaneously
  - Expected: Last update wins (5-min sync window), user notified of conflict
- **Google Calendar Disconnected**: User cancels Google OAuth after booking existing events
  - Expected: Bookings remain in app; sync paused; prompt to reconnect
- **Timezone Mismatch**: User in PST books 9am, changes timezone to EST mid-day
  - Expected: Booking time adjusted, user notified "Your 9am is now 12pm"
- **Deleted Google Event**: User deletes booking in Google Calendar (sync finds missing event)
  - Expected: App booking marked as cancelled after next sync
- **Recurring Bookings**: User tries to create recurring series (future feature)
  - Expected: Error "Not yet supported. Create individual bookings." (deferred)

---

### Story 5: Client Search & Organization
**As a** photographer with 200+ clients
**I want to** search and filter clients quickly
**So that** I can find information without scrolling endlessly

**Acceptance Criteria:**
- [ ] Search bar visible at top of Clients list
- [ ] Type in search field filters results in real-time by name/email/phone
- [ ] Results update as user types (debounced, 300ms)
- [ ] Clear button resets search
- [ ] Filter dropdown allows filtering by status (active/inactive/archived)
- [ ] Multiple filters can be applied simultaneously
- [ ] Results count shown ("10 clients matched")
- [ ] Empty state if no results match

---

### Story 6: Client Import/Export
**As a** business owner
**I want to** export my client list to CSV and import from CSV
**So that** I can backup data and migrate from other tools

**Acceptance Criteria:**
- [ ] "Export" button on Clients page generates CSV file
- [ ] CSV contains: ID, Name, Email, Phone, Company, Tags, Created Date
- [ ] File downloads with name format: `clients_YYYY-MM-DD.csv`
- [ ] "Import" button opens file picker for CSV
- [ ] System validates CSV format before import
- [ ] Row-level errors shown (e.g., "Row 5: Invalid email")
- [ ] Valid rows imported; invalid rows skipped with warning
- [ ] Import confirmation shows count of created/skipped clients
- [ ] Duplicate detection: email already exists → skip or prompt user

---

### Story 7: Client Notes & Activity Log
**As a** service provider
**I want to** attach notes to clients and see interaction history
**So that** I remember context from previous conversations

**Acceptance Criteria:**
- [ ] Client detail page shows activity timeline
- [ ] User can add note via "Add Note" button
- [ ] Note appears in timeline with timestamp and user name
- [ ] Activity log shows: notes, bookings, pipeline stage changes
- [ ] Each activity shows date/time and attributed user
- [ ] Notes can be edited (with edit timestamp noted)
- [ ] Notes can be deleted by creator or admin
- [ ] Timeline is sorted newest first (descending by date)

---

## Technical Architecture

### System Architecture Overview

```
┌─────────────────────────────────────────────────────────────┐
│                     FRONTEND LAYER                          │
│  React + TypeScript | Responsive UI (Vite/Webpack)        │
│  - Pages: Login, Dashboard, Clients, Pipeline, Calendar    │
│  - Components: Client Form, Kanban Board, Calendar Widget  │
└────────────────────┬──────────────────────────────────────┘
                     │ HTTP/REST API
                     ↓
┌─────────────────────────────────────────────────────────────┐
│                     API GATEWAY & AUTH                      │
│  JWT Bearer Token Validation | CORS Headers               │
│  Rate Limiting (1000 req/hr) | Request Logging            │
└────────────────────┬──────────────────────────────────────┘
                     │
┌─────────────────────────────────────────────────────────────┐
│                   BACKEND LAYER                             │
│  Ruby on Rails API (JSON) | Port 3000                      │
│  - Controllers: Clients, Bookings, Pipelines, Auth         │
│  - Services: GoogleCalendarSync, EmailReminder, CsvImport  │
│  - Middleware: Auth, ErrorHandling, Logging                │
└────────────────────┬──────────────────────────────────────┘
                     │
        ┌────────────┼────────────┐
        ↓            ↓            ↓
┌──────────────┐ ┌─────────┐ ┌──────────────┐
│  PostgreSQL  │ │  Redis  │ │ Google APIs  │
│  (Main DB)   │ │(Caching)│ │ (Calendar)   │
└──────────────┘ └─────────┘ └──────────────┘
        ↓
    Backups (S3)
```

### Frontend Architecture

**Framework**: React 18 + TypeScript + Vite
**State Management**: Context API (or Redux if complexity warrants)
**Styling**: Tailwind CSS + custom component library
**HTTP Client**: Axios with request/response interceptors
**Router**: React Router v6 for page navigation
**Form Handling**: React Hook Form + Zod validation
**Calendar UI**: React Big Calendar + Google Calendar API integration
**Notifications**: Toast library (React Toastify)

**Project Structure:**
```
src/
├── components/
│   ├── Auth/
│   │   ├── LoginForm.tsx
│   │   ├── RegisterForm.tsx
│   │   └── GoogleSignIn.tsx
│   ├── Clients/
│   │   ├── ClientList.tsx
│   │   ├── ClientForm.tsx
│   │   ├── ClientDetail.tsx
│   │   └── SearchBar.tsx
│   ├── Pipeline/
│   │   ├── KanbanBoard.tsx
│   │   ├── PipelineCard.tsx
│   │   └── StagePicker.tsx
│   ├── Calendar/
│   │   ├── CalendarView.tsx
│   │   └── BookingForm.tsx
│   ├── Layout/
│   │   ├── Navbar.tsx
│   │   ├── Sidebar.tsx
│   │   └── MainLayout.tsx
│   └── Common/
│       ├── Loading.tsx
│       ├── EmptyState.tsx
│       └── Modal.tsx
├── hooks/
│   ├── useAuth.ts
│   ├── useClients.ts
│   ├── useBookings.ts
│   └── useGoogleCalendar.ts
├── services/
│   ├── api.ts (Axios instance, interceptors)
│   ├── authService.ts
│   ├── clientService.ts
│   ├── bookingService.ts
│   └── googleCalendarService.ts
├── context/
│   ├── AuthContext.tsx
│   └── NotificationContext.tsx
├── types/
│   ├── index.ts (Global types)
│   ├── client.ts
│   ├── booking.ts
│   └── pipeline.ts
├── pages/
│   ├── LoginPage.tsx
│   ├── DashboardPage.tsx
│   ├── ClientsPage.tsx
│   ├── PipelinePage.tsx
│   ├── CalendarPage.tsx
│   └── SettingsPage.tsx
├── utils/
│   ├── dateUtils.ts
│   ├── csvUtils.ts
│   └── validators.ts
└── App.tsx
```

### Backend Architecture

**Framework**: Ruby on Rails 7 + JSON API
**Authentication**: JWT + Devise (for email/password) + OmniAuth (Google)
**Authorization**: CanCanCan for role-based access
**Job Queue**: Sidekiq + Redis for async jobs (email reminders, calendar sync)
**Caching**: Redis for session storage and API response caching
**Search**: ActiveRecord queries (upgraded to Elasticsearch if needed post-MVP)

**Project Structure:**
```
app/
├── controllers/
│   ├── api/
│   │   ├── v1/
│   │   │   ├── clients_controller.rb
│   │   │   ├── bookings_controller.rb
│   │   │   ├── pipelines_controller.rb
│   │   │   ├── auth_controller.rb
│   │   │   └── calendar_sync_controller.rb
│   │   └── base_controller.rb
│   └── health_check_controller.rb
├── models/
│   ├── user.rb
│   ├── client.rb
│   ├── booking.rb
│   ├── pipeline_stage.rb
│   ├── tag.rb
│   ├── activity_log.rb
│   └── client_note.rb
├── services/
│   ├── google_calendar_sync_service.rb
│   ├── email_reminder_service.rb
│   ├── csv_import_service.rb
│   ├── csv_export_service.rb
│   └── pipeline_analytics_service.rb
├── jobs/
│   ├── send_reminder_email_job.rb
│   ├── sync_google_calendar_job.rb
│   └── cleanup_job.rb
├── serializers/
│   ├── client_serializer.rb
│   ├── booking_serializer.rb
│   ├── pipeline_serializer.rb
│   └── user_serializer.rb
└── policies/
    └── cancan policies (per model)

config/
├── routes.rb
├── environments/
│   ├── development.rb
│   ├── test.rb
│   └── production.rb
└── initializers/
    ├── devise.rb
    ├── omniauth.rb
    ├── cors.rb
    └── sidekiq.rb

db/
├── migrate/
│   └── [timestamps]_create_*.rb
└── seeds.rb
```

### Key Design Decisions

| Decision | Rationale |
|----------|-----------|
| **JWT over Session Cookies** | Stateless auth, easier scaling, mobile-friendly |
| **REST API over GraphQL** | Simpler MVP, faster initial development, CRUD-heavy operations |
| **Context API over Redux** | Lighter bundle, sufficient for MVP scope, easy to migrate |
| **Tailwind CSS** | Rapid styling, responsive utilities, low custom CSS debt |
| **Sidekiq for async jobs** | Reliable job queue, integrates well with Rails, Redis-backed |
| **Google Calendar polling** | Simpler than webhooks (no firewall rules), acceptable 5-min delay for MVP |
| **PostgreSQL over MongoDB** | Relational data (clients → bookings → notes), ACID guarantees, JSON support |

### External Integrations

| Service | Purpose | Integration Type |
|---------|---------|------------------|
| **Google OAuth** | User authentication | OAuth 2.0 (via OmniAuth) |
| **Google Calendar API** | Calendar sync | REST API (google-api-client gem) |
| **SendGrid/Mailgun** | Email delivery | SMTP + REST API |
| **Sentry** | Error tracking | SDK integration |
| **Cloudflare/S3** | Asset storage & CDN | S3 for backups, Cloudflare for DNS |

---

## Database Schema

### Entity Relationship Diagram (Text Format)

```
┌─────────────────┐
│     USERS       │
├─────────────────┤
│ id (PK)         │
│ email           │
│ password_hash   │
│ first_name      │
│ last_name       │
│ company_name    │
│ timezone        │
│ oauth_provider  │
│ oauth_uid       │
│ created_at      │
│ updated_at      │
└────────┬────────┘
         │ (1:N)
         │ owns
         ↓
┌─────────────────────────┐
│      CLIENTS            │
├─────────────────────────┤
│ id (PK)                 │
│ user_id (FK)            │
│ first_name              │
│ last_name               │
│ email                   │
│ phone                   │
│ company                 │
│ status (active/inactive)│
│ archived_at             │
│ notes                   │
│ last_contact_date       │
│ created_at              │
│ updated_at              │
└────────┬────────────────┘
         │ (1:N)
         │ has many
         ├──────────┬──────────┐
         ↓          ↓          ↓
      BOOKINGS  TAGS   CLIENT_NOTES
      (below)   (below) (below)

┌──────────────────────┐
│     BOOKINGS         │
├──────────────────────┤
│ id (PK)              │
│ client_id (FK)       │
│ user_id (FK)         │
│ title                │
│ description          │
│ starts_at (datetime) │
│ ends_at (datetime)   │
│ status (proposed/    │
│   confirmed/complete)│
│ google_event_id      │
│ synced_at            │
│ created_at           │
│ updated_at           │
└──────────────────────┘

┌──────────────────────┐
│     TAGS             │
├──────────────────────┤
│ id (PK)              │
│ user_id (FK)         │
│ name                 │
│ color (hex)          │
│ created_at           │
└──────────────────────┘
     ↑
     │ (N:N)
     │ join table
┌────────────────────────┐
│  CLIENT_TAGS           │
├────────────────────────┤
│ id (PK)                │
│ client_id (FK)         │
│ tag_id (FK)            │
└────────────────────────┘

┌──────────────────────┐
│  CLIENT_NOTES        │
├──────────────────────┤
│ id (PK)              │
│ client_id (FK)       │
│ user_id (FK)         │
│ content              │
│ created_at           │
│ updated_at           │
│ deleted_at           │
└──────────────────────┘

┌─────────────────────────┐
│  PIPELINE_STAGES        │
├─────────────────────────┤
│ id (PK)                 │
│ user_id (FK)            │
│ name (Hot/Warm/Cold)    │
│ position (order)        │
│ created_at              │
└─────────────────────────┘
         ↑
         │ (1:N)
         │ assigned to
┌────────────────────────┐
│  CLIENT_PIPELINE       │
├────────────────────────┤
│ id (PK)                │
│ client_id (FK)         │
│ pipeline_stage_id (FK) │
│ entered_at             │
│ created_at             │
└────────────────────────┘

┌──────────────────────┐
│   ACTIVITY_LOGS      │
├──────────────────────┤
│ id (PK)              │
│ user_id (FK)         │
│ client_id (FK)       │
│ action_type          │
│ (created/updated/    │
│  deleted/moved)      │
│ details (JSON)       │
│ created_at           │
└──────────────────────┘
```

### Table Definitions

#### USERS
```sql
CREATE TABLE users (
  id BIGINT PRIMARY KEY,
  email VARCHAR(255) UNIQUE NOT NULL,
  password_digest VARCHAR(255) NOT NULL,
  first_name VARCHAR(100),
  last_name VARCHAR(100),
  company_name VARCHAR(255),
  timezone VARCHAR(50) DEFAULT 'UTC',
  oauth_provider VARCHAR(50),
  oauth_uid VARCHAR(255),
  confirmed_at TIMESTAMP,
  last_sign_in_at TIMESTAMP,
  created_at TIMESTAMP NOT NULL,
  updated_at TIMESTAMP NOT NULL,
  INDEX (email),
  INDEX (oauth_provider, oauth_uid)
);
```

#### CLIENTS
```sql
CREATE TABLE clients (
  id BIGINT PRIMARY KEY,
  user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  first_name VARCHAR(100) NOT NULL,
  last_name VARCHAR(100) NOT NULL,
  email VARCHAR(255),
  phone VARCHAR(20),
  company VARCHAR(255),
  status VARCHAR(50) DEFAULT 'active' CHECK (status IN ('active', 'inactive')),
  archived_at TIMESTAMP,
  notes TEXT,
  metadata JSONB DEFAULT '{}',  -- Flexible fields: custom fields, preferences
  last_contact_date DATE,
  created_at TIMESTAMP NOT NULL,
  updated_at TIMESTAMP NOT NULL,
  INDEX (user_id, status),
  INDEX (user_id, archived_at),
  GIN INDEX (metadata),  -- For JSONB queries
  FULLTEXT INDEX (first_name, last_name, email)
);
```

**JSONB Metadata Examples**:
```json
{
  "custom_fields": {
    "preferred_time": "afternoon",
    "budget_range": "5000-10000",
    "referral_source": "Instagram"
  },
  "preferences": {
    "communication_method": "email",
    "reminder_enabled": true
  },
  "tags_deprecated": []  -- Migrated to CLIENT_TAGS table
}
```

#### BOOKINGS
```sql
CREATE TABLE bookings (
  id BIGINT PRIMARY KEY,
  client_id BIGINT NOT NULL REFERENCES clients(id) ON DELETE CASCADE,
  user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  title VARCHAR(255) NOT NULL,
  description TEXT,
  starts_at TIMESTAMP NOT NULL,
  ends_at TIMESTAMP NOT NULL,
  status VARCHAR(50) DEFAULT 'proposed' CHECK (status IN ('proposed', 'confirmed', 'completed', 'cancelled')),
  google_event_id VARCHAR(255),
  synced_at TIMESTAMP,
  created_at TIMESTAMP NOT NULL,
  updated_at TIMESTAMP NOT NULL,
  INDEX (user_id, starts_at),
  INDEX (client_id, starts_at),
  INDEX (google_event_id)
);
```

#### TAGS
```sql
CREATE TABLE tags (
  id BIGINT PRIMARY KEY,
  user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  name VARCHAR(100) NOT NULL,
  color VARCHAR(7), -- hex color code
  created_at TIMESTAMP NOT NULL,
  UNIQUE (user_id, name),
  INDEX (user_id)
);
```

#### CLIENT_TAGS (Join Table)
```sql
CREATE TABLE client_tags (
  id BIGINT PRIMARY KEY,
  client_id BIGINT NOT NULL REFERENCES clients(id) ON DELETE CASCADE,
  tag_id BIGINT NOT NULL REFERENCES tags(id) ON DELETE CASCADE,
  PRIMARY KEY (client_id, tag_id),
  INDEX (tag_id)
);
```

#### CLIENT_NOTES
```sql
CREATE TABLE client_notes (
  id BIGINT PRIMARY KEY,
  client_id BIGINT NOT NULL REFERENCES clients(id) ON DELETE CASCADE,
  user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  content TEXT NOT NULL,
  metadata JSONB DEFAULT '{}',  -- Rich formatting, mentions, attachments
  deleted_at TIMESTAMP,
  created_at TIMESTAMP NOT NULL,
  updated_at TIMESTAMP NOT NULL,
  INDEX (client_id, created_at),
  INDEX (user_id),
  GIN INDEX (metadata)  -- For JSONB queries on mentions, tags
);
```

**JSONB Metadata Examples**:
```json
{
  "mentions": ["user_id_1", "user_id_2"],  -- @mentions in future
  "attachments": [
    {
      "id": "att_123",
      "filename": "proposal.pdf",
      "url": "s3://bucket/..."
    }
  ],
  "tags": ["urgent", "follow-up"],
  "sentiment": "positive"  -- Future: ML sentiment analysis
}
```

#### PIPELINE_STAGES
```sql
CREATE TABLE pipeline_stages (
  id BIGINT PRIMARY KEY,
  user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  name VARCHAR(100) NOT NULL,
  position INT NOT NULL DEFAULT 0,
  created_at TIMESTAMP NOT NULL,
  UNIQUE (user_id, name),
  INDEX (user_id, position)
);
```

#### CLIENT_PIPELINE
```sql
CREATE TABLE client_pipeline (
  id BIGINT PRIMARY KEY,
  client_id BIGINT NOT NULL REFERENCES clients(id) ON DELETE CASCADE,
  pipeline_stage_id BIGINT NOT NULL REFERENCES pipeline_stages(id) ON DELETE CASCADE,
  entered_at TIMESTAMP NOT NULL DEFAULT NOW(),
  created_at TIMESTAMP NOT NULL,
  UNIQUE (client_id, pipeline_stage_id),
  INDEX (pipeline_stage_id, entered_at),
  INDEX (client_id)
);
```

#### ACTIVITY_LOGS
```sql
CREATE TABLE activity_logs (
  id BIGINT PRIMARY KEY,
  user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  client_id BIGINT REFERENCES clients(id) ON DELETE SET NULL,
  action_type VARCHAR(50) NOT NULL,
  details JSONB,
  created_at TIMESTAMP NOT NULL,
  INDEX (user_id, created_at),
  INDEX (client_id, created_at)
);
```

### Indexing Strategy

| Table | Index | Purpose |
|-------|-------|---------|
| `clients` | (user_id, status) | Fast filtering by user and status |
| `clients` | (user_id, archived_at) | Soft-delete queries |
| `bookings` | (user_id, starts_at) | Calendar view queries by user and date |
| `bookings` | (client_id, starts_at) | Client-specific calendar queries, overlap detection |
| `pipeline_stages` | (user_id, position) | Kanban board order |
| `activity_logs` | (user_id, created_at) | Audit trail for user |

### Data Integrity Constraints

- All foreign keys cascade on delete (soft deletes for clients via `archived_at`)
- Unique constraints on (user_id, name) for tags and pipeline stages (per-user customization)
- Check constraints on enum fields (status, action_type)
- NOT NULL constraints on required fields (email, first_name, last_name)
- Timezone stored as IANA identifier for DST handling

---

## API Specifications

### Base URL
```
Development: http://localhost:3000/api/v1
Production: https://api.honeybook-clone.com/api/v1
```

### Authentication
All endpoints (except `/auth/register`, `/auth/login`, `/health`) require:
```
Authorization: Bearer <JWT_TOKEN>
Content-Type: application/json
```

JWT tokens expire after 24 hours. Refresh logic handled client-side with logout redirect.

### Common Response Format
```json
{
  "data": { /* resource data */ },
  "errors": [{ "code": "ERROR_CODE", "message": "..." }],
  "meta": { "page": 1, "total": 100 }
}
```

---

### Authentication Endpoints

#### POST /auth/register
Create new user account
```
Request:
{
  "email": "sarah@example.com",
  "password": "SecurePass123",
  "first_name": "Sarah",
  "last_name": "Chen",
  "company_name": "Chen Photography"
}

Response (201 Created):
{
  "data": {
    "id": "usr_123",
    "email": "sarah@example.com",
    "token": "eyJhbGc..."
  }
}
```

#### POST /auth/login
Authenticate with email/password
```
Request:
{
  "email": "sarah@example.com",
  "password": "SecurePass123"
}

Response (200 OK):
{
  "data": {
    "id": "usr_123",
    "email": "sarah@example.com",
    "token": "eyJhbGc...",
    "expires_in": 86400
  }
}
```

#### POST /auth/google
Authenticate with Google OAuth token
```
Request:
{
  "google_token": "ya29.a0AfH..."
}

Response (200 OK):
{
  "data": {
    "id": "usr_124",
    "email": "marcus@example.com",
    "token": "eyJhbGc...",
    "is_new_user": true
  }
}
```

#### POST /auth/logout
Invalidate session
```
Response (204 No Content)
```

---

### Clients Endpoints

#### GET /clients
List all clients with pagination
```
Query Params:
- page (default: 1)
- per_page (default: 20, max: 100)
- status (active|inactive|archived)
- search (name, email, phone, company)
- sort (created_at, last_contact_date, name)
- sort_dir (asc|desc)

Response (200 OK):
{
  "data": [
    {
      "id": "cli_123",
      "first_name": "John",
      "last_name": "Doe",
      "email": "john@example.com",
      "phone": "+1-555-0123",
      "company": "Acme Corp",
      "status": "active",
      "last_contact_date": "2026-01-20",
      "tags": [{"id": "tag_1", "name": "wedding"}],
      "created_at": "2025-12-01T10:00:00Z"
    }
  ],
  "meta": {
    "page": 1,
    "per_page": 20,
    "total": 150,
    "total_pages": 8
  }
}
```

#### POST /clients
Create new client
```
Request:
{
  "first_name": "Jane",
  "last_name": "Smith",
  "email": "jane@example.com",
  "phone": "+1-555-0456",
  "company": "Smith Events",
  "notes": "Referred by Sarah",
  "tag_ids": ["tag_1", "tag_2"]
}

Response (201 Created):
{
  "data": {
    "id": "cli_124",
    "first_name": "Jane",
    ...
    "created_at": "2026-01-24T14:30:00Z"
  }
}
```

#### GET /clients/:id
Get single client with full details
```
Response (200 OK):
{
  "data": {
    "id": "cli_123",
    "first_name": "John",
    "last_name": "Doe",
    ...,
    "bookings": [
      {
        "id": "bk_1",
        "title": "Portrait Session",
        "starts_at": "2026-02-15T14:00:00Z"
      }
    ],
    "activity_log": [
      {
        "id": "al_1",
        "action_type": "created",
        "created_at": "2025-12-01T10:00:00Z"
      }
    ]
  }
}
```

#### PATCH /clients/:id
Update client details
```
Request:
{
  "first_name": "Jane",
  "email": "jane.new@example.com",
  "tag_ids": ["tag_1", "tag_3"]
}

Response (200 OK):
{ "data": { ... } }
```

#### DELETE /clients/:id
Archive (soft delete) client
```
Response (204 No Content)
```

#### POST /clients/:id/notes
Add note to client
```
Request:
{
  "content": "Great fit for wedding package!"
}

Response (201 Created):
{
  "data": {
    "id": "note_1",
    "client_id": "cli_123",
    "content": "Great fit...",
    "created_at": "2026-01-24T15:00:00Z"
  }
}
```

---

### Pipeline Endpoints

#### GET /pipeline
Get pipeline with all stages and clients
```
Query Params:
- tag_id (filter by tag)

Response (200 OK):
{
  "data": {
    "stages": [
      {
        "id": "stage_hot",
        "name": "Hot",
        "position": 1,
        "client_count": 5,
        "clients": [
          { "id": "cli_123", "first_name": "John", ... }
        ]
      },
      {
        "id": "stage_warm",
        "name": "Warm",
        "position": 2,
        "clients": []
      }
    ],
    "analytics": {
      "total_leads": 12,
      "conversion_rate": 0.42
    }
  }
}
```

#### PATCH /clients/:id/pipeline
Move client to different pipeline stage
```
Request:
{
  "pipeline_stage_id": "stage_warm"
}

Response (200 OK):
{
  "data": {
    "id": "cli_123",
    "pipeline_stage_id": "stage_warm"
  }
}
```

#### POST /pipeline/bulk-move
Bulk move multiple clients
```
Request:
{
  "client_ids": ["cli_123", "cli_124"],
  "pipeline_stage_id": "stage_warm"
}

Response (200 OK):
{
  "data": {
    "moved_count": 2
  }
}
```

---

### Bookings / Calendar Endpoints

#### GET /bookings
List bookings with optional filters
```
Query Params:
- client_id (filter by client)
- starts_at_from (ISO 8601 datetime)
- starts_at_to (ISO 8601 datetime)
- status (proposed|confirmed|completed|cancelled)

Response (200 OK):
{
  "data": [
    {
      "id": "bk_1",
      "client_id": "cli_123",
      "title": "Engagement Photos",
      "starts_at": "2026-02-15T14:00:00Z",
      "ends_at": "2026-02-15T16:00:00Z",
      "status": "confirmed",
      "google_event_id": "abc123..."
    }
  ]
}
```

#### POST /bookings
Create new booking
```
Request:
{
  "client_id": "cli_123",
  "title": "Engagement Photos",
  "description": "2-hour session at park",
  "starts_at": "2026-02-15T14:00:00Z",
  "ends_at": "2026-02-15T16:00:00Z",
  "status": "proposed"
}

Response (201 Created):
{
  "data": {
    "id": "bk_1",
    "client_id": "cli_123",
    ...,
    "created_at": "2026-01-24T15:00:00Z"
  }
}
```

#### PATCH /bookings/:id
Update booking (reschedule, change status)
```
Request:
{
  "starts_at": "2026-02-20T10:00:00Z",
  "ends_at": "2026-02-20T12:00:00Z",
  "status": "confirmed"
}

Response (200 OK):
{ "data": { ... } }
```

#### DELETE /bookings/:id
Cancel booking
```
Query Params:
- notify_client (true|false, default: true)

Response (204 No Content)
```

#### POST /calendar/sync
Manually trigger Google Calendar sync
```
Response (200 OK):
{
  "data": {
    "synced_bookings": 3,
    "new_events": 1
  }
}
```

---

### CSV Import/Export Endpoints

#### GET /clients/export.csv
Export all clients to CSV
```
Response (200 OK):
CSV with headers: ID, First Name, Last Name, Email, Phone, Company, Tags, Created Date

File download:
Content-Type: text/csv
Content-Disposition: attachment; filename="clients_2026-01-24.csv"
```

#### POST /clients/import
Import clients from CSV
```
Request (multipart/form-data):
- file: <CSV file>

Response (200 OK):
{
  "data": {
    "created": 45,
    "skipped": 3,
    "errors": [
      {
        "row": 5,
        "reason": "Invalid email format"
      }
    ]
  }
}
```

---

### Error Responses

#### 400 Bad Request
```json
{
  "errors": [
    {
      "code": "VALIDATION_ERROR",
      "message": "Email is invalid",
      "field": "email"
    }
  ]
}
```

#### 401 Unauthorized
```json
{
  "errors": [
    {
      "code": "INVALID_TOKEN",
      "message": "JWT token expired or invalid"
    }
  ]
}
```

#### 404 Not Found
```json
{
  "errors": [
    {
      "code": "NOT_FOUND",
      "message": "Client with id cli_999 not found"
    }
  ]
}
```

#### 429 Too Many Requests
```json
{
  "errors": [
    {
      "code": "RATE_LIMIT_EXCEEDED",
      "message": "Rate limit: 1000 requests/hour",
      "retry_after": 3600
    }
  ]
}
```

#### 500 Internal Server Error
```json
{
  "errors": [
    {
      "code": "INTERNAL_ERROR",
      "message": "An unexpected error occurred"
    }
  ]
}
```

---

### Rate Limiting
- **Limit**: 1000 requests per hour per user
- **Headers**: `X-RateLimit-Limit`, `X-RateLimit-Remaining`, `X-RateLimit-Reset`
- **Backoff**: Exponential backoff recommended when approaching limit

---

## Detailed Task Breakdown

### Phase 1: Foundation (Weeks 1-2)

#### Phase 1.1 - Project Setup & Repository (Est. 8 hours total)
| Task ID | Task Description | Est. Hours | Prerequisites | Acceptance Criteria |
|---------|------------------|-----------|---|---|
| 1.1.1 | Create frontend repo (React/TypeScript scaffold with Vite) | 0.5 | None | GitHub repo created, Vite dev server runs |
| 1.1.2 | Create backend repo (Rails API scaffold) | 0.5 | None | Rails API project initialized, bin/dev works |
| 1.1.3 | Setup Docker development environment (frontend, backend, postgres) | 1.5 | 1.1.1, 1.1.2 | docker-compose up runs all services, no errors |
| 1.1.4 | Configure GitHub workflows (lint, test on push) | 1 | 1.1.1, 1.1.2 | CI/CD pipeline triggers on commits |
| 1.1.5 | Setup environment files (.env.example, dev secrets) | 0.5 | 1.1.1, 1.1.2 | .env.example documented, locally works |
| 1.1.6 | Create base README with setup instructions | 1 | All above | New developer can setup in <5 minutes |
| 1.1.7 | Configure Tailwind CSS in frontend | 0.5 | 1.1.1 | Tailwind utility classes available in components |
| 1.1.8 | Setup ESLint + Prettier for code formatting | 1.5 | 1.1.1, 1.1.2 | Linting passes, formatting auto-applied |

#### Phase 1.2 - Authentication: Email/Password (Est. 12 hours total)
| Task ID | Task Description | Est. Hours | Prerequisites | Acceptance Criteria |
|---------|------------------|-----------|---|---|
| 1.2.1 | Setup Rails devise gem + configure for JWT | 1.5 | 1.1.2 | User model created, devise migrations run |
| 1.2.2 | Create JWT token generation/validation service | 1.5 | 1.2.1 | Tokens generate and validate correctly |
| 1.2.3 | Implement `/auth/register` endpoint (Rails) | 1 | 1.2.1, 1.2.2 | POST with email/password creates user |
| 1.2.4 | Implement `/auth/login` endpoint (Rails) | 1 | 1.2.1, 1.2.2 | POST with credentials returns JWT token |
| 1.2.5 | Implement JWT middleware for API auth | 1 | 1.2.2, 1.2.4 | Requests without token rejected with 401 |
| 1.2.6 | Create password reset flow (email link + validation) | 1.5 | 1.2.1, 1.2.3 | Email contains link, clicking resets password |
| 1.2.7 | Setup SendGrid/Mailgun integration for emails | 1 | 1.2.6 | Emails send successfully in dev/prod |
| 1.2.8 | Create RegisterForm component (React) | 1 | 1.1.1, 1.1.7 | Form validates, submits to backend |
| 1.2.9 | Create LoginForm component (React) | 1 | 1.1.1, 1.1.7 | Form submits, stores JWT in memory |
| 1.2.10 | Implement Auth context/provider (React) | 1 | 1.2.8, 1.2.9 | User state persists, accessible to all components |
| 1.2.11 | Create PasswordReset page/form flow (React) | 1 | 1.2.6, 1.1.1 | Form visible, can reset password |
| 1.2.12 | Setup protected routes (PrivateRoute wrapper) | 1 | 1.2.10 | Unauthenticated users redirected to login |

#### Phase 1.3 - Google OAuth Integration (Est. 10 hours total)
| Task ID | Task Description | Est. Hours | Prerequisites | Acceptance Criteria |
|---------|------------------|-----------|---|---|
| 1.3.1 | Register Google OAuth app, obtain credentials | 0.5 | None | Client ID and Secret in .env |
| 1.3.2 | Setup OmniAuth gem in Rails for Google | 1.5 | 1.3.1 | OmniAuth middleware configured |
| 1.3.3 | Create `/auth/google` endpoint (callback) | 1.5 | 1.3.2, 1.2.1 | OAuth callback creates/finds user |
| 1.3.4 | Update User model to support oauth fields | 0.5 | 1.3.3 | oauth_provider and oauth_uid columns |
| 1.3.5 | Implement GoogleSignIn button component (React) | 1 | 1.1.1, 1.3.1 | Button visible on login page |
| 1.3.6 | Integrate google-auth-library-react in frontend | 1 | 1.3.1, 1.3.5 | Library loads, button functional |
| 1.3.7 | Handle OAuth token exchange (frontend) | 1 | 1.3.6, 1.3.3 | Token sent to backend, JWT returned |
| 1.3.8 | Test OAuth flow end-to-end (dev) | 1.5 | All 1.3 | Can sign in with Google, JWT obtained |
| 1.3.9 | Link existing email users to Google accounts | 1 | 1.3.3 | User can connect Google to existing account |

#### Phase 1.4 - Base UI Components (Est. 10 hours total)
| Task ID | Task Description | Est. Hours | Prerequisites | Acceptance Criteria |
|---------|------------------|-----------|---|---|
| 1.4.1 | Create MainLayout component (Navbar + Sidebar) | 1.5 | 1.1.7, 1.2.10 | Layout renders, sidebar navigable |
| 1.4.2 | Create Navbar with user menu + logout | 1 | 1.4.1 | Logout button visible, functional |
| 1.4.3 | Create Sidebar with navigation links | 1 | 1.4.1 | Links to Clients, Pipeline, Calendar, Settings |
| 1.4.4 | Create reusable Button component | 0.5 | 1.1.7 | Variants: primary, secondary, danger |
| 1.4.5 | Create reusable Form components (Input, Select, TextArea) | 1 | 1.1.7, 1.4.4 | Form fields render with validation |
| 1.4.6 | Create Modal component | 0.75 | 1.1.7 | Modal opens/closes, content visible |
| 1.4.7 | Create Toast notification system | 0.75 | 1.1.7 | Success/error/info notifications display |
| 1.4.8 | Create Loading spinner component | 0.5 | 1.1.7 | Spinner visible during async operations |
| 1.4.9 | Create EmptyState component | 0.5 | 1.1.7 | Used when no data to display |
| 1.4.10 | Create DashboardPage shell | 1 | 1.4.1, 1.4.2 | Protected page shows welcome message |

---

### Phase 2: Client Management (Weeks 3-4)

#### Phase 2.1 - Client Model & API (Est. 8 hours)
| Task ID | Task Description | Est. Hours | Prerequisites | Acceptance Criteria |
|---------|------------------|-----------|---|---|
| 2.1.1 | Create Client model + migration (PostgreSQL) | 1 | 1.1.2 | Schema matches database design section |
| 2.1.2 | Add validations to Client model | 0.5 | 2.1.1 | Required fields validated, email unique per user |
| 2.1.3 | Create ClientsController with CRUD actions | 1.5 | 2.1.1, 1.2.5 | GET, POST, PATCH, DELETE endpoints work |
| 2.1.4 | Implement index endpoint with pagination/search | 1 | 2.1.3 | Pagination works, search filters by name/email/phone |
| 2.1.5 | Implement show endpoint | 0.5 | 2.1.3 | Returns full client with associated data |
| 2.1.6 | Implement create endpoint | 0.5 | 2.1.3 | POST creates client, returns 201 |
| 2.1.7 | Implement update endpoint | 0.5 | 2.1.3 | PATCH updates fields, returns 200 |
| 2.1.8 | Implement destroy endpoint (soft delete) | 0.5 | 2.1.3 | DELETE archives client (archived_at set) |
| 2.1.9 | Create ClientSerializer for JSON responses | 1 | 2.1.3 | API responses formatted consistently |

#### Phase 2.2 - Client Frontend Pages (Est. 10 hours)
| Task ID | Task Description | Est. Hours | Prerequisites | Acceptance Criteria |
|---------|------------------|-----------|---|---|
| 2.2.1 | Create ClientsPage (list view) | 1.5 | 1.4.10, 2.1.3 | Page fetches and displays clients |
| 2.2.2 | Implement client list table with sorting | 1.5 | 2.2.1 | Columns: name, email, company, last_contact |
| 2.2.3 | Add SearchBar component (real-time filtering) | 1 | 2.2.1 | Search debounced, filters results |
| 2.2.4 | Add status filter dropdown | 0.5 | 2.2.1 | Filter by active/inactive/archived |
| 2.2.5 | Create ClientForm component (create/edit) | 1.5 | 1.4.5, 1.4.6 | Form has all required fields |
| 2.2.6 | Add ClientForm to modal for creation | 1 | 2.2.5, 1.4.6 | "Create Client" button opens modal |
| 2.2.7 | Create ClientDetail page | 1.5 | 2.2.1, 2.1.5 | Shows full client info, tabs for notes/bookings |
| 2.2.8 | Implement edit functionality in ClientDetail | 1 | 2.2.7, 2.2.5 | Edit button opens form, updates on submit |
| 2.2.9 | Add pagination controls to ClientsPage | 0.75 | 2.2.1 | Pagination buttons work, page param updates |
| 2.2.10 | Implement delete/archive from ClientDetail | 0.75 | 2.2.7, 2.1.8 | Delete button archives client, redirects |

#### Phase 2.3 - Tags System (Est. 6 hours)
| Task ID | Task Description | Est. Hours | Prerequisites | Acceptance Criteria |
|---------|------------------|-----------|---|---|
| 2.3.1 | Create Tag model + ClientTag join table | 1 | 2.1.1 | Schema matches database design |
| 2.3.2 | Add tag association to Client model | 0.5 | 2.3.1 | Client has_many :tags relationship |
| 2.3.3 | Create TagsController (CRUD) | 1 | 2.3.1 | Endpoints for create, list, delete tags |
| 2.3.4 | Update ClientsController to handle tag_ids | 0.5 | 2.3.1, 2.1.3 | Tags can be assigned on client create/update |
| 2.3.5 | Create TagSelector component (multi-select) | 1.5 | 2.2.5, 1.4.5 | Dropdown shows available tags, multi-select works |
| 2.3.6 | Display tags on client cards and detail page | 0.75 | 2.3.5, 2.2.2 | Tags visible as colored badges |

#### Phase 2.4 - Notes & Activity Log (Est. 8 hours)
| Task ID | Task Description | Est. Hours | Prerequisites | Acceptance Criteria |
|---------|------------------|-----------|---|---|
| 2.4.1 | Create ClientNote model + migration | 1 | 2.1.1 | Schema matches database design |
| 2.4.2 | Create ActivityLog model + migration | 1 | 2.1.1 | Tracks client changes, notes, bookings |
| 2.4.3 | Create ClientNotesController | 1 | 2.4.1 | POST /clients/:id/notes creates note |
| 2.4.4 | Implement automatic activity log on client changes | 1 | 2.4.2, 2.1.3 | Changes logged automatically |
| 2.4.5 | Create ActivityLog endpoint | 0.5 | 2.4.2 | GET /clients/:id/activity returns log |
| 2.4.6 | Create NotesList component | 1 | 2.4.1 | Displays notes with timestamps |
| 2.4.7 | Create ActivityTimeline component | 1 | 2.4.2 | Shows all activities chronologically |
| 2.4.8 | Add "Add Note" form to ClientDetail | 0.75 | 2.4.6, 2.2.7 | Form submits, note appears immediately |

#### Phase 2.5 - CSV Import/Export (Est. 8 hours)
| Task ID | Task Description | Est. Hours | Prerequisites | Acceptance Criteria |
|---------|------------------|-----------|---|---|
| 2.5.1 | Create CSV export endpoint in Rails | 1.5 | 2.1.3 | GET /clients/export.csv downloads file |
| 2.5.2 | Implement CSV parser service (validation) | 1.5 | 2.5.1 | Service validates rows, returns errors |
| 2.5.3 | Create CSV import endpoint | 1 | 2.5.2, 2.1.3 | POST /clients/import accepts CSV |
| 2.5.4 | Handle duplicate detection on import | 1 | 2.5.3 | Duplicates skipped with warnings |
| 2.5.5 | Create "Export Clients" button in ClientsPage | 0.5 | 2.5.1, 2.2.1 | Button triggers download |
| 2.5.6 | Create "Import Clients" button with file picker | 1 | 2.5.3, 2.2.1 | Button opens file input, submits to API |
| 2.5.7 | Show import results modal | 1 | 2.5.6 | Modal displays success/error counts |

---

### Phase 3: Lead Pipeline (Weeks 5-6)

#### Phase 3.1 - Pipeline Model & Backend (Est. 7 hours)
| Task ID | Task Description | Est. Hours | Prerequisites | Acceptance Criteria |
|---------|------------------|-----------|---|---|
| 3.1.1 | Create PipelineStage model + migration | 1 | 1.1.2 | Schema matches, default Hot/Warm/Cold stages |
| 3.1.2 | Create ClientPipeline join model | 1 | 3.1.1, 2.1.1 | Association created, unique per client+stage |
| 3.1.3 | Create PipelinesController | 1.5 | 3.1.1, 3.1.2 | GET returns all stages with clients |
| 3.1.4 | Implement drag-drop endpoint (move client) | 1 | 3.1.2 | PATCH /clients/:id/pipeline updates stage |
| 3.1.5 | Implement bulk-move endpoint | 1 | 3.1.2 | POST /pipeline/bulk-move updates multiple |
| 3.1.6 | Create pipeline analytics service | 1 | 3.1.1 | Calculates counts, conversion rates |

#### Phase 3.2 - Kanban Frontend (Est. 10 hours)
| Task ID | Task Description | Est. Hours | Prerequisites | Acceptance Criteria |
|---------|------------------|-----------|---|---|
| 3.2.1 | Create PipelinePage (Kanban view) | 1 | 1.4.10, 3.1.3 | Page renders with columns |
| 3.2.2 | Create KanbanBoard component | 1.5 | 3.1.3, 1.4.8 | Three columns (Hot, Warm, Cold) render |
| 3.2.3 | Create PipelineCard component (client card) | 1 | 3.2.2 | Card shows name, company, tags |
| 3.2.4 | Implement drag-and-drop (react-beautiful-dnd) | 2 | 3.2.2, 3.2.3 | Drag card between columns, updates API |
| 3.2.5 | Add pipeline metrics display | 1 | 3.1.6, 3.2.1 | Shows counts per stage, conversion rate |
| 3.2.6 | Implement tag filter for pipeline | 1 | 3.2.1, 2.3.5 | Filter button shows only matching clients |
| 3.2.7 | Add stage customization UI (future: allow custom stages) | 1 | 3.2.1 | UI prepared (MVP: Hot/Warm/Cold hardcoded) |
| 3.2.8 | Implement bulk-move UI (select multiple) | 1 | 3.2.1, 3.1.5 | Checkbox select, bulk action button |
| 3.2.9 | Add loading/error states to Kanban | 0.5 | 3.2.2 | Loading spinner, error messages |
| 3.2.10 | Test drag-drop responsiveness on mobile | 1 | 3.2.4 | Works on touch devices |

---

### Phase 4: Scheduling & Calendar (Weeks 7-9)

#### Phase 4.1 - Bookings Model & API (Est. 8 hours)
| Task ID | Task Description | Est. Hours | Prerequisites | Acceptance Criteria |
|---------|------------------|-----------|---|---|
| 4.1.1 | Create Booking model + migration | 1 | 1.1.2, 2.1.1 | Schema matches database design |
| 4.1.2 | Add validations (prevent past dates, overlap) | 1 | 4.1.1 | Validation prevents invalid bookings |
| 4.1.3 | Create BookingsController with CRUD | 1.5 | 4.1.1, 2.1.3 | GET, POST, PATCH, DELETE work |
| 4.1.4 | Implement date/time filtering for calendar views | 1 | 4.1.3 | Query by date range efficient |
| 4.1.5 | Create BookingSerializer | 0.5 | 4.1.3 | Consistent JSON output |
| 4.1.6 | Implement status transitions (proposed→confirmed→completed) | 0.75 | 4.1.3 | Status updates validated |
| 4.1.7 | Setup timezone handling (user timezone) | 1 | 4.1.1 | Dates stored in UTC, converted to user TZ |

#### Phase 4.2 - Calendar Frontend (Est. 9 hours)
| Task ID | Task Description | Est. Hours | Prerequisites | Acceptance Criteria |
|---------|------------------|-----------|---|---|
| 4.2.1 | Create CalendarPage (main calendar view) | 1 | 1.4.10, 4.1.3 | Page renders calendar |
| 4.2.2 | Integrate React Big Calendar | 1 | 4.2.1 | Calendar widget displays bookings |
| 4.2.3 | Create BookingForm component | 1.5 | 2.2.5, 1.4.6 | Form has client select, date/time picker |
| 4.2.4 | Add "Create Booking" button (modal trigger) | 0.5 | 4.2.3, 1.4.6 | Button opens form |
| 4.2.5 | Implement calendar view modes (month/week/day) | 1.5 | 4.2.2 | View toggle works, view persists |
| 4.2.6 | Add booking detail popover (click event) | 1 | 4.2.2, 4.2.3 | Click shows booking details |
| 4.2.7 | Implement reschedule by dragging | 1 | 4.2.2, 4.1.3 | Drag booking to new time, updates API |
| 4.2.8 | Add cancel booking from detail view | 0.75 | 4.2.6, 4.1.3 | Cancel button with confirmation |
| 4.2.9 | Show client's upcoming bookings in ClientDetail | 0.75 | 2.2.7, 4.1.3 | Bookings tab on client page |

#### Phase 4.3 - Google Calendar Integration (Est. 12 hours)
| Task ID | Task Description | Est. Hours | Prerequisites | Acceptance Criteria |
|---------|------------------|-----------|---|---|
| 4.3.1 | Register Google Calendar API credentials | 0.5 | None | API key/OAuth credentials in .env |
| 4.3.2 | Setup Google Calendar OAuth scopes in Rails | 1 | 4.3.1 | google-api-client gem configured |
| 4.3.3 | Create GoogleCalendarAuth endpoint (backend) | 1.5 | 4.3.2 | POST stores OAuth token for user |
| 4.3.4 | Implement one-way sync (app → Google) | 2 | 4.3.3, 4.1.1 | Booking created → Google Calendar event |
| 4.3.5 | Create sync status endpoint (check connection) | 0.75 | 4.3.3 | GET /calendar/status returns auth status |
| 4.3.6 | Implement two-way sync (polling service) | 2.5 | 4.3.4 | Sidekiq job every 5 min syncs changes |
| 4.3.7 | Create GoogleSignIn button for Calendar page | 1 | 4.3.3, 4.2.1 | Button visible on calendar page |
| 4.3.8 | Handle calendar sync errors gracefully | 1 | 4.3.4, 4.3.6 | Errors logged, user notified |
| 4.3.9 | Create sync status indicator (UI) | 0.5 | 4.3.5, 4.2.1 | "Synced" / "Syncing" / "Error" badge |
| 4.3.10 | Test end-to-end Google Calendar integration | 1 | All 4.3 | Create booking → appears in Google Calendar |

#### Phase 4.4 - Email Reminders (Est. 6 hours)
| Task ID | Task Description | Est. Hours | Prerequisites | Acceptance Criteria |
|---------|------------------|-----------|---|---|
| 4.4.1 | Create email reminder background job | 1 | 1.2.7, 4.1.1 | Sidekiq job sends emails 24hrs before |
| 4.4.2 | Create email template for reminders | 0.5 | 4.4.1 | Template includes booking details, client |
| 4.4.3 | Schedule reminder job via Sidekiq | 1 | 4.4.1 | Job scheduled at booking creation |
| 4.4.4 | Test email delivery | 1 | 4.4.1 | Email sent 24hrs before booking |
| 4.4.5 | Add reminder settings to user preferences | 1 | 4.4.1 | User can toggle reminders on/off |
| 4.4.6 | Create email log for debugging | 0.75 | 4.4.1 | Emails tracked in database |

---

### Phase 5: Polish & Launch (Weeks 10-12)

#### Phase 5.1 - UI/UX Polish (Est. 10 hours)
| Task ID | Task Description | Est. Hours | Prerequisites | Acceptance Criteria |
|---------|------------------|-----------|---|---|
| 5.1.1 | Mobile responsiveness audit (375px to 1920px) | 1.5 | All UI components | No horizontal scroll, readable on all sizes |
| 5.1.2 | Fix form UX (error messages, validation feedback) | 1 | All forms | Clear error text, field highlighting |
| 5.1.3 | Add loading states to all async operations | 1 | All API calls | Spinners/skeletons during fetch |
| 5.1.4 | Optimize image/asset loading | 1 | All UI | Images lazy-loaded, optimized |
| 5.1.5 | Add dark mode toggle (optional) | 1.5 | 1.4.1 | Toggle switches theme, persists |
| 5.1.6 | Create empty state screens with CTAs | 1 | All pages | "No clients" → "Create one" button |
| 5.1.7 | Design onboarding flow for new users | 1.5 | 1.4.10 | Welcome screens guide user setup |
| 5.1.8 | Add analytics tracking (Segment/GA) | 1 | All pages | Key events tracked |

#### Phase 5.2 - Security & Compliance (Est. 8 hours)
| Task ID | Task Description | Est. Hours | Prerequisites | Acceptance Criteria |
|---------|------------------|-----------|---|---|
| 5.2.1 | HTTPS everywhere (force HTTPS in production) | 0.5 | Infrastructure | All traffic encrypted |
| 5.2.2 | GDPR: Implement data export endpoint | 1.5 | 2.1.3 | POST /users/export returns all user data |
| 5.2.3 | GDPR: Implement account deletion (hard delete) | 1.5 | 2.1.3 | DELETE /users/account deletes all user data |
| 5.2.4 | Password security audit | 0.75 | 1.2.1 | Bcrypt cost >10, no weak passwords allowed |
| 5.2.5 | SQL injection audit (Rails parameterization) | 0.75 | All models | All queries use parameterized |
| 5.2.6 | CORS configuration lockdown | 1 | Backend | Only whitelisted origins allowed |
| 5.2.7 | Add security headers (CSP, X-Frame-Options, etc.) | 1 | Backend | Headers configured in Rails |
| 5.2.8 | Audit sensitive data in logs (no passwords/tokens) | 0.75 | All logging | No PII in logs |

#### Phase 5.3 - Performance Optimization (Est. 8 hours)
| Task ID | Task Description | Est. Hours | Prerequisites | Acceptance Criteria |
|---------|------------------|-----------|---|---|
| 5.3.1 | Analyze bundle size (frontend) | 0.75 | All components | Tree-shake unused code |
| 5.3.2 | Code splitting (lazy load routes) | 1 | 1.1.1 | Route components load on demand |
| 5.3.3 | Database query optimization (N+1 issues) | 1.5 | All models | Eager loading configured |
| 5.3.4 | Redis caching for frequently accessed data | 1.5 | Backend | Session data + pagination cached |
| 5.3.5 | Implement pagination on all list endpoints | 1 | All list endpoints | Pagination default 20/page |
| 5.3.6 | Database index audit | 1 | Database schema | All indexed appropriately |
| 5.3.7 | API response time logging | 0.75 | Backend | Slow queries identified |
| 5.3.8 | Test page load time (<2s target) | 0.75 | All components | Lighthouse score >80 |

#### Phase 5.4 - Testing & QA (Est. 12 hours)
| Task ID | Task Description | Est. Hours | Prerequisites | Acceptance Criteria |
|---------|------------------|-----------|---|---|
| 5.4.1 | Write unit tests for utilities (60% coverage) | 2 | All utils | Tests pass, coverage >60% |
| 5.4.2 | Write integration tests for auth flow | 1.5 | 1.2.3-1.3.9 | Auth endpoints tested end-to-end |
| 5.4.3 | Write integration tests for client CRUD | 1.5 | 2.1.3 | CRUD operations tested |
| 5.4.4 | Write React component tests (30% coverage) | 2 | All components | Snapshot + interaction tests |
| 5.4.5 | E2E test critical flows (Cypress) | 2 | All features | Login → Create client → Pipeline → Calendar |
| 5.4.6 | Manual browser testing (cross-browser) | 1 | All UI | Chrome, Firefox, Safari, Edge tested |
| 5.4.7 | Manual mobile testing (iOS + Android) | 1 | All UI | Responsive, touch-friendly |
| 5.4.8 | Accessibility testing (WCAG 2.1 AA) | 1 | All UI | Axe scan passes, keyboard navigation |

#### Phase 5.5 - Documentation & Deployment (Est. 8 hours)
| Task ID | Task Description | Est. Hours | Prerequisites | Acceptance Criteria |
|---------|------------------|-----------|---|---|
| 5.5.1 | Write API documentation (OpenAPI/Swagger) | 2 | 4.1.7 | /docs endpoint with schema |
| 5.5.2 | Write user guide (features, workflows) | 1.5 | All features | Guide covers all major flows |
| 5.5.3 | Create setup/deployment guide | 1.5 | Infrastructure | New dev can deploy in <30 min |
| 5.5.4 | Setup production database (backups, monitoring) | 1 | Infrastructure | Daily backups, monitoring alerts |
| 5.5.5 | Create monitoring/alerting (Sentry, DataDog) | 1 | Backend | Errors tracked, alerts configured |
| 5.5.6 | Deploy to staging environment | 0.5 | Infrastructure | Staging mirrors production |
| 5.5.7 | Final production deployment | 0.5 | 5.5.6 | Launched! |

---

### Task Summary by Phase
| Phase | Total Hours | Duration |
|-------|------------|----------|
| Phase 1 (Foundation) | 40 | Weeks 1-2 |
| Phase 2 (Clients) | 40 | Weeks 3-4 |
| Phase 3 (Pipeline) | 17 | Weeks 5-6 |
| Phase 4 (Calendar) | 35 | Weeks 7-9 |
| Phase 5 (Polish) | 46 | Weeks 10-12 |
| **TOTAL** | **178 hours** | **12 weeks** |

**Note**: ~15 hrs/week solo + AI acceleration (Claude Code primary). Buffer 20% (~36 hours) for iterations, debugging, and unforeseen complexity.

---

## Testing Strategy

### Testing Pyramid

```
        /\
       /E2E\      (5-10% of tests)
      /      \    3-5 critical user flows
     /________\
    /          \
   /  Integration\ (20-30% of tests)
  /              \ API endpoints, service interactions
 /________________\
/                  \
   Unit Tests       (60-70% of tests)
    Utilities,      Helper functions, validators
   Serializers      Business logic
```

### Unit Testing (Backend - Rails)

**Framework**: RSpec + Factory Bot
**Target Coverage**: >70% for critical paths

**Test Files Location**: `spec/`

| Component | Test Focus | Example |
|-----------|-----------|---------|
| Models | Validations, associations, scopes | `user_spec.rb`: test email uniqueness, password requirements |
| Services | Business logic, edge cases | `csv_import_service_spec.rb`: test duplicate detection, validation |
| Serializers | JSON output format | `client_serializer_spec.rb`: verify fields, nested data |
| Validators | Custom validation logic | `booking_validator_spec.rb`: prevent overlapping bookings |

**Example Test**:
```ruby
# spec/models/client_spec.rb
describe Client do
  describe 'validations' do
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).scoped_to(:user_id) }
  end

  describe 'associations' do
    it { should belong_to(:user) }
    it { should have_many(:bookings).dependent(:destroy) }
    it { should have_many(:tags).through(:client_tags) }
  end
end
```

### Unit Testing (Frontend - React)

**Framework**: Vitest + React Testing Library
**Target Coverage**: >50% for components

**Test Files Location**: `src/__tests__/`

| Component | Test Focus | Example |
|-----------|-----------|---------|
| Hooks | State logic, side effects | `useAuth.test.ts`: test login, logout, token refresh |
| Utils | Pure functions | `dateUtils.test.ts`: timezone conversion, formatting |
| Services | API call mocking | `clientService.test.ts`: mock Axios, verify endpoints |
| Components | Snapshots, user interactions | `ClientForm.test.tsx`: form submission, validation |

**Example Test**:
```typescript
// src/__tests__/hooks/useAuth.test.ts
import { renderHook, act } from '@testing-library/react';
import { useAuth } from '../hooks/useAuth';

describe('useAuth', () => {
  it('should login successfully', async () => {
    const { result } = renderHook(() => useAuth());

    await act(async () => {
      await result.current.login('user@example.com', 'password123');
    });

    expect(result.current.isAuthenticated).toBe(true);
    expect(result.current.user.email).toBe('user@example.com');
  });
});
```

### Integration Testing (API Endpoints)

**Framework**: RSpec + request specs
**Test Files Location**: `spec/requests/`

| Endpoint | Test Focus | Scenarios |
|----------|-----------|-----------|
| Auth | Login, register, OAuth, token refresh | Valid/invalid credentials, expired tokens |
| Clients | CRUD operations, pagination, search | Create duplicate, archive, filter by status |
| Pipeline | Stage transitions, bulk operations | Move multiple clients, filter by tag |
| Bookings | Create, reschedule, calendar sync | Overlapping bookings, timezone handling |

**Example Test**:
```ruby
# spec/requests/api/v1/clients_controller_spec.rb
describe 'POST /api/v1/clients' do
  let(:user) { create(:user) }
  let(:headers) { { 'Authorization' => "Bearer #{user.token}" } }

  it 'creates a client' do
    expect {
      post '/api/v1/clients',
        params: { client: attributes_for(:client) },
        headers: headers
    }.to change(Client, :count).by(1)

    expect(response).to have_http_status(:created)
  end

  it 'returns validation errors' do
    post '/api/v1/clients',
      params: { client: { email: 'invalid' } },
      headers: headers

    expect(response).to have_http_status(:unprocessable_entity)
    expect(json['errors']).to include('email')
  end
end
```

### End-to-End Testing (Critical User Flows)

**Framework**: Cypress or Playwright
**Test Files Location**: `e2e/`
**Target Scenarios**: 3-5 critical flows

| Flow | Steps | Expected Outcome |
|------|-------|------------------|
| **Registration & Login** | 1. Register with email 2. Verify email 3. Login | User sees dashboard, can create client |
| **Create Client** | 1. Login 2. Click "Create Client" 3. Fill form 4. Submit | Client appears in list, notification shows |
| **Pipeline Management** | 1. Login 2. View pipeline 3. Drag client 4. See status update | Client moved to new stage, persists on refresh |
| **Calendar Booking** | 1. Login 2. Create booking 3. Sync to Google Calendar | Booking appears in both app and Google Calendar |
| **CSV Import** | 1. Export clients 2. Modify CSV 3. Import | Clients created with correct data |

**Example Test**:
```typescript
// e2e/auth.spec.ts
import { test, expect } from '@playwright/test';

test('user can register and login', async ({ page }) => {
  // Register
  await page.goto('/register');
  await page.fill('input[name="email"]', 'test@example.com');
  await page.fill('input[name="password"]', 'SecurePass123');
  await page.click('button[type="submit"]');

  // Verify email (skip in test)
  await page.goto('/verify?email=test@example.com');
  await page.click('button:has-text("Verify")');

  // Login
  await page.goto('/login');
  await page.fill('input[name="email"]', 'test@example.com');
  await page.fill('input[name="password"]', 'SecurePass123');
  await page.click('button[type="submit"]');

  // Should see dashboard
  await expect(page).toHaveURL('/dashboard');
});
```

### Performance Testing

| Metric | Target | Tool |
|--------|--------|------|
| Page Load (<2s) | First Contentful Paint | Lighthouse, WebPageTest |
| API Response (<200ms) | GET /clients | Postman, custom benchmark |
| Bundle Size | <400KB gzip | Webpack Bundle Analyzer |
| Database Query (<100ms) | Complex queries with joins | ActiveRecord logging, pgBadger |

### Security Testing

| Test | Method | Tool |
|------|--------|------|
| SQL Injection | Input fuzzing | SQLMap, manual testing |
| XSS Prevention | Script injection attempts | Burp Suite, browser console |
| CSRF Protection | Form submission verification | Check CSRF token headers |
| Auth Bypass | Token manipulation | JWT debugger, Postman |
| Rate Limiting | 1000 req/hour enforcement | Apache Bench (ab), k6 |

### Accessibility Testing (WCAG 2.1 AA)

| Test | Tool | Criteria |
|------|------|----------|
| Automated scanning | axe DevTools, Lighthouse | >95 score |
| Keyboard navigation | Manual testing | All buttons/links accessible via Tab |
| Screen reader testing | NVDA (Windows), VoiceOver (Mac) | Proper ARIA labels |
| Color contrast | WebAIM Contrast Checker | >4.5:1 ratio |
| Mobile accessibility | iOS/Android screen readers | Touch-friendly interactions |

**Checklist**:
- [ ] All form inputs have associated labels
- [ ] Images have alt text
- [ ] Color not sole means of conveying info
- [ ] Focus indicators visible on all interactive elements
- [ ] Keyboard shortcuts documented

### Continuous Integration (GitHub Actions)

**On Push**:
```yaml
- Lint (ESLint, RuboCop)
- Unit tests (jest, rspec)
- Integration tests (rspec request)
- Build artifact (frontend bundle)
- Security scan (Dependabot, CodeQL)
```

**On Pull Request**:
```yaml
- All above checks
- Coverage report (>60% for backend, >50% for frontend)
- Approval required before merge
```

**Before Deployment**:
```yaml
- E2E tests on staging
- Performance audit (Lighthouse)
- Security audit (OWASP)
```

### Test Data & Fixtures

**Factories** (Factory Bot):
```ruby
# spec/factories/user_factory.rb
FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { 'SecurePass123' }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    confirmed_at { Time.current }
  end
end
```

**Seeds** (for manual testing):
```ruby
# db/seeds.rb (development only)
user = User.create!(email: 'test@example.com', password: 'test123')
10.times do |i|
  Client.create!(
    user: user,
    first_name: Faker::Name.first_name,
    email: Faker::Internet.email,
    status: ['active', 'inactive'].sample
  )
end
```

### Coverage Goals
- **Backend (Rails)**: Minimum 70% line coverage
  - Models: 80%+
  - Controllers: 60%+
  - Services: 80%+
- **Frontend (React)**: Minimum 50% line coverage
  - Hooks: 70%+
  - Utils: 80%+
  - Components: 40%+
- **E2E**: 3 critical paths covered, 95%+ pass rate

### Validation Checkpoints

| Week | Test Focus | Pass Criteria |
|------|-----------|---------------|
| Week 2 | Auth flows (login, register, logout) | All tests pass, 70% coverage |
| Week 4 | Client CRUD operations | All tests pass, 70% coverage |
| Week 6 | Pipeline drag-drop, filtering | All tests pass, UI responsive |
| Week 9 | Calendar sync, email reminders | E2E test passes, sync verified |
| Week 12 | Full regression + E2E | 95%+ pass rate, no critical bugs |

---

## Deployment Plan

### Infrastructure Architecture

```
┌─────────────────────────────────────────────────────┐
│              Cloudflare (CDN + DNS)                 │
│  Distributed caching, DDoS protection               │
└────────────────────┬────────────────────────────────┘
                     │
     ┌───────────────┼───────────────┐
     ↓               ↓               ↓
┌──────────┐  ┌──────────┐  ┌──────────┐
│  US East │  │ EU West  │  │ Asia Pac │
│ Region   │  │ Region   │  │ Region   │
└────┬─────┘  └────┬─────┘  └────┬─────┘
     │             │             │
     └─────────────┼─────────────┘
                   ↓
         ┌─────────────────────┐
         │  Load Balancer      │
         │  (Heroku/Railway)   │
         └──────────┬──────────┘
                    │
     ┌──────────────┼──────────────┐
     ↓              ↓              ↓
┌─────────┐   ┌─────────┐   ┌─────────┐
│ Backend │   │ Backend │   │ Backend │
│ Server 1│   │ Server 2│   │ Server 3│
└────┬────┘   └────┬────┘   └────┬────┘
     │             │             │
     └─────────────┼─────────────┘
                   ↓
         ┌─────────────────────┐
         │   PostgreSQL DB     │
         │   Primary + Replica │
         └─────────────────────┘

         ┌─────────────────────┐
         │     Redis Cache     │
         │   (Session Storage) │
         └─────────────────────┘

         ┌─────────────────────┐
         │   S3 (Backups)      │
         │   Daily Snapshots   │
         └─────────────────────┘
```

### Hosting Options (Recommended for MVP)

#### Option A: Railway.app (Recommended)
**Pros**: Git-integrated, PostgreSQL included, simple scaling
**Cons**: Limited customization
**Cost**: ~$50-150/month for MVP

```yaml
# railway.toml
[build]
builder = "dockerfile"

[deploy]
healthcheckPath = "/health"
restartPolicyType = "on_failure"
```

#### Option B: Heroku
**Pros**: Easy deployment, managed PostgreSQL
**Cons**: Higher costs, less control
**Cost**: ~$100-200/month

#### Option C: AWS EC2 + RDS
**Pros**: Full control, scalable
**Cons**: Higher complexity, operational overhead
**Cost**: ~$50-100/month for MVP

### Deployment Process

#### Pre-Deployment Checklist
- [ ] All tests passing (backend + frontend)
- [ ] Security audit completed (OWASP top 10)
- [ ] Performance benchmarks met (<2s load time)
- [ ] Code review approval
- [ ] Environment variables configured
- [ ] Database migrations tested
- [ ] Backups scheduled
- [ ] Monitoring alerts configured

#### Staging Deployment (Railway/Heroku)

**Step 1: Build and Test**
```bash
# Frontend build
npm run build  # Creates optimized bundle
npm run preview  # Test production build locally

# Backend tests
bundle exec rspec  # Run all tests
bundle exec rubocop  # Lint checks
```

**Step 2: Deploy to Staging**
```bash
# Via Git (automatic if configured)
git push staging main

# Or manual deployment
railway deploy --stage staging
# OR
git push heroku-staging main
```

**Step 3: Smoke Tests**
```bash
# Verify staging endpoints
curl https://staging-api.example.com/health
# Should return: {"status": "ok", "version": "1.0.0"}

# Test critical flow
- Login with test user
- Create test client
- Verify in pipeline
```

**Step 4: Database Migrations**
```bash
# SSH into staging
railway shell
# OR
heroku run bash --remote staging

# Run migrations
rails db:migrate
rails db:seed:staging  # Load test data

# Verify schema
rails db:schema:dump
```

#### Production Deployment

**Release Process** (Friday afternoons, with team present):

```bash
# 1. Create release branch
git checkout -b release/v1.0.0

# 2. Bump version
# Edit config/initializers/version.rb
# Update CHANGELOG.md

# 3. Tag release
git tag -a v1.0.0 -m "Release v1.0.0"
git push origin v1.0.0

# 4. Build and deploy
npm run build
git push production main  # Triggers deployment

# 5. Verify production
curl https://api.example.com/health
# Smoke tests:
# - Login flow
# - Create client
# - Pipeline operations
# - Calendar sync

# 6. Monitor
# Check Sentry for errors
# Check DataDog/New Relic for performance
# Monitor database logs
```

**Rollback Procedure** (if critical issue):
```bash
# Quick rollback to previous version
railway redeploy <previous-deployment-id>
# OR
git revert <commit-hash>
git push production main
```

### Database Management

#### Migrations Strategy
```ruby
# db/migrate/[timestamp]_create_clients.rb
class CreateClients < ActiveRecord::Migration[7.0]
  def change
    create_table :clients do |t|
      t.references :user, null: false, foreign_key: true
      t.string :first_name, null: false
      t.string :email
      t.timestamps
    end

    add_index :clients, [:user_id, :created_at]
  end
end
```

**Deployment Steps**:
```bash
# Test migration locally
rails db:migrate RAILS_ENV=test
rails db:rollback

# Deploy with migration
bin/deploy
  # Runs migrations automatically
  # Verifies rollback capability

# Monitor migration on production
rails db:migrate RAILS_ENV=production
# Check: no long locks, no data loss
```

#### Backup Strategy

**Daily Automated Backups**:
```bash
# PostgreSQL backup via pg_dump
0 2 * * * pg_dump -h $DB_HOST -U $DB_USER $DB_NAME | gzip > /backups/db_$(date +%Y%m%d).sql.gz

# Upload to S3
aws s3 cp /backups/db_*.sql.gz s3://honey-book-backups/daily/

# Retention: Keep 30-day rolling window
```

**Recovery Procedure**:
```bash
# Restore from backup
gunzip < /backups/db_20260115.sql.gz | psql -h $DB_HOST -U $DB_USER $DB_NAME

# Verify restore
SELECT COUNT(*) FROM users;
SELECT COUNT(*) FROM clients;

# Validate data integrity
rails console
> User.count  # Should match backup
```

#### Connection Pooling
```yaml
# config/database.yml (production)
pool: 20  # Number of DB connections
timeout: 5000  # 5 second timeout
```

### Frontend Deployment (CDN)

**Build Process**:
```bash
# Production optimized build
npm run build
# Output: dist/

# Analyze bundle
npm run analyze  # Check for large dependencies

# Preview before deploy
npm run preview
```

**Deploy to Cloudflare Pages**:
```bash
# Connect GitHub repo to Cloudflare Pages
# Build command: npm run build
# Build output directory: dist

# Automatic deployment on git push
# CDN caches globally
```

**Cache Strategy**:
```
- HTML: Cache-Control: public, max-age=3600  (1 hour)
- JS/CSS: Cache-Control: public, max-age=31536000, immutable  (1 year, versioned)
- Images: Cache-Control: public, max-age=86400  (1 day)
- API responses: Cache-Control: private, max-age=300  (5 min)
```

### Environment Variables

#### Secrets Management
```bash
# Development
.env (local, NOT in git)

# Staging/Production (Railway/Heroku)
# Set via web dashboard or CLI
railway variables set DB_URL postgres://...
railway variables set GOOGLE_CLIENT_ID xxx
railway variables set GOOGLE_CLIENT_SECRET xxx
railway variables set SENDGRID_API_KEY xxx
railway variables set SENTRY_DSN xxx
```

#### Required Variables
```
# Auth
GOOGLE_CLIENT_ID=xxx
GOOGLE_CLIENT_SECRET=xxx
JWT_SECRET=<secure_random_string>

# Email
SENDGRID_API_KEY=xxx
SENDGRID_FROM_EMAIL=noreply@example.com

# Database
DATABASE_URL=postgres://user:pass@host:5432/db

# Monitoring
SENTRY_DSN=https://xxx@sentry.io/xxx
NEW_RELIC_LICENSE_KEY=xxx

# AWS (for backups)
AWS_ACCESS_KEY_ID=xxx
AWS_SECRET_ACCESS_KEY=xxx
AWS_REGION=us-east-1
```

### Monitoring & Observability

#### Error Tracking (Sentry)
```ruby
# config/initializers/sentry.rb
Sentry.init do |config|
  config.dsn = ENV['SENTRY_DSN']
  config.environment = Rails.env
  config.traces_sample_rate = 0.1
  config.release = ENV['APP_VERSION']
end
```

**On Error**:
- Sentry captures stack trace, context, user info
- Slack notification sent to #errors channel
- Alert if error rate >5% in 5 minutes

#### Performance Monitoring (New Relic / DataDog)
```ruby
# config/initializers/new_relic.rb
# Tracks:
# - Response times
# - Database query times
# - Background job performance
# - Memory usage
```

**Dashboards**:
- API response time histogram
- Database query performance
- Error rate trends
- Background job queue length

#### Logging
```ruby
# Log all API requests, errors, important events
Rails.logger.info "Client created: #{client.id}"
Rails.logger.error "Google Calendar sync failed: #{e.message}"

# Structured logging (JSON)
logger.info({ action: 'client.created', client_id: client.id, user_id: user.id }.to_json)
```

### Health Checks

**Endpoint**: `GET /health`
```json
{
  "status": "ok",
  "version": "1.0.0",
  "checks": {
    "database": "ok",
    "redis": "ok",
    "google_api": "ok"
  }
}
```

**Monitoring Every 30 Seconds**:
```bash
# Heroku/Railway built-in health checks
# Or custom monitoring:
curl -f https://api.example.com/health || alert "API down"
```

### Disaster Recovery

| Scenario | RTO | RPO | Procedure |
|----------|-----|-----|-----------|
| Database Corruption | 1 hour | 1 day | Restore from daily backup |
| Server Crash | 10 min | N/A | Kubernetes auto-restart or Heroku redeploy |
| Data Breach | 15 min | N/A | Rotate secrets, force password reset |
| DDoS Attack | 1 min | N/A | Cloudflare automatic mitigation |

### Post-Launch Monitoring

**First Week**:
- Daily check for errors in Sentry
- Monitor database performance
- Check user feedback
- Fix any critical bugs immediately

**Ongoing**:
- Weekly performance review
- Monthly security patches
- Quarterly scaling assessment
- User feedback collection

---

## Marketing & Launch Strategy

### Market Positioning
**Tagline**: "The CRM for creatives who don't have time for CRM"
**Positioning**: A lightweight, affordable alternative to HoneyBook/17hats for solo creative entrepreneurs

**Target Audience**:
- Solo photographers (weddings, portraits, events)
- Event planners and coordinators
- Freelancers (designers, writers, consultants)
- Micro-studios (2-5 people)

### Pre-Launch Phase (Weeks 1-10)

**Content Preparation**:
- [ ] Week 4: Draft 3 comparison blogs ("HoneyBook Alternatives", "Best Free CRM for Photographers", "Why Creatives Need CRM")
- [ ] Week 6: Create 5 case study templates
- [ ] Week 8: Record 3 feature walkthrough videos (YouTube)
- [ ] Week 9: Build landing page with email capture
- [ ] Week 10: Setup social media accounts (Twitter, Instagram, LinkedIn)

### Launch Month Budget & Tactics

**Total Q1 Budget**: ~$10,000
- Months 1-3 post-launch: $3,000/month base + $3,000/month surge = ~$9,000 total

#### Monthly Budget Breakdown ($1,000 base + $3,000 surge)

| Channel | Base/Mo | Surge/Mo | Tactics | Expected Reach |
|---------|---------|----------|---------|-----------------|
| **SEO/Content** | $400 | $1,200 | Blog posts, keyword targeting, internal linking | 500-1000 organic visits/mo |
| **Paid Ads (Google/Meta)** | $300 | $1,000 | Retargeting, competitor keywords, lookalike audiences | 100-300 conversions/mo |
| **Community/Partnerships** | $200 | $500 | Photography forums, creator communities, affiliate partnerships | 50-100 referrals/mo |
| **Email/Organic** | $100 | $300 | Newsletter, Twitter, Product Hunt | 50-200 signups/mo |

**Total**: $1,000/mo base + $3,000/mo surge (Months 1-3) = **~$10,000 Q1 investment**

### Content Marketing Roadmap

#### Blog Content (SEO-focused)
**Target**: 10-15 leads/month from organic search

| Blog Title | Target Keyword | Length | Month | CTA |
|-----------|---------------|--------|-------|-----|
| "5 HoneyBook Alternatives for Photographers" | honeybookalternatives | 2,000 words | Week 11 | Free trial signup |
| "Best CRM for Event Planners" | crm for event planners | 2,000 words | Week 12 | Feature demo |
| "Why Creatives Hate Spreadsheets" | creative crm | 1,500 words | Week 13 | Waitlist |
| "17hats vs Honeybook vs [Our App]" | comparison guide | 2,500 words | Month 2 | Pricing page |
| "Free CRM Tools for Freelancers" | free crm comparison | 2,000 words | Month 2 | Feature overview |

**SEO Strategy**:
- Target long-tail keywords (50-100 search volume)
- Build 30-50 backlinks in Month 1 (creator blogs, directories, forums)
- Internal linking strategy (3-5 internal links per blog)
- Monthly blog: 2 posts/month for 3 months

#### Social Media Strategy

**Twitter/X** (3-5 posts/week, targeting creatives):
- Growth tip threads (photography/event planning related)
- Product launch announcements
- Creator spotlights from user base
- Behind-the-scenes development updates

**Example Posts**:
```
"If you're managing clients in spreadsheets, you're leaving money on the table.
We built a CRM specifically for photographers. No bloat, no $1000/mo price tag.
Try free here: [link]
#PhotographyBusiness #CreativeEntrepreneur"

"Event planners: Stop using email threads to track 50+ conversations.
Pipeline view → Know your leads at a glance → Close more bookings
Beta version is live. DM for access! #EventPlanning"
```

**Instagram** (3-5 posts/week, visual focus):
- Before/after client organization visuals
- Success stories from early users
- Carousel: "5 signs your CRM isn't working for you"
- Reels: 30-60 second feature demos

**LinkedIn** (2-3 posts/week, professional angle):
- Thought leadership on creative business management
- Case studies and metrics
- Recruiting content for future team

### Launch Events & PR

**Week 11 (Pre-launch)**:
- [ ] Product Hunt launch (target: top 10 of day, 200+ upvotes)
- [ ] Launch email to newsletter (if any): "Coming next week..."
- [ ] Influencer outreach: 20 photography/freelance influencers + early access
- [ ] Reddit posts in r/photography, r/freelancers, r/eventplanning (organic)

**Week 12 (Official Launch)**:
- [ ] Twitter thread: Product launch announcement
- [ ] Blog post: "We launched! Here's what we built"
- [ ] Affiliate program announcement: $50 per user signup
- [ ] Beta tester testimonial video/quotes

**Month 2-3**:
- [ ] Guest posts on top 5 photography/freelance blogs
- [ ] Podcast interviews (10 target podcasts, 500-5000 listeners each)
- [ ] Webinar: "The CRM Playbook for Creative Entrepreneurs" (free, lead gen)
- [ ] Case study publication: First 5 paying customers' success stories

### Lead Generation Metrics

**Goal**: 10-50 qualified leads/month by Month 3

| Channel | Lead Source | Volume (Mo 1) | Volume (Mo 3) | Conversion Rate |
|---------|------------|---------|---------|-----------------|
| Organic Search | Blog content | 5-10 | 15-20 | 10-20% |
| Paid Ads | Google/Meta ads | 3-5 | 15-25 | 5-15% |
| Social Media | Twitter/Instagram | 2-5 | 10-15 | 3-10% |
| Communities | Reddit, forums | 2-5 | 5-10 | 20-30% |
| Referrals/Partnerships | Affiliate, word-of-mouth | 1-5 | 10-20 | 25-40% |

**Total Leads**: 13-30 (Month 1) → 55-90 (Month 3)
**Free Trial Conversions**: ~30% (4-9 Month 1, 17-27 Month 3)
**Paid Customers Target**: 5-10 by end Month 3

### Metrics & KPIs

**Track Weekly**:
```
- Website visitors: 100 → 500 → 1000
- Email signups: 10 → 50 → 100+
- Trial signups: 5 → 25 → 50
- Paid customers: 1 → 5 → 10
- Content pieces published: 1 → 5 → 10
```

**Track Monthly**:
- Customer Acquisition Cost (CAC): Target <$100 (SEO-heavy strategy prioritizes organic)
- Lifetime Value (LTV): Estimate $3,000 (assuming $40-50 ARPU, 12+ month retention)
- LTV:CAC Ratio: Target >3:1 (achieve by Month 6 post-launch)
  - Formula: $3,000 LTV / <$100 CAC = 30:1 (stretch goal, 3:1 minimum)
- Content ROI: Leads per blog post (target: 2-5 qualified leads per article)
- Social ROI: Engagement rate, click-through rate (Twitter: 2-5% CTR target)

**Success Metrics at Week 12**:
- [ ] 50+ website visitors/day
- [ ] 10+ trial signups
- [ ] 5+ paid customers (even at discounted rate)
- [ ] 500+ Twitter followers
- [ ] 3-5 blog posts ranking for target keywords
- [ ] 0 churn (all initial customers retained)

### Post-Launch Scaling (Month 4+)

**If metrics on track**:
- Increase marketing budget to $2,000/mo base
- Add paid ads expansion (LinkedIn, YouTube)
- Hire freelance content writer
- Launch affiliate program at scale

**If metrics underperform**:
- Double down on organic/community channels (lower cost)
- Conduct customer interviews (understand product-market fit)
- Iterate on landing page messaging
- Consider feature pivots based on user feedback

---

## Risk Management & Mitigation

### Risk Register

| Risk ID | Risk Description | Probability | Impact | Mitigation Strategy | Owner |
|---------|------------------|-------------|--------|-------------------|-------|
| **R1** | Google API quota limits hit during development | Medium | High | Request quota increase early (Week 1). Design polling sync instead of webhooks. Implement caching to reduce API calls. | Eng Lead |
| **R2** | Calendar sync complexity delays Phase 4 | Medium | High | Start calendar work Week 6 (not Week 7). Build sync service in isolation before UI integration. Spike on integration early. | Eng Lead |
| **R3** | Scope creep from MVP features | High | High | Strictly gate MVP features. Create "Phase 2" backlog for deferred items. Defer Stripe, SMS, advanced analytics. Say "no" to feature requests. | PM |
| **R4** | Mobile UX issues discovered late | Medium | Medium | Test on real mobile devices weekly (not just browser DevTools). Test touch interactions on Kanban. | QA |
| **R5** | Database performance degrades with 500+ clients | Low | High | Add indexes proactively. Monitor query times. Design pagination from start. Load-test Week 8. | Eng Lead |
| **R6** | Google Calendar API deprecates or changes | Low | High | Subscribe to Google API mailing list. Maintain API wrapper service (abstraction layer). Monitor breaking changes. | Eng Lead |
| **R7** | Key team member becomes unavailable | Low | High | Document all decisions in wiki. Pair-program critical features. Cross-train on architecture. | PM |
| **R8** | Authentication system has security vulnerability | Low | Critical | Use battle-tested libraries (Devise, OmniAuth). Conduct security audit Week 10. Follow OWASP guidelines. Use strong JWT secrets. | Sec Lead |
| **R9** | Deployment fails before launch (Week 12) | Medium | Critical | Practice deployments on staging every week. Automate everything (CI/CD pipeline). Maintain rollback procedures. Run deployment drill Week 11. | Eng Lead |
| **R10** | User testing reveals core workflow issues | Medium | High | Conduct UX testing with 3 users Week 6, not Week 12. Validate assumptions early. Be willing to pivot. | PM |

### Risk Monitoring

**Weekly Risk Review**:
- [ ] Review active risks every Monday stand-up
- [ ] Update probability/impact if circumstances change
- [ ] Escalate if risk becoming critical (probability↑ or impact↑)
- [ ] Close risk if mitigation successful

**Red Flags** (immediate escalation):
- Any task overruns by >50% of estimate
- Google API quota exceeded
- Third-party service down (Google, SendGrid)
- Security vulnerability discovered
- Core feature deemed unachievable

### Contingency Plans

#### If Google Calendar Sync Fails
**Fallback**: Manual CSV export of bookings, calendar integration deferred to Phase 2
**Impact**: MVP ships with basic scheduling, no sync
**Timeline Impact**: Save 2-3 weeks, allows more time for polish

#### If Mobile UX Significantly Broken
**Fallback**: Desktop-only MVP, mobile support in Phase 2
**Impact**: Narrows user base, but doesn't break core features
**Timeline Impact**: Save 1 week on responsive design

#### If Database Performance Critical
**Fallback**: Switch to MongoDB for client data (denormalized)
**Impact**: Different querying patterns, some migration effort
**Timeline Impact**: Delay 1 week, but eliminates bottleneck

#### If Stripe Payment Delayed to Post-MVP
**Already Planned**: Payment deferred anyway
**Communication**: Market as "freemium for beta", payment coming soon
**Timeline Impact**: None (already deferred)

---

## Timeline & Milestones

### 12-Week Aggressive Development Timeline

#### Week 1-2: Foundation
**Theme**: Setup, Auth, Database Ready
**Tasks**: 40 hours

| Day | Focus | Deliverables |
|-----|-------|--------------|
| **Mon-Tue** | Project setup, repo, Docker | GitHub repos initialized, dev env working |
| **Wed-Thu** | Email/password auth | Login/register working, JWT tokens generated |
| **Fri** | Google OAuth setup | OAuth app registered, ready for integration |
| **Week 2** | Base components, UI foundation | Navbar, sidebar, form components ready |

**Validation Checkpoint (End of Week 2)**:
- [ ] `POST /auth/register` works
- [ ] `POST /auth/login` returns JWT
- [ ] Frontend login form submits successfully
- [ ] User can log in and see dashboard
- [ ] Session persists on page refresh

**Go/No-Go Decision**: If auth broken, pause and fix before Phase 2

---

#### Week 3-4: Client Management
**Theme**: CRUD Core, Search, Import/Export
**Tasks**: 40 hours

| Day | Focus | Deliverables |
|-----|-------|--------------|
| **Mon-Tue** | Client model, CRUD API | All endpoints tested, serialized |
| **Wed** | Frontend list, search, filter | Clients page with live filtering |
| **Thu-Fri** | Edit, delete, notes system | Client detail page with full workflow |

**Validation Checkpoint (End of Week 4)**:
- [ ] Can create client with form
- [ ] Can edit client details
- [ ] Can search clients (name, email, phone)
- [ ] Can filter by status
- [ ] Can add notes and see activity log
- [ ] Can delete/archive client

**Go/No-Go Decision**: If client CRUD significantly broken, extend Phase 2

---

#### Week 5-6: Lead Pipeline
**Theme**: Kanban Board, Drag-Drop, Pipeline Analytics
**Tasks**: 17 hours

| Day | Focus | Deliverables |
|-----|-------|--------------|
| **Mon** | Pipeline stage model | Database schema, stages created |
| **Tue-Wed** | Kanban board UI | Board renders with three stages |
| **Thu** | Drag-and-drop implementation | Drag moves clients between stages |
| **Fri** | Analytics and filtering | Metrics display, tag filtering works |

**Validation Checkpoint (End of Week 6)**:
- [ ] Kanban board displays Hot/Warm/Cold columns
- [ ] Can drag client card to new stage
- [ ] Stage change persists in database
- [ ] Stage counts displayed
- [ ] Can filter by tag

**Go/No-Go Decision**: If drag-drop broken on mobile, extend testing into Week 7

---

#### Week 7-9: Scheduling & Calendar
**Theme**: Bookings, Google Calendar Sync, Email Reminders
**Tasks**: 35 hours

| Day | Focus | Deliverables |
|-----|-------|--------------|
| **Mon-Tue (Week 7)** | Booking model, calendar view | Calendar renders, can create bookings |
| **Wed-Thu** | Google Calendar OAuth | OAuth flow works, app authorized |
| **Fri** | One-way sync (app → Google) | Bookings sync to Google Calendar |
| **Mon-Tue (Week 8)** | Two-way sync (Google → app) | Changes in Google sync back (5 min poll) |
| **Wed-Thu** | Email reminders | 24-hour reminder emails sent |
| **Fri** | Testing & fixes | End-to-end calendar flow verified |

**Validation Checkpoint (End of Week 9)**:
- [ ] Can create booking with date/time
- [ ] Booking appears on calendar
- [ ] Can reschedule by dragging
- [ ] Google Calendar OAuth working
- [ ] Booking syncs to Google Calendar
- [ ] Change in Google Calendar syncs back to app
- [ ] 24-hour reminder email sent before booking

**Go/No-Go Decision**: If calendar sync fundamentally broken, switch to manual CSV fallback

---

#### Week 10-12: Polish, Security, Testing, Launch
**Theme**: Production-Ready, Security Hardened, Tested, Deployed
**Tasks**: 46 hours

**Week 10: Security & Testing**
| Day | Focus | Deliverables |
|-----|-------|--------------|
| **Mon-Tue** | Security audit | OWASP top 10 reviewed, vulnerabilities fixed |
| **Wed-Thu** | Write unit tests | 70%+ coverage on backend, 50% on frontend |
| **Fri** | Write integration/E2E tests | Critical flows covered, all pass |

**Week 11: Performance & Deployment Prep**
| Day | Focus | Deliverables |
|-----|-------|--------------|
| **Mon-Tue** | Performance optimization | <2s page load time achieved |
| **Wed** | Staging deployment | Deploy to staging, smoke tests pass |
| **Thu** | Production setup | Database, backups, monitoring configured |
| **Fri** | Documentation & runbooks | Deployment guide, user guide complete |

**Week 12: Final QA & Launch**
| Day | Focus | Deliverables |
|-----|-------|--------------|
| **Mon-Tue** | Final regression testing | All features tested, no critical bugs |
| **Wed** | Beta user setup | 5-10 beta testers registered, can access |
| **Thu** | Production deployment | v1.0.0 shipped! |
| **Fri** | Monitoring & user feedback | Monitor Sentry, answer user questions |

**Validation Checkpoint (End of Week 12)**:
- [ ] All unit/integration tests passing
- [ ] <2s page load time (Lighthouse)
- [ ] No critical security issues
- [ ] 5-10 beta users registered and active
- [ ] Zero critical bugs in production
- [ ] API documented (Swagger)
- [ ] User guide published

---

### Project Gantt Chart (Phases)

```
Week 1   Week 2   Week 3   Week 4   Week 5   Week 6   Week 7   Week 8   Week 9   Week 10  Week 11  Week 12
|--------|--------|--------|--------|--------|--------|--------|--------|--------|--------|--------|--------|
Foundation
|==================|
              Clients
              |==================|
                      Pipeline
                      |================|
                              Scheduling/Calendar
                              |======================================|
                                                               Polish/Test/Launch
                                                               |======================================|
```

### Key Deliverables by Phase

| Phase | Deliverables | Status |
|-------|--------------|--------|
| **Foundation** | Auth working, base components | Weeks 1-2 |
| **Clients** | CRUD, search, import/export | Weeks 3-4 |
| **Pipeline** | Kanban board, drag-drop | Weeks 5-6 |
| **Scheduling** | Calendar, Google sync, reminders | Weeks 7-9 |
| **Polish** | Tests, security, deployment | Weeks 10-12 |

### Go/No-Go Gates

| Gate | Criteria | Decision Point |
|------|----------|-----------------|
| **Gate 1** | Auth working, login → dashboard | End Week 2 |
| **Gate 2** | Client CRUD functional, 5+ features working | End Week 4 |
| **Gate 3** | Pipeline board drag-drop smooth | End Week 6 |
| **Gate 4** | Calendar + Google sync working | End Week 9 |
| **Gate 5** | All tests passing, 0 critical bugs | End Week 12 |

**If Gate fails**: Assess impact, extend phase, or skip nice-to-have features

### Milestone Summary

✅ **Milestone 1 (Week 2)**: Authentication & Foundation
- User can register, login, and see dashboard

✅ **Milestone 2 (Week 4)**: Client Management
- User can manage 500+ clients with search and organization

✅ **Milestone 3 (Week 6)**: Lead Pipeline
- User can visualize and manage leads through pipeline stages

✅ **Milestone 4 (Week 9)**: Scheduling & Sync
- User can book appointments and sync to Google Calendar

✅ **Milestone 5 (Week 12)**: Production MVP
- Fully tested, secure, documented, deployed
- 5-10 beta users actively using

---

## Success Metrics

### Technical Metrics
- **Test Coverage**: >70% backend, >50% frontend
- **Page Load Time**: <2 seconds (target: <1.5s)
- **API Response Time**: <200ms (target: <100ms)
- **Database Query Time**: <100ms for complex queries
- **Uptime**: 99.5% availability post-launch
- **Security**: 0 critical vulnerabilities (OWASP)

### User Adoption Metrics
- **Beta Users**: 5-10 active users by Week 12
- **Feature Usage**: >80% using core features (clients, pipeline, calendar)
- **Engagement**: >50% weekly active users
- **NPS Score**: Target >40 (good for early-stage SaaS)

### Business Metrics
- **Time to Launch**: 12 weeks
- **Development Cost**: ~$5-10K (time value for solo dev + AI tools)
- **Cost per Beta User**: ~$4-8K
- **Feature Completeness**: 100% of MVP scope
- **Launch Quality**: 0 critical bugs, <1% error rate

---

*Document Version: 2.0 | Status: COMPLETE | Final Update: 2026-01-24*
