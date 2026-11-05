# repo-template

> **Status:** maintained — the starting point for every new repository I create, and the home of the principles audit.

A GitHub template repository that starts a project in a state that already passes the [First-ADE axioms](https://github.com/First-ADE/.github/blob/main/AXIOMS.md) and the six [principles](https://github.com/First-ADE/.github/blob/main/PRINCIPLES.md) I hold every public repository to: open, built in the open, honest, attributed, mine alone, and audited then fixed.

## Use it

1. Click **Use this template** on GitHub (or `gh repo create <name> --template brandon-fox/repo-template --public`).
2. Replace `README.md` with `TEMPLATE_README.md`, fill in the name, the one-line description and the Status line.
3. Fill in `CITATION.cff` (title, repository URL, abstract, date).
4. Delete what the project does not need (`specs/`, `docs/adr/`), keep what it does.
5. Push. The `ade-axioms` workflow runs on the first pull request and fails if any axiom is broken.

## What is in the box

| Path | What it gives a new repository |
|---|---|
| `LICENSE` | MIT, copyright Brandon Fox. Full grant, no strings. |
| `TEMPLATE_README.md` | A README that passes A9 (title on line 1, Status within ten lines) and A8 (Independence section). |
| `.mailmap` | Every commit email I have ever used, mapped to one name. |
| `CITATION.cff` | Machine-readable authorship so GitHub shows a *Cite this repository* button. |
| `CONTRIBUTING.md` | DCO sign-off, signed commits, conventional commit subjects, spec before code. |
| `.github/workflows/ade-axioms.yml` | The nine axioms, run on every push to main and every pull request. |
| `.gitattributes` | LF line endings everywhere. |
| `specs/` and `docs/adr/` | Where the spec and the decisions go. A spec template and an ADR template are included. |
| `scripts/principles_audit.sh` | The audit (below). |

## The principles audit

`scripts/principles_audit.sh` sweeps every public, non-archived, non-fork repository under the owners you name (private repositories are workspaces and vaults, not published work) (default: `brandon-fox`, `First-ADE`, `vindicta-platform`) and prints one Markdown row per repository with a PASS or FAIL for each principle that a script can check:

| Column | Check |
|---|---|
| open | `LICENSE` is MIT with the line `Copyright (c) <year> Brandon Fox`. |
| independent | `README.md` has a `## Independence` section. |
| honest | `README.md` line 1 is a title; a `> **Status:**` line follows within ten lines. |
| attributed | `.mailmap` exists; every recent commit author, after `.mailmap`, is me or a bot. |
| separated | No employer name appears anywhere in the tree. Two repositories (the profile README and the personal site) are allow-listed because they name my employer as career history; no code repository is. |
| secrets | `gitleaks detect` finds nothing. Skipped when gitleaks is not installed. |

```sh
# needs gh (signed in) and git; gitleaks is optional
scripts/principles_audit.sh                      # default owners
scripts/principles_audit.sh brandon-fox          # one owner
PRINCIPLES_WORKDIR=~/audit scripts/principles_audit.sh   # keep the clones between runs
```

The script exits 1 when any cell is FAIL. The point of the exit code is the sixth principle: a FAIL is fixed, not annotated. The baseline run from the day the script was written is in [docs/audit-baseline.md](docs/audit-baseline.md).

## Independence

This is a personal project by Brandon Fox, built on my own time and equipment. It is not affiliated with, endorsed by, or derived from the work of any employer, current or former, and does not represent their views, products or practices. Licensed under the MIT License; principles at [First-ADE/PRINCIPLES.md](https://github.com/First-ADE/.github/blob/main/PRINCIPLES.md).
