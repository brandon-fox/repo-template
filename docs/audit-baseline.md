> Baseline run on the day the script was written, before the hygiene pull requests across these repositories were merged. Every FAIL here has a fix in flight or queued; this file is kept as the before picture.

# Principles audit — 2026-11-05T19:19Z

Owners: brandon-fox First-ADE vindicta-platform. Depth: 50 commits. gitleaks: off.

| repository | open | independent | honest | attributed | separated | secrets |
|---|---|---|---|---|---|---|
| brandon-fox/alos | PASS | PASS | PASS | FAIL (41898282+github-actions[bot]@users.noreply.github.com 49699333+dependabot[bot]@users.noreply.github.com ) | PASS | skipped |
| brandon-fox/brandon-fox | PASS | FAIL | FAIL | FAIL (no .mailmap) | PASS (allow-listed, 1 file(s) mention) | skipped |
| brandon-fox/brandon-fox.github.io | PASS | PASS | PASS | PASS | PASS (allow-listed, 1 file(s) mention) | skipped |
| brandon-fox/Primordia-AI | FAIL | FAIL | FAIL | FAIL (bfox@foxtrot.email ) | PASS | skipped |
| First-ADE/.github | FAIL | FAIL | FAIL | FAIL (bfoxt@users.noreply.github.com ) | PASS | skipped |
| First-ADE/first-ade | FAIL | FAIL | FAIL | FAIL (49699333+dependabot[bot]@users.noreply.github.com bfoxt@users.noreply.github.com ) | PASS | skipped |
| vindicta-platform/.github | FAIL | FAIL | FAIL | FAIL (no .mailmap) | PASS | skipped |
| vindicta-platform/specs | FAIL | FAIL | FAIL | FAIL (41898282+github-actions[bot]@users.noreply.github.com ) | PASS | skipped |
| vindicta-platform/vindicta-engine | FAIL | FAIL | FAIL | FAIL (no .mailmap) | PASS | skipped |
| vindicta-platform/vindicta-foundation | FAIL | FAIL | FAIL | FAIL (bfoxt@users.noreply.github.com ) | PASS | skipped |

**9 repository(ies) with at least one FAIL.** Fix, then re-run; a principle is audited, then fixed, never only annotated.
