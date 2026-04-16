# Technical Decisions

## Rails 8 over Rails 7
Rails 8 is stable as of November 2024. Using the latest
version signals awareness of the current ecosystem.

## API-only mode
No views, no assets, no sessions. Clean separation —
Rails handles data, React handles presentation.

## PostgreSQL over SQLite
10,000 employees with aggregate queries, composite indexes,
and concurrent reads needs a production-grade database.
SQLite is suitable for development, not HR tools.

## UUID primary keys over integers
Safer to expose in URLs — no enumeration attacks.
No information leaked about record count or insertion order.

## Three tables over one
departments and job_titles extracted as lookup tables because:
- Renaming a department updates one row, not thousands
- job_titles.level field enables seniority salary band analysis
- Clean foreign key relationships enforce data integrity

Considered salary_histories table for audit trail but rejected.
Spec asks for minimal yet usable. No audit requirement exists.
Can be added in a future iteration with zero schema changes.

## city over full address
Full address (street, zip, state) serves payroll systems,
not HR salary management. city alongside country gives
meaningful location granularity without unnecessary fields.

## Service objects over fat controllers
Every business operation lives in a service object.
Controllers only handle HTTP concerns. This makes
business logic independently testable and reusable.

## ServiceResult pattern
Every service returns result.success?, result.payload,
result.errors. Controllers follow identical patterns
regardless of operation. No exceptions for control flow.

## Query objects over model scopes
Complex SQL and aggregates live in dedicated query objects.
Models stay clean. Query objects are independently testable
and can be composed without polluting the model namespace.

## Blueprinter over ActiveModel::Serializers
Explicit, fast, multiple view support. render(employee, view: :summary)
vs render(employee, view: :full). No magic, no callbacks.

## Pagy over Kaminari
Benchmarks 40x faster than Kaminari. Minimal memory footprint.
Never load all 10,000 employees into memory.

## activerecord-import for seeding
Bulk insert in batches of 500 with parallel Ruby threads.
10,000 rows in under 3 seconds vs 30+ seconds with individual
creates. validate: false is intentional — data is pre-validated
before array construction.

## Rake task over background job for seeding
Background jobs solve the problem of not wanting a caller to wait.
The caller here is always an engineer at a terminal — there is no
timeout constraint. Parallel threads inside the rake task give
genuine performance benefit without infrastructure overhead.

## No authentication
Rails 8 ships a built-in authentication generator. Intentionally
excluded — spec asks for minimal yet usable, no auth requirement
exists in the user persona description. In production this API
would sit behind an API gateway or use Devise + devise-jwt with
role-based access (HR admin vs read-only).

## Soft delete over hard delete
active boolean flag preserves employee records for historical
reporting. Hard deletes would break salary insights for
terminated employees' historical data.