# Micro-SaaS CRM - High-Level To-Do List

## Model Selection Justification
**Selected Model**: Claude Opus 4.5 (claude-opus-4-5-20251101)
- **Token Capacity**: Extended context window for comprehensive planning
- **Reasoning**: Complex multi-phase project requiring deep architectural planning, dependency tracking, and detailed milestone breakdowns
- **Trade-off**: Higher cost justified by reduced context-switching and ability to maintain full project state

---

## Project Summary
**Product**: Micro-SaaS CRM for creative entrepreneurs (photographers, event planners, freelancers)
**Timeline**: 3 months aggressive MVP
**Tech Stack**: React/TypeScript | Ruby on Rails | PostgreSQL
**Auth**: Email/Password + Google OAuth
**Payments**: Stripe (DEFERRED to post-MVP)

---

## High-Level To-Do Phases

### Phase 1: Foundation (Weeks 1-2)
- [ ] **1.1** Project scaffolding and repository setup
- [ ] **1.2** Development environment configuration (Docker, CI/CD basics)
- [ ] **1.3** Database schema design and initial migrations
- [ ] **1.4** Authentication system (email/password)
- [ ] **1.5** Google OAuth integration
- [ ] **1.6** Base UI component library setup

### Phase 2: Client Management Core (Weeks 3-4)
- [ ] **2.1** Client data model and API endpoints (CRUD)
- [ ] **2.2** Client list view with search/filter
- [ ] **2.3** Client detail view and edit forms
- [ ] **2.4** Client notes and activity log
- [ ] **2.5** Client import/export (CSV)

### Phase 3: Lead Classification (Weeks 5-6)
- [ ] **3.1** Lead status model (hot/warm/cold)
- [ ] **3.2** Kanban pipeline UI component
- [ ] **3.3** Drag-and-drop pipeline management
- [ ] **3.4** Lead tagging system
- [ ] **3.5** Pipeline analytics (basic counts/conversion)

### Phase 4: Scheduling System (Weeks 7-9)
- [ ] **4.1** Booking/appointment data model
- [ ] **4.2** Calendar view component
- [ ] **4.3** Booking creation and management UI
- [ ] **4.4** Google Calendar OAuth integration
- [ ] **4.5** Two-way calendar sync
- [ ] **4.6** Email reminder system (basic)

### Phase 5: Polish & Launch Prep (Weeks 10-12)
- [ ] **5.1** Mobile responsiveness audit and fixes
- [ ] **5.2** Security audit (GDPR basics, data encryption)
- [ ] **5.3** Performance optimization
- [ ] **5.4** Error handling and user feedback
- [ ] **5.5** Landing page and onboarding flow
- [ ] **5.6** Documentation (user guide, API docs)
- [ ] **5.7** Production deployment setup
- [ ] **5.8** Beta testing with 5-10 users

---

## Deferred Items (Post-MVP)
| Item | Prerequisite | Priority |
|------|--------------|----------|
| Stripe payments | API keys, business verification | High |
| SMS reminders (17hats inspiration) | Twilio account | Medium |
| Time tracking (Bonsai inspiration) | Core scheduling complete | Medium |
| Workflow automations (Dubsado inspiration) | Pipeline system mature | Low |
| Advanced analytics | Sufficient user data | Low |

---

## Key Dependencies
1. **Google OAuth** → Required before Google Calendar integration
2. **Client Management** → Required before Lead Classification
3. **Lead Classification** → Required before Pipeline Analytics
4. **Scheduling Core** → Required before Calendar Sync
5. **All Core Features** → Required before Polish Phase

---

## Validation Checkpoints
- [ ] End of Week 2: Auth working, can create account and login
- [ ] End of Week 4: Can create, view, edit, delete clients
- [ ] End of Week 6: Kanban pipeline functional with drag-drop
- [ ] End of Week 9: Calendar view with Google sync working
- [ ] End of Week 12: Production-ready MVP deployed

---

## Risk Register (Summary)
| Risk | Impact | Mitigation |
|------|--------|------------|
| Google API quota limits | High | Request quota increase early |
| Scope creep | High | Strict MVP feature gate |
| Calendar sync complexity | Medium | Start integration Week 7 |
| Mobile UX issues | Medium | Test on devices weekly |

---

## Next Step
Expand this into comprehensive `planning.md` with:
- Detailed requirements (functional/non-functional)
- User stories with acceptance criteria
- Granular task breakdowns (<2 hour chunks)
- Technical architecture diagrams (text-based)
- API endpoint specifications
- Database schema details
- Testing strategy
- Deployment plan

---
*Document Version: 1.0 | Created: 2026-01-24 | Status: DRAFT*
