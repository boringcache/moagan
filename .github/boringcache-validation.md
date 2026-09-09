# Moagan cache validation

Current workflows pin [One v1.30.0](https://github.com/boringcache/one/releases/tag/v1.30.0) at `a610ec5a564efd9b360925056dbade04deb5def6`. Measurements below are from v1.21.0.

**Qualified.** All 36 workload checks passed: six checks on each provider, across cold, fresh-runner warm and a real upstream revision. Formatting and dependency guards also passed. [Cold/warm run](https://github.com/boringcache/moagan/actions/runs/34322754671) · [Revision run](https://github.com/boringcache/moagan/actions/runs/34322956237) · [Measurements](boringcache-validation.json).

The measured runs used One v1.21.0 at `90111526eb218a7f1e119ac2b29f765bd4d82734` with GitHub OIDC. One manages dependency archives; the public Cargo adapter manages typed target snapshots and native sccache. Both providers use only Rust 1.97.1, the upstream two-job Cargo setting and the same checks. GitHub warm jobs require an exact cache hit.

Each cell is **GitHub / BoringCache whole-job seconds**:

| Check | Cold | Warm | Next revision |
|---|---:|---:|---:|
| Clippy | 157 / 171 | 66 / 33 | 67 / 73 |
| Integration tests | 306 / 320 | 194 / 147 | 189 / 231 |
| Library and binary tests | 199 / 181 | 115 / 62 | 94 / 168 |
| Smoke | 198 / 227 | 114 / 89 | 112 / 124 |
| End-to-end | 195 / 213 | 94 / 58 | 90 / 91 |
| Documentation | 165 / 122 | 65 / 36 | 67 / 92 |

The six BoringCache warm jobs restored **18 target/dependency entries**, with zero reported cache errors and no uploads. On the real revision, Clippy published its 780 MB target in 2.3 seconds and needed **9 of 146 blobs** uploaded. The existing blobs were reused.

BoringCache was faster on all six warm jobs in this sample; GitHub was faster on the revision jobs. Complete target retention improves warm reuse but adds publication work after source changes. Swatinem prunes target contents, including test executables, so cache-entry size sums do not compare equivalent retained data. Unique physical storage savings are not quantified here.

These are single samples. Cold uses new tags in a shared workspace whose content can already exist. Cross-worktree and local-machine reuse are not established by these CI runs.
