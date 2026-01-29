# CRM MVP Planning Document - Review v2.0
## Verification of Updates + Remaining Gaps

**Document Status**: Version 2.0 | Review Date: 2026-01-24

---

## ✅ SUCCESSFULLY ADDRESSED FROM PREVIOUS REVIEW

### 1. JWT Token Management (Security)
**Previous Gap**: 24-hour expiry, no refresh token strategy  
**Current Status**: ✅ **FIXED**
- **Location**: FR1.5, Non-Functional Requirements (line 174)
- **Details**: 
  - Access tokens: 15-minute expiry
  - Refresh tokens: 7-day expiry in httpOnly cookies
  - Token rotation on refresh explicitly mentioned
  - Proper security headers documented
- **Quality**: Excellent. Implementation detail clearly specified.

---

### 2. CSV Import Validation & Error Handling (Functional Requirements)
**Previous Gap**: No duplicate detection, rollback, or validation details  
**Current Status**: ✅ **FIXED**
- **Location**: FR2.12 (line 115)
- **Details**:
  - Email format validation
  - Duplicate detection (skip or prompt)
  - Required field validation
  - **Database transaction rollback**: "Wrap in DB transaction; rollback all on critical error"
  - **Batch processing**: 100 rows/batch for large imports (500+)
  - Row-level error reporting
- **Quality**: Very good. Covers validation, recovery, and performance.

---

### 3. Conflict Resolution for Two-Way Sync (Functional Requirements)
**Previous Gap**: No strategy for simultaneous edits in app vs Google Calendar  
**Current Status**: ✅ **FIXED**
- **Location**: FR4.5 (line 136)
- **Details**:
  - **Strategy**: Last-write-wins with `updated_at` comparison
  - **User notification**: Toast notification on conflict
  - **Deleted event detection**: Via `showDeleted=true` parameter
  - Marked as cancelled when deleted in Google Calendar
- **Quality**: Good. Clear conflict strategy with user feedback.

---

### 4. Booking Double-Booking Prevention (Functional Requirements)
**Previous Gap**: No overlap detection or time slot validation  
**Current Status**: ✅ **FIXED**
- **Location**: FR4.1 (line 132)
- **Details**:
  - Overlap prevention: "Check for overlapping time slots before save"
  - Error message: "Time slot unavailable"
  - Story 4 edge case (lines 341-343): Specifies validation at both client and server
  - Database constraint mentioned: UNIQUE on (user_id, starts_at window)
- **Quality**: Good. Client + server validation specified.

---

### 5. Timezone Handling (Functional Requirements)
**Previous Gap**: No UTC storage strategy, DST handling missing  
**Current Status**: ✅ **FIXED**
- **Location**: FR4.7 (line 138)
- **Details**:
  - **Storage**: All times stored in UTC
  - **Display**: Converted to user timezone on display
  - **DST**: Handled via IANA timezone database
  - 24-hour reminder calculated in user's timezone
  - User timezone change handling (Story 4, lines 348-349): "Booking time adjusted, user notified"
- **Quality**: Excellent. Complete timezone strategy with DST support.

---

### 6. Google Calendar API Rate Limiting & Quotas (Assumptions)
**Previous Gap**: No quota monitoring, graceful degradation missing  
**Current Status**: ✅ **FIXED**
- **Location**: Assumptions section (line 61)
- **Details**:
  - **Calculation**: "100 users × 1 poll/5 min = ~20 calls/min"
  - **Monitoring**: "Sentry alerts at 80% threshold"
  - **Graceful degradation**: "Sync paused banner if quota exceeded"
  - **Error handling**: "Exponential backoff on 429 errors"
- **Quality**: Excellent. Proactive monitoring with fallback.

---

### 7. Concurrent Edit Handling (Database Schema)
**Previous Gap**: No optimistic locking or version tracking  
**Current Status**: ✅ **FIXED**
- **Location**: Database Schema, lines 947-953
- **Section Title**: "Concurrent Edit Handling (Optimistic Locking)"
- **Details**:
  - `updated_at` timestamp comparison on save
  - HTTP 409 Conflict response if stale
  - User message: "Record was modified. Refresh and retry."
  - Affects: clients, bookings, client_notes, pipeline_stages
- **Quality**: Good. Clear implementation strategy with HTTP status codes.

---

### 8. Rate Limiting & DDoS Protection (Non-Functional Requirements)
**Previous Gap**: No rate limiting strategy mentioned  
**Current Status**: ✅ **FIXED**
- **Location**: Non-Functional Requirements, Security (line 182)
- **Details**:
  - **Rate limit**: 1000 requests/hour per user
  - **Tool**: Rack::Attack gem
  - **Response**: HTTP 429 on limit
  - **Monitoring thresholds** (line 2643): Alert if >80% of quota hit
- **Quality**: Good. Includes both rate limiting and monitoring.
- **Note**: Could be more granular (e.g., login endpoint 5 attempts/hour), but MVP-acceptable.

---

### 9. GDPR & Data Privacy Compliance (Non-Functional Requirements)
**Previous Gap**: No privacy strategy or compliance mentioned  
**Current Status**: ✅ **FIXED**
- **Location**: Lines 179-181 (Security), 214-222 (GDPR & Privacy section)
- **Details**:
  - Data export endpoint: `GET /users/export` (JSON/CSV)
  - Account deletion: Hard delete after 30-day grace period
  - Consent banner: Cookie/analytics consent
  - Third-party disclosure: Email, Google APIs, SendGrid listed
  - Audit logging: `activity_logs` table with 1-year retention
  - Encryption at rest: PII encrypted (optional fields)
- **Quality**: Excellent. Comprehensive GDPR coverage.

---

### 10. Email Delivery Failure Handling (Risk Management)
**Previous Gap**: No retry logic, bounce handling, or delivery status tracking  
**Current Status**: ✅ **FIXED**
- **Location**: Risk R13 (line 2618)
- **Details**:
  - Log SendGrid/Mailgun delivery status
  - Retry logic for soft bounces
  - "Resend reminder" button for users
  - Alert on bounce rate >5%
- **Quality**: Good. Includes logging, retry, and alerting.

---

### 11. Background Job Queue & Error Recovery (Risk Management)
**Previous Gap**: No queue system for failed syncs  
**Current Status**: ✅ **FIXED**
- **Location**: Risk R11 (line 2616)
- **Details**:
  - Sidekiq job queue with retry logic
  - Dead-letter queue (DLQ) for failed jobs
  - All sync failures logged to Sentry
  - Manual retry endpoint for failed syncs
- **Quality**: Excellent. Production-grade error handling.
- **Implementation**: Mentioned in Task 4.3.8 (line 1646): "Handle calendar sync errors gracefully"

---

### 12. Deployment & Rollback Strategy (Deployment Plan)
**Previous Gap**: No rollback plan, migration strategy vague  
**Current Status**: ✅ **FIXED**
- **Location**: Lines 2158-2199 (Production Deployment), 2204-2234 (Database Migrations)
- **Migration Strategy**:
  - Test migrations locally before production
  - Reversible migrations required
  - Monitor for long locks, data loss
- **Rollback Procedure**:
  - "Quick rollback to previous version" via `railway redeploy <deployment-id>`
  - Git revert fallback
- **Database**:
  - Daily automated backups with pg_dump
  - 30-day rolling window retention
  - Recovery procedure documented (test monthly)
  - RTO <1 hour, RPO <1 day (line 209)
- **Quality**: Very good. Detailed procedures with test requirements.

---

### 13. Monitoring & Alerting (Non-Functional Requirements + Risk Management)
**Previous Gap**: No specific alert thresholds defined  
**Current Status**: ✅ **FIXED**
- **Location**: Lines 2343-2407 (Monitoring section), 2635-2647 (Monitoring Thresholds)
- **Specific Thresholds**:
  - API error rate: Warning >1%, Critical >5%
  - API latency (p99): Warning >300ms, Critical >500ms
  - Google Calendar quota: Warning >70%, Critical >90%
  - Email bounce rate: Warning >3%, Critical >5%
  - Uptime: <99.9% warning, <99.5% critical
- **Tools**: Sentry (errors), New Relic (performance), PagerDuty/Slack (critical)
- **Health checks**: `/health` endpoint with database, Redis, Google API status
- **Quality**: Excellent. Comprehensive monitoring strategy.

---

## 🟡 PARTIALLY ADDRESSED / NEEDS CLARIFICATION

### 14. Search Performance & Indexing (Functional Requirements + Database)
**Status**: ⚠️ **Partially Fixed**
- **Location**: FR2.3, Database Schema (line 929)
- **What's Added**:
  - Full-text search index: `GIN(to_tsvector(first_name || last_name || email))`
  - Target: <100ms for 500 clients
  - Index on (user_id, email) for duplicate detection
- **Missing Specifics**:
  - ❌ No query performance testing methodology mentioned
  - ❌ Debounce strategy for live search not specified (referenced in Story 5, line 365 as "300ms" but no implementation details)
  - ❌ When to upgrade to Elasticsearch not documented (mentioned as "if needed post-MVP" on line 525)
- **Recommendation**: Add Week 8 load testing scenario for search with 500+ clients

---

### 15. Status Naming & Consistency (Functional Requirements)
**Status**: ⚠️ **Inconsistency Not Fully Resolved**
- **Issue**: Two different status schemas without clear distinction:
  - **Client status** (FR2.4): `active/inactive/archived` (line 108)
  - **Booking status** (FR4.6): `proposed/confirmed/completed/cancelled` (line 137)
- **Current Handling**: 
  - Database uses check constraints (lines 774, 665-666)
  - Separate enums, which is correct
  - But documentation doesn't clarify why they're different
- **Recommendation**: Add section explaining "Status Types" with clear enum definitions

---

### 16. Pagination Strategy (Non-Functional Requirements)
**Status**: ⚠️ **Partially Specified**
- **What's Defined**: 20 items per page (FR2.2, line 105)
- **Missing**:
  - ❌ Cursor-based vs offset-based approach not specified
  - ❌ Sorting column performance implications not discussed
  - ❌ Large dataset handling (what happens if user has 10,000 clients in future?)
  - ❌ No mention of query optimization for pagination
- **Recommendation**: Specify cursor-based pagination for better performance at scale

---

## 🔴 NEW GAPS IDENTIFIED (Not Previously Reviewed)

### 17. Phone Number Validation & Formatting
**Status**: ❌ **Not Addressed**
- **Location**: FR2.1 mentions "phone" field but no validation
- **Issue**: Phone numbers can be in many formats internationally
- **Current State**: Story 2 edge case (lines 279-280) mentions "Phone Number Formats" but notes "Stored as-is, no normalization in MVP"
- **Risks**:
  - User searches won't work if format differs (1-555-123-4567 vs 5551234567)
  - International numbers inconsistently formatted
- **Recommendation**: Add phone number validation using `libphonenumber-js`:
  - Validate format on input
  - Store as E.164 format (+1-555-123-4567)
  - Display in user's regional format
  - Estimated effort: 2-3 hours

---

### 18. Calendar View Constraints (Multiple Bookings Per Day)
**Status**: ❌ **Not Addressed**
- **Location**: Not mentioned in calendar requirements (FR4)
- **Issue**: How does calendar handle many events on same day? Overlapping? Scrolling?
- **Risk**: Potential UI problems if user has 10+ bookings in one day
- **Recommendation**: Add constraint:
  - Max 20 events visible per day before scrolling
  - All-day style events stack
  - Hover to see full details
  - Estimated effort: 4-5 hours

---

### 19. API Documentation Generation Strategy
**Status**: ⚠️ **Mentioned But Not Detailed**
- **Location**: Task 5.5.1 (line 2715): "Write API documentation (OpenAPI/Swagger)"
- **Missing Details**:
  - ❌ Auto-generated from code (using swagger_rails gem) vs manual YAML
  - ❌ How to keep docs in sync with code
  - ❌ No mention of API versioning strategy (v1 mentioned but no versioning rules)
- **Recommendation**: Use `rswag` gem for auto-generated Swagger from test specs (keeps docs in sync with code)

---

### 20. Booking Status Transition Rules
**Status**: ❌ **Not Defined**
- **Location**: FR4.6 allows setting status but no rules for valid transitions
- **Issue**: Can you transition:
  - `completed` → `proposed`? (NO - should prevent)
  - `cancelled` → `confirmed`? (Maybe, but should require user confirmation)
  - `proposed` → `completed`? (Unclear - should skip confirmed?)
- **Recommendation**: Add state machine:
  - `proposed` → `confirmed`, `cancelled`
  - `confirmed` → `completed`, `cancelled`
  - `completed` → (no transitions)
  - `cancelled` → (no transitions)

---

### 21. OAuth Token Refresh for Google Calendar
**Status**: ❌ **Not Addressed**
- **Location**: Calendar integration (FR4.3-4.5) mentions OAuth but no refresh strategy
- **Issue**: Google OAuth tokens expire (typically 1 hour for access token)
  - If user has app open for 2+ hours, sync will fail silently
  - No mention of refresh token rotation
- **Risk**: User's Google Calendar sync stops working without warning
- **Recommendation**: 
  - Store refresh token securely
  - Implement refresh token rotation
  - Detect expired access token and re-authenticate
  - Estimated effort: 3-4 hours

---

### 22. Real-Time Sync / WebSocket Strategy
**Status**: ⚠️ **Acknowledged as Deferred**
- **Location**: Story 3, "Stale Stage Indicator" (lines 314-315): "WebSocket updates deferred; page refresh shows current state (5-min acceptable latency)"
- **Issue**: Multiple users editing same data see stale info
  - When one user moves client to "Hot" stage, other users won't see it for 5 minutes
  - No polling strategy mentioned for frontend
- **Current Mitigation**: User must refresh page to see latest
- **Recommendation**: 
  - Add footnote about Phase 2: "Real-time sync via WebSocket (planned Q2)"
  - Implement simple page refresh button on critical screens
  - Estimated effort for Phase 2: 2-3 weeks

---

### 23. File Uploads (Documents/Attachments)
**Status**: ❌ **Not Mentioned**
- **Location**: Not in MVP scope
- **Issue**: Users may want to attach contracts, photos, invoices to clients
  - Not critical for MVP but comes up quickly in beta feedback
- **Recommendation**: Add to Phase 2 backlog with clear scope:
  - Max 10MB per file, 100MB per client
  - S3 storage with signed URLs
  - Scan for viruses (ClamAV)

---

### 24. Import Progress UI
**Status**: ❌ **Not Specified**
- **Location**: Story 6 (lines 374-389) covers CSV import but no UX for large imports
- **Issue**: Importing 500+ clients could take 30+ seconds
  - No progress bar or cancel button mentioned
  - User doesn't know if process is stuck
- **Recommendation**: Add progress tracking:
  - Progress bar: "Importing 450 of 500..."
  - Cancel button to stop import
  - Estimated effort: 2-3 hours

---

### 25. Email Reminder Status User Visibility
**Status**: ❌ **Not Addressed**
- **Location**: FR4.7 mentions sending 24-hour reminder but no status indication
- **Issue**: User has no way to know if reminder email was actually sent
  - Risk: User assumes reminder was sent, it wasn't delivered
- **Recommendation**: Add to booking detail:
  - "Reminder sent at 2026-01-23 10:00 AM" (or "Failed")
  - "Resend reminder" button if failed
  - Estimated effort: 2-3 hours

---

### 26. Google Calendar Disconnection Handling
**Status**: ⚠️ **Mentioned But Not Detailed**
- **Location**: Story 4 edge case (lines 346-347): "Google Calendar Disconnected"
- **Details Given**: "Bookings remain in app; sync paused; prompt to reconnect"
- **Missing**:
  - ❌ When does sync pause? (On first 404? After 3 retries?)
  - ❌ How often does user see reconnect prompt? (Every page load? Once per session?)
  - ❌ What happens to bookings created while disconnected? (Synced when reconnected?)
- **Recommendation**: Add detailed flow in Task 4.3.8

---

### 27. Soft Delete vs Hard Delete Strategy
**Status**: ⚠️ **Partially Defined**
- **Location**: Line 211: "Keep for 90 days before purge (configurable)"
- **Missing**:
  - ❌ Which entities support hard delete? (All? Just clients?)
  - ❌ Cascade rules: Delete client → delete bookings, notes, activity logs?
  - ❌ GDPR right-to-deletion: Immediate hard delete or 90-day grace period?
- **Recommendation**: Create "Data Retention Policy" section specifying:
  - Clients: soft delete 90 days, then hard delete
  - Bookings: cascade delete with client
  - Activity logs: retain 1 year for audit, then delete
  - Notes: cascade delete with client

---

### 28. Load Testing Specifics
**Status**: ⚠️ **Mentioned But Vague**
- **Location**: Non-Functional Requirements (line 164), Task 5.3.8 (line 1698)
- **Current**: "Load testing at Week 8 with k6 or Apache Bench"
- **Missing**:
  - ❌ Specific scenarios (100 concurrent users doing what?)
  - ❌ Target metrics (response time, throughput, error rate)
  - ❌ Database load assumptions (how many clients per user?)
  - ❌ Tool selection (k6? Apache JMeter? Locust?)
- **Recommendation**: Add detailed load testing plan:
  - Scenario 1: 100 concurrent users browsing clients (20 per page, sorting)
  - Scenario 2: 10 concurrent users drag-dropping on pipeline
  - Scenario 3: Calendar sync (100 users polling simultaneously)
  - Target: p99 latency <200ms, no errors at 100 concurrent users

---

### 29. Multiple Time Zones in Same Organization
**Status**: ❌ **Not Addressed**
- **Location**: No mention in requirements or user stories
- **Issue**: Future feature but edge case worth noting
  - What if team member in PST and EST both managing same calendar?
  - Booking shown in their local time, but ambiguous who's managing it
- **Current Assumption**: Solo user, one timezone
- **Recommendation**: Document as Phase 2 feature: "Team collaboration with timezone support"

---

### 30. Email Service Provider Selection
**Status**: ⚠️ **Deferred Decision**
- **Location**: Technology Stack (line 82): "SendGrid or Mailgun"
- **Issue**: No decision criteria provided
- **Missing**:
  - ❌ Cost comparison
  - ❌ API feature comparison (templates, webhooks, etc.)
  - ❌ Deliverability reputation
- **Recommendation**: Add selection criteria:
  - SendGrid: More expensive (~$10/10k emails), better templates
  - Mailgun: Cheaper (~$0.50/10k emails), good webhooks
  - **Decision**: Choose Mailgun for MVP cost, upgrade if needed

---

## 📋 SUMMARY: COMPLETENESS SCORECARD

| Category | Score | Status | Notes |
|----------|-------|--------|-------|
| **Authentication & Security** | 95% | ✅ Excellent | JWT, GDPR, audit logging all covered |
| **Functional Requirements** | 90% | ✅ Very Good | Core features defined, edge cases mostly covered |
| **Data Management** | 85% | ⚠️ Good | Pagination, indexing, locking all present but some details sparse |
| **Calendar/Sync** | 80% | ⚠️ Good | Conflict resolution, timezone handling great; OAuth refresh, real-time missing |
| **Email Delivery** | 85% | ⚠️ Good | Reminders covered; bounce handling, retry logic both present |
| **Deployment** | 90% | ✅ Very Good | Rollback, backup, monitoring all detailed |
| **Testing** | 85% | ⚠️ Good | Test pyramid defined; load testing plan vague |
| **Performance** | 80% | ⚠️ Fair | Targets defined (2s page load); optimization strategies sparse |
| **Monitoring & Alerting** | 95% | ✅ Excellent | Specific thresholds, tools, and escalation paths |
| **Risk Management** | 90% | ✅ Very Good | 13 risks identified with mitigation; contingency plans clear |
| **Timeline & Scope** | 85% | ⚠️ Good | 12-week timeline realistic; 20% buffer included |

**Overall Score**: **87/100**

---

## 🚀 PRIORITY RECOMMENDATIONS

### Must Fix Before Development Starts (Week 1)

1. **OAuth Refresh Token Strategy** (Impact: High, Effort: Medium)
   - Add automatic token refresh for Google Calendar
   - Handle expired token gracefully
   - Estimated: 3-4 hours Week 1

2. **Phone Number Validation** (Impact: Medium, Effort: Low)
   - Use `libphonenumber-js` for validation
   - Store in E.164 format
   - Estimated: 2-3 hours Week 1

3. **Booking Status Transition Rules** (Impact: Medium, Effort: Low)
   - Define state machine for status changes
   - Prevent invalid transitions
   - Estimated: 1-2 hours Task 4.1.6

4. **API Documentation Strategy** (Impact: Medium, Effort: Low)
   - Choose `rswag` for auto-generated docs from tests
   - Document versioning rules
   - Estimated: Decision Week 1

### Should Add to Week 7-9 (Calendar Phase)

5. **Google Calendar Disconnection Handling** (Impact: Medium, Effort: Low)
   - Define reconnect flow and frequency
   - Document booking sync behavior when disconnected
   - Estimated: 2-3 hours Task 4.3.8

6. **Calendar View Constraints** (Impact: Low, Effort: Medium)
   - Handle 10+ events per day gracefully
   - Add scrolling/stacking for event density
   - Estimated: 4-5 hours Task 4.2.2

### Should Add to Week 10-12 (Polish)

7. **Load Testing Detailed Plan** (Impact: High, Effort: Medium)
   - Specify concrete scenarios and targets
   - Choose tool (k6 recommended)
   - Estimated: 6-8 hours Week 8

8. **Email Reminder Status UI** (Impact: Medium, Effort: Low)
   - Show delivery status on booking detail
   - Add resend button
   - Estimated: 2-3 hours Task 4.4.x

9. **Import Progress UI** (Impact: Low, Effort: Low)
   - Add progress bar for CSV import
   - Allow cancellation
   - Estimated: 2-3 hours Task 2.3.x

### Document for Post-MVP (Phase 2)

- Real-time sync with WebSocket
- Team collaboration with multiple timezones
- File attachments to clients
- Phone number normalization/formatting (currently deferred)
- Advanced search with Elasticsearch

---

## 🎯 NEXT STEPS

1. **Review & Sign-Off**: Stakeholder sign-off on remaining gaps (especially OAuth refresh, phone validation)
2. **Decide on Deferred Features**: Confirm what's truly post-MVP vs must-have
3. **Refine Timeline**: If adding OAuth refresh + phone validation, verify 12-week timeline still holds
4. **Create Sprint 1 Task List**: Expand Week 1 tasks with OAuth + phone validation additions
5. **Schedule Architecture Review**: Review database schema, API design, and third-party integrations with team

---

**Document Review Completed**: 2026-01-24  
**Status**: Ready for development with minor clarifications needed  
**Confidence Level**: 87% (few gaps remain but manageable)
