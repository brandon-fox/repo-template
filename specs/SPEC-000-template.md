# SPEC-000: Feature name

- **Status:** draft | accepted | implemented | superseded
- **Owner:** Brandon Fox
- **Traces to:** tests/features/<name>.feature (fill in when the acceptance file exists)

## Feature: one line that names the capability

As a <who>, I want <what>, so that <why>.

### Scenario: the normal case

- **Given** the starting state
- **When** the action happens
- **Then** the observable result
- **And** anything else that must be true afterwards

### Scenario: the case that must fail

- **Given** a starting state that is not allowed
- **When** the same action is attempted
- **Then** it is refused, and how the refusal is visible

## Invariants

Sentences that must hold before and after every scenario above. Each one should be checkable; if it is not, it belongs in the Notes.

## Notes

Open questions, things deliberately out of scope, and links to the decision records that shaped this spec.
