# Week 2 Plan: Domain Models & CRUD

**Status**: Current

## Goals

- Introduce real domain data behind authentication
- Add user-scoped CRUD endpoints
- Maintain test coverage via request specs

## Session Startup Checklist

```bash
# 1. Verify Ruby environment
ruby -v          # expect 3.3.x via mise
rails -v         # expect 7.2.x

# 2. Verify PostgreSQL is running
pg_isready       # expect "accepting connections"

# 3. Prepare database
bin/rails db:prepare

# 4. Start server and verify health
bin/rails server
curl -i http://localhost:3000/up   # expect HTTP 200

# 5. Run existing tests
bundle exec rspec   # all specs should pass
```

## Deliverables

### 1. Domain Models

#### Client Model

- [ ] Generate `Client` model
  - `name:string` (required)
  - `email:string`
  - `phone:string`
  - `notes:text`
  - `user:references` (foreign key, required)
- [ ] Add model validations
  - `belongs_to :user`
  - `validates :name, presence: true`
- [ ] Run migration and verify

#### Project Model (Optional)

- [ ] Generate `Project` model
  - `name:string` (required)
  - `status:string` (default: "active")
  - `user:references` (required)
  - `client:references` (optional)
- [ ] Add model associations and validations

### 2. Clients API Endpoints

All endpoints require JWT authentication (`Authorization: Bearer <token>`).

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/clients` | GET | List current user's clients |
| `/clients` | POST | Create a new client |
| `/clients/:id` | GET | Show a specific client |
| `/clients/:id` | PATCH | Update a client |
| `/clients/:id` | DELETE | Delete a client |

- [ ] Generate `ClientsController`
- [ ] Implement `index` action
- [ ] Implement `show` action
- [ ] Implement `create` action
- [ ] Implement `update` action
- [ ] Implement `destroy` action

### 3. Controller Standards

- [ ] Call `authenticate_user!` before all actions
- [ ] Scope all queries to `current_user`
- [ ] Return 401 for missing/invalid token
- [ ] Return 404 for resources not owned by current user
- [ ] Use strong parameters for mass assignment

### 4. Request Specs

- [ ] **CRUD happy path**
  - Create client with valid params
  - List clients (returns only user's clients)
  - Show client by ID
  - Update client
  - Delete client
- [ ] **Unauthorized access**
  - All endpoints return 401 without token
  - All endpoints return 401 with invalid token
- [ ] **Cross-user protection**
  - User A cannot see User B's clients
  - User A cannot update User B's clients
  - User A cannot delete User B's clients

## API Response Formats

### Success

```
GET /clients          → { "clients": [...] }
GET /clients/:id      → { "client": {...} }
POST /clients         → { "client": {...} }, status: 201
PATCH /clients/:id    → { "client": {...} }
DELETE /clients/:id   → status: 204 (no content)
```

### Errors

```
401 Unauthorized      → { "error": "Unauthorized" }
404 Not Found         → { "error": "Not found" }
422 Unprocessable     → { "errors": [...] }
```

## New Files

```
app/
├── controllers/
│   └── clients_controller.rb
└── models/
    └── client.rb

spec/
└── requests/
    └── clients_spec.rb
```

## Definition of Done

- [ ] Client model exists with proper associations
- [ ] All 5 CRUD endpoints functional
- [ ] All endpoints require authentication
- [ ] All queries scoped to current_user
- [ ] Request specs cover happy path, auth, and cross-user scenarios
- [ ] All tests passing (`bundle exec rspec`)
- [ ] Code committed and merged to main
