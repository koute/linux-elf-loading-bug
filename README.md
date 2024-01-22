### Running locally (building from source)

```
cd reproduction
cargo run --release
```

Requires Rust and LLD to be installed.

### Running locally (prebuilt binary)

```
./bin/bug-reproduction
```

### Running under qemu for a given kernel image

```
./prepare.sh
./run-for-kernel.sh /path/to/bzImage
```

### Bisecting

```
git clone https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
./bisect.sh
```
