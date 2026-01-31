# Week 1 Plan: Authentication

**Status**: Complete (merged to main)

## Goals

- Set up Rails 7.2 API-only project
- Implement JWT-based authentication
- Establish test coverage with RSpec

## Deliverables

### User Model

- [x] Generate User model with `email` and `password_digest`
- [x] Add `has_secure_password` (bcrypt)
- [x] Add email uniqueness validation

### Auth Endpoints

| Endpoint | Method | Auth Required | Returns |
|----------|--------|---------------|---------|
| `/auth/register` | POST | No | `{ token, user: { id, email } }` |
| `/auth/login` | POST | No | `{ token, user: { id, email } }` |
| `/me` | GET | Yes | `{ id, email }` |

- [x] `POST /auth/register` — create user, return JWT
- [x] `POST /auth/login` — authenticate, return JWT
- [x] `GET /me` — return current user (JWT required)

### JWT Infrastructure

- [x] Create `JsonWebToken` encoder/decoder
- [x] Implement `authenticate_user!` in ApplicationController
- [x] Implement `current_user` helper

### Request Specs

- [x] Auth registration specs
- [x] Auth login specs
- [x] Me endpoint specs (authorized + unauthorized)

## Key Files

```
app/
├── controllers/
│   ├── application_controller.rb   # authenticate_user!, current_user
│   ├── auth_controller.rb          # register, login
│   └── me_controller.rb            # show current user
├── lib/
│   └── json_web_token.rb           # JWT encode/decode
└── models/
    └── user.rb                     # has_secure_password

spec/
└── requests/
    ├── auth_spec.rb
    └── me_spec.rb
```

## Definition of Done

- [x] All 3 endpoints functional
- [x] JWT authentication working
- [x] 10 request specs passing
- [x] Merged to main
