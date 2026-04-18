# AI Usage — Prompts and Approach

## Role-based prompting strategy

Before starting development, I assigned specific roles to the AI to get
the most relevant and expert responses. This is a deliberate prompt
engineering technique that significantly improves output quality.

### Backend role (Rails API)

```
You are a senior Ruby on Rails architect with 15+ years experience.
You follow SOLID principles strictly, prefer service objects and query
objects over fat models and fat controllers, write TDD with RSpec,
and care deeply about clean architecture and code readability.
You are opinionated — push back when something violates good design.
```

**Why this role:** I have strong Rails experience, so I used AI primarily
as an architectural sounding board and code reviewer — not as a generator.
The opinionated role meant AI would challenge my decisions, not just
agree with everything.

### Frontend role (React UI)

```
You are a senior React engineer specialising in Bootstrap 5, React Query,
TanStack Table, and Recharts. You write clean JavaScript (not TypeScript),
build accessible UIs, and know how to structure component hierarchies.
You are patient and explain every decision clearly.
```

**Why this role:** I have less React exposure than Rails — I was honest
about this upfront. The "explain every decision clearly" instruction meant
I understood every component before committing it, not just copy-pasting.
This is consistent with Incubyte's expectation of using AI intentionally
while maintaining correctness and quality.

### Result of role-based prompting

- Backend: AI acted as a challenger — I made decisions, AI pressure-tested them
- Frontend: AI acted as a teacher — AI suggested patterns, I asked why before accepting
- Both: AI never drove the work — it responded to my direction

This approach is documented here intentionally — structured AI usage
is a skill, and using AI without a clear role produces generic,
mediocre output.

---

## Philosophy

AI was used throughout this project as a **senior pair programmer** —
a tool for accelerating execution, validating thinking, and generating
boilerplate. Every architectural decision was made deliberately and can
be explained and defended. No code was committed without being read,
understood, and owned.

---

## How AI was used

### Phase 1 — Planning and architecture

Used AI to pressure-test architectural decisions before writing any code.
Key conversations included:

**Evaluating the database schema:**
> "We have one table for everything — is there any reason to split into
> multiple tables with relationships?"

AI suggested departments, job_titles, and salary_histories tables.
I accepted departments and job_titles (rename propagation justifies the
relationship) but **rejected salary_histories** — the spec asks for
minimal yet usable and no audit requirement exists. This was my decision,
not AI's suggestion.

**Evaluating address fields:**
> "Should we add employee address fields?"

AI suggested a full address (street, city, state, zip). I rejected the
full address and chose **city only** — full address serves payroll systems,
not HR salary management. City alongside country gives meaningful location
granularity without unnecessary complexity.

**Seed script approach:**
> "Should we use a background job for the seed script?"

AI initially suggested background jobs. I pushed back — the caller is
always an engineer at a terminal, not a web request with a timeout
constraint. We settled on **parallel Ruby threads inside a rake task** —
genuine performance gain, no infrastructure overhead. I made this call.

**Security — JWT authentication:**
> "Should we add JWT authentication?"

I decided against it. The spec asks for minimal yet usable, and adding
auth would cost 3-4 hours of development time without serving the current
user persona. Documented the reasoning in DECISIONS.md.

**Performance strategy:**
> "When should we add caching and indexes — before or after features work?"

I split performance into two buckets — foundational (indexes, pagination,
bulk insert) built from day one, and layered (caching, ETags, debounce)
added after features worked. This decision was mine — AI validated the
reasoning.

---

### Phase 2 — Development

Used AI to generate boilerplate for established patterns, then reviewed
and modified every file before committing.

**Service objects and query objects:**
> "Generate a service object for employee creation following the
> ServiceResult pattern we discussed"

Generated the boilerplate, reviewed the pattern, confirmed it matched
our architecture decisions before committing.

**RSpec request specs:**
> "Write request specs for the employees CRUD endpoints — include edge
> cases for invalid params and non-existent records"

Reviewed every spec, added country filter spec and hired_on edge cases
based on our data model.

**Seed script:**
> "Write a bulk insert seed script using activerecord-import with
> parallel threads, batches of 500, and a benchmark"

Reviewed the implementation, added the CITIES and CURRENCIES maps,
and tuned the connection pool size after hitting connection timeout
errors in testing.

**React components:**
> "Build an employee table using TanStack Table with search, filter,
> sort and pagination — Bootstrap 5 styling"

For frontend components, I asked AI to explain each pattern before
accepting — why React Query over local state, why TanStack Table over
a plain HTML table, why useDebounce for search. Understanding came
before committing.

---

### Phase 3 — Bug fixes and improvements

Several issues were caught during manual testing that I identified
and directed AI to fix:

**Country filter not applying to all metrics:**
I noticed headcount by department wasn't changing when filtering by
country. Identified the bug — `SalaryInsightsQuery` only filtered
`salary_by_country` and `salary_by_job_title`. Directed the fix to
apply country filter consistently across all methods.

**Currency showing USD regardless of country:**
I noticed India was showing `$` instead of `₹` in stat cards and
top roles table. Identified the root cause — hardcoded `'USD'`
in multiple components. Directed the fix.

**Stat cards showing single country data:**
I noticed total headcount showed 447 instead of 7,511 when all
countries selected. Identified the bug — `data[0]` was being used
instead of aggregating across all countries. Directed the fix to
use a weighted average calculation.

**Hardcoded country names:**
I noticed the country dropdown showed codes (US, IN, GB). Asked AI
for a solution. AI suggested a hardcoded lookup map — I pushed back:

> "This is hardcoded — what if tomorrow we have a different country
> not in this list?"

We switched to `Intl.DisplayNames` API — future-proof, zero maintenance.

**Hardcoded currency map:**
Same pushback on currency mapping:

> "Can we use Intl API to make this dynamic?"

AI was honest — no native Intl API exists for country→currency mapping.
We kept the map but made it exhaustive covering all ISO countries,
with a sensible USD fallback.

---

### Phase 4 — Architecture review

Used AI to review patterns and catch violations:

> "We have queries inside the meta controller — is this following
> our architecture?"

This caught a thin-controller violation. Extracted queries into
`MetaQuery` object in a separate refactor commit — keeping the
git history clean and the pattern consistent.

> "Why are we not using Blueprinter in the insights controller?"

This prompted a good discussion — Blueprinter is for ActiveRecord
objects. Insights returns plain Ruby hashes. Using Blueprinter there
would add indirection with zero benefit. Understanding the why
matters more than applying patterns blindly.

---

## Tools used

| Tool | Usage |
|------|-------|
| Claude (claude.ai) | Primary pair programming — planning, architecture, boilerplate, review |
| GitHub Copilot | Inline suggestions during coding, accepted or rejected based on context |

---

## Key principle

The role-based prompting strategy ensured AI responses were always
expert-level and domain-specific — not generic.