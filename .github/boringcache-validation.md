# Moagan cache validation

Qualified for validation of cache reuse across parallel Rust checks, dependency storage deduplication, and reduced cache churn. [Cold and warm run](https://github.com/boringcache/moagan/actions/runs/34322754671).

One v1.21.0 is pinned to `90111526eb218a7f1e119ac2b29f765bd4d82734` and uses GitHub OIDC. One manages dependency archives; the public Cargo adapter manages typed target snapshots and native sccache. Each check has its own target tag and shares dependency/compiler tags.

Both providers use Rust 1.97.1, the upstream two-job Cargo setting, and the same clippy, test, smoke and e2e commands. The baseline uses Swatinem/rust-cache. Formatting and dependency guards also run. Test binaries receive the same runtime environment, including isolation of nested Cargo builds from the outer target directory.

Status: all six BoringCache cold and warm checks passed in [the preceding run](https://github.com/boringcache/moagan/actions/runs/34321522176). The e2e target save uploaded 2 of 250 blobs; its remaining blobs already existed. Some GitHub warm jobs missed because the runner’s unrelated preinstalled Rust version changed its cache key. The fresh comparison retains only the pinned toolchain on both providers and requires a GitHub warm hit. The next real upstream revision remains to be run. Earlier harness runs that suppressed target publication are excluded.

The report will distinguish logical target size, compressed cache size and newly uploaded blobs. Summing overlapping cache-entry sizes does not measure unique storage. CI results do not establish local-machine or cross-worktree reuse.
