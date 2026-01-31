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

- [ ] Generate `Client` model with fields:
  - `name:string` (required)
  - `email:string` (optional, validate format if present)
  - `phone:string`
  - `company:string`
  - `notes:text`
  - `user:references` (foreign key, required)
- [ ] Add model validations:
  - `belongs_to :user`
  - `validates :name, presence: true`
  - `validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true`
- [ ] Add `has_many :clients, dependent: :destroy` to User model
- [ ] Add database index on `clients.user_id`
- [ ] Run migration and verify

#### Deferred

- **Project model**: deferred to a later week
- **Client status field** (active/inactive/archived): deferred to a later week
- **Soft delete / archiving**: deferred to a later week

### 2. Clients API Endpoints

All endpoints require JWT authentication (`Authorization: Bearer <token>`).

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/clients` | GET | List current user's clients |
| `/clients` | POST | Create a new client |
| `/clients/:id` | GET | Show a specific client |
| `/clients/:id` | PATCH | Update a client |
| `/clients/:id` | DELETE | Delete a client (hard delete) |

- [ ] Generate `ClientsController`
- [ ] Implement `index` action
- [ ] Implement `show` action
- [ ] Implement `create` action
- [ ] Implement `update` action
- [ ] Implement `destroy` action (hard delete)

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
422 Unprocessable     → { "errors": { "field": ["message"] } }
```

Example 422 response:
```json
{
  "errors": {
    "name": ["can't be blank"],
    "email": ["is invalid"]
  }
}
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
- [ ] User model has `has_many :clients`
- [ ] Database index exists on `clients.user_id`
- [ ] All 5 CRUD endpoints functional
- [ ] All endpoints require authentication (401 on failure)
- [ ] All queries scoped to current_user
- [ ] Cross-user access returns 404
- [ ] Request specs cover happy path, auth, and cross-user scenarios
- [ ] All tests passing (`bundle exec rspec`)
- [ ] Code committed and merged to main
