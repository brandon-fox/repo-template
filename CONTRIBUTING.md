# Contributing

Everything here is MIT licensed and built in the open. Issues and pull requests are welcome; this file says what a change needs so it can merge.

## Before the code

The spec comes first. A behaviour change starts with a specification in `specs/` (loose Gherkin: Feature, Scenario, Given, When, Then) or a decision record in `docs/adr/`. If the change is small enough that a spec would be silly, say so in the pull request.

## Every commit

- **Signed.** Set up [commit signing](https://docs.github.com/en/authentication/managing-commit-signature-verification) (SSH keys are fine). Axiom A7 rejects unsigned commits.
- **Signed off.** `git commit -s` adds a `Signed-off-by` line, which is your [Developer Certificate of Origin](https://developercertificate.org/) statement that you have the right to submit the change under this repository's MIT license.
- **Conventional subject.** `feat(scope): …`, `fix(scope): …`, `docs: …`, `chore: …`. The body says why, not what; the diff already says what.
- **Attributed.** Commit as yourself. If an AI tool produced part of the change, keep it in the trailers (`Co-Authored-By:`), so authorship is honest both ways.

## Every pull request

- CI must be green: the First-ADE axioms, plus whatever this repository adds.
- One concern per pull request.
- If the change makes the README's Status line wrong, update it in the same pull request.

## Independence

This project is personal work by Brandon Fox and is not affiliated with any employer. Contributions are accepted on the same basis: your own work, under your own name, under the MIT License.
