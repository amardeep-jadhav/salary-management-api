# Salary Management API

A production-quality REST API for managing 10,000 employees and salary insights. Built with Rails 8, following TDD, SOLID principles, and clean architecture patterns.

## Live Demo

- **API Base URL:** https://salary-management-api-j1hf.onrender.com
- **Frontend:** https://salary-management-ui.onrender.com

---

## Tech Stack

- **Ruby 3.4.5**
- **Rails 8.1 (API mode)**
- **PostgreSQL**
- **RSpec + FactoryBot** — TDD
- **Blueprinter** — JSON serialization
- **Pagy** — Pagination
- **activerecord-import** — Bulk insert

---

## Architecture

```
HTTP Request
    ↓
Controller        → HTTP only, no business logic
    ↓
Service Object    → Business logic, returns ServiceResult
    ↓
Query Object      → Complex SQL, aggregates, scopes
    ↓
Model             → Validations and associations only
    ↓
PostgreSQL        → Indexed queries
    ↓
Blueprinter       → JSON serialization
    ↓
HTTP Response
```

### Design Patterns
- **Service Objects** — `app/services/employees/`
- **Query Objects** — `app/queries/`
- **Result Object** — `ServiceResult` for consistent service responses
- **Blueprinter** — JSON serialization with multiple views

---

## Local Setup

### Prerequisites
- Ruby 3.4.5
- PostgreSQL
- Bundler

### Steps

**1. Clone the repo**
```bash
git clone https://github.com/YOUR_USERNAME/salary-management-api.git
cd salary-management-api
```

**2. Install dependencies**
```bash
bundle install
```

**3. Setup environment variables**
```bash
cp .env.example .env
```

Edit `.env` with your PostgreSQL credentials:
```
DB_USERNAME=postgres
DB_PASSWORD=your_password
DB_HOST=localhost
ALLOWED_ORIGINS=http://localhost:5173
```

**4. Create and migrate database**
```bash
rails db:create
rails db:migrate
```

**5. Seed 10,000 employees**
```bash
rails db:seed_employees
```

This runs a bulk insert with parallel threads — seeds 10,000 employees in under 3 seconds.

**6. Start the server**
```bash
rails server
```

API available at `http://localhost:3000`

---

## Running Tests

```bash
bundle exec rspec
```

Expected output:
```
48 examples, 0 failures
```

---

## API Endpoints

### Employees
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/v1/employees` | List employees (paginated, filterable) |
| POST | `/api/v1/employees` | Create employee |
| GET | `/api/v1/employees/:id` | Get employee |
| PATCH | `/api/v1/employees/:id` | Update employee |
| DELETE | `/api/v1/employees/:id` | Soft delete employee |

#### Query Parameters for GET /api/v1/employees
| Param | Description |
|-------|-------------|
| `search` | Search by name or email |
| `country` | Filter by country code |
| `department_id` | Filter by department |
| `sort` | Sort by field (full_name, salary, hired_on) |
| `direction` | asc or desc |
| `page` | Page number |

### Insights
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/v1/insights/salary` | Salary insights (min/max/avg, distribution, top roles) |

#### Query Parameters for GET /api/v1/insights/salary
| Param | Description |
|-------|-------------|
| `country` | Filter all metrics by country |

### Meta
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/v1/meta/countries` | List distinct countries |
| GET | `/api/v1/meta/departments` | List all departments |
| GET | `/api/v1/meta/job_titles` | List all job titles |

---

## Database Schema

### Tables
- **employees** — core entity with 17 fields
- **departments** — lookup table (rename propagates everywhere)
- **job_titles** — lookup table with seniority level

### Key Indexes
- `employees.email` — unique
- `employees.country` — for country filtering
- `employees.department_id` — FK
- `employees.job_title_id` — FK
- `[country, job_title_id]` — composite for insights queries
- `[active, country]` — composite for active employee queries

---

## CI/CD

GitHub Actions runs on every push to `main`:
- `scan_ruby` — Brakeman security scan + bundler-audit
- `lint` — RuboCop code style
- `test` — Full RSpec suite

---

## Seed Script Performance

```bash
rails db:seed_employees
```

- Bulk insert using `activerecord-import`
- Parallel threads (20 batches × 500 records)
- Idempotent — safe to run multiple times
- **10,000 employees seeded in ~0.86 seconds**

---

## Design Decisions

See [docs/DECISIONS.md](docs/DECISIONS.md) for full reasoning behind every technical decision.

---

## Planning & Architecture Docs

| Document | Description |
|----------|-------------|
| [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) | System design and DB schema |
| [docs/DECISIONS.md](docs/DECISIONS.md) | Technical decision log |
| [docs/TDD_APPROACH.md](docs/TDD_APPROACH.md) | TDD strategy and commit approach |
| [docs/PROMPTS.md](docs/PROMPTS.md) | AI tools usage |