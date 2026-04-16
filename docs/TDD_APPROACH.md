# TDD Approach

## Cycle
Every feature follows strict red → green → refactor:

1. test: red   — write failing spec, commit alone, no implementation
2. feat: green — minimum code to pass, commit when specs pass
3. refactor:   — apply patterns, clean up, specs stay green

## Rules
- Never mix test and implementation in the same commit
- Every non-test commit must have all specs passing
- Refactor commits are where SOLID patterns are applied
- No test written after the fact

## Test layers
- spec/models/        — validations, associations, scopes
- spec/services/      — business logic, ServiceResult
- spec/queries/       — SQL correctness, aggregates
- spec/requests/      — full API contract, status codes, JSON shape

## Tools
- RSpec
- FactoryBot
- Shoulda-matchers
- DatabaseCleaner
- Faker