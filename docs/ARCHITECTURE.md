# Architecture

## System Overview
A full-stack salary management tool for an HR Manager to manage
10,000 employees with real-time salary insights.

## Tech Stack

### Backend (this repo)
- Ruby on Rails 8 — API only mode
- PostgreSQL — relational database
- RSpec + FactoryBot — TDD
- Blueprinter — JSON serialization
- Pagy — pagination
- activerecord-import — bulk insert

### Frontend (salary-management-ui)
- React 18 + Vite
- Bootstrap 5.3 + React Bootstrap
- React Query — server state
- React Hook Form — forms
- Recharts — charts
- TanStack Table — data table

## Rails Internal Layers

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

## Database Schema

### departments
| Column      | Type      | Notes             |
|-------------|-----------|-------------------|
| id          | uuid PK   |                   |
| name        | string    | unique, not null  |
| description | text      | nullable          |
| created_at  | timestamp |                   |
| updated_at  | timestamp |                   |

### job_titles
| Column     | Type      | Notes                                       |
|------------|-----------|---------------------------------------------|
| id         | uuid PK   |                                             |
| name       | string    | unique, not null                            |
| level      | string    | Junior/Mid/Senior/Staff/Principal/Executive |
| created_at | timestamp |                                             |
| updated_at | timestamp |                                             |

### employees
| Column          | Type          | Notes                         |
|-----------------|---------------|-------------------------------|
| id              | uuid PK       |                               |
| full_name       | string        | not null                      |
| email           | string        | unique, not null              |
| phone           | string        | nullable                      |
| gender          | string        | nullable                      |
| country         | string        | not null, indexed             |
| city            | string        | nullable                      |
| department_id   | uuid FK       | not null, indexed             |
| job_title_id    | uuid FK       | not null, indexed             |
| employment_type | integer enum  | full_time/part_time/contract  |
| salary          | decimal(12,2) | not null, indexed             |
| currency        | string        | default USD                   |
| hired_on        | date          | not null, indexed             |
| date_of_birth   | date          | nullable                      |
| active          | boolean       | default true, indexed         |
| created_at      | timestamp     |                               |
| updated_at      | timestamp     |                               |

## Associations
- Department has_many :employees
- JobTitle has_many :employees
- Employee belongs_to :department
- Employee belongs_to :job_title

## Indexes
- employees: email (unique)
- employees: country
- employees: city
- employees: department_id
- employees: job_title_id
- employees: salary
- employees: active
- employees: hired_on
- employees: [country, job_title_id] composite
- employees: [active, country] composite

## API Endpoints

### Employees
- GET    /api/v1/employees
- POST   /api/v1/employees
- GET    /api/v1/employees/:id
- PATCH  /api/v1/employees/:id
- DELETE /api/v1/employees/:id

### Insights
- GET /api/v1/insights/salary

### Meta
- GET /api/v1/meta/countries
- GET /api/v1/meta/departments
- GET /api/v1/meta/job_titles

## Deployment
- Backend: Render.com Web Service
- Frontend: Render.com Static Site
- CI: GitHub Actions — RSpec on every push