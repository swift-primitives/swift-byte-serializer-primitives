# Byte Serializer Primitives

![Development Status](https://img.shields.io/badge/status-active--development-blue.svg)

Byte-element serializer combinators for Swift — `Byte.Serializer` emits a single byte to a buffer and `Byte.Literal.Serializer` emits a fixed byte sequence, built on the buffer-agnostic combinator algebra in [`swift-serializer-primitives`](https://github.com/swift-primitives/swift-serializer-primitives).

---

## Quick Start

`Byte.Serializer` and `Byte.Literal.Serializer` are the byte-domain leaves of the serializer algebra: the single-byte and fixed-sequence emitters that the buffer-agnostic combinators in [`swift-serializer-primitives`](https://github.com/swift-primitives/swift-serializer-primitives) compose. They mirror the parser-side split between [`swift-byte-parser-primitives`](https://github.com/swift-primitives/swift-byte-parser-primitives) and [`swift-parser-primitives`](https://github.com/swift-primitives/swift-parser-primitives). Both the emitted values and the buffer element are `Byte_Primitives.Byte` — the institute's binary-data byte type — so the byte domain is preserved end to end rather than dropping to `UInt8`.

```swift
import Byte_Serializer_Primitives

let serializer = Byte.Serializer<[Byte]>(0x41)   // 0x41 inferred as Byte
var buffer: [Byte] = []
serializer.serialize((), into: &buffer)          // buffer == [0x41]

let literal: Byte.Literal.Serializer<[Byte]> = "OK"
var greeting: [Byte] = []
literal.serialize((), into: &greeting)           // greeting == [0x4F, 0x4B]
```

`Byte.Literal.Serializer` is `ExpressibleByStringLiteral`, so fixed byte sequences — delimiters, magic numbers, keywords — can be written as string literals and emitted as their UTF-8 bytes. Inside a `Serializer.Builder` body whose buffer element is `Byte`, those bare string literals infer as `Byte.Literal.Serializer` directly.

---

## Installation

```swift
dependencies: [
    .package(url: "https://github.com/swift-primitives/swift-byte-serializer-primitives.git", branch: "main")
]
```

```swift
.target(
    name: "App",
    dependencies: [
        .product(name: "Byte Serializer Primitives", package: "swift-byte-serializer-primitives"),
    ]
)
```

The package is pre-1.0 — until 0.1.0 is tagged, depend on `branch: "main"` rather than `from: "0.1.0"`. Requires Swift 6.3.1 and macOS 26 / iOS 26 / tvOS 26 / watchOS 26 / visionOS 26 (or the matching Linux / Windows toolchain).

---

## Architecture

| Product | Target | Purpose |
|---------|--------|---------|
| `Byte Serializer Primitives` | `Sources/Byte Serializer Primitives/` | `Byte.Serializer` — a single-byte emitter. `Byte.Literal.Serializer` — a fixed byte-sequence emitter. Output `Void`, failure `Never`. Both are generic over `Buffer: RangeReplaceableCollection where Buffer.Element == Byte`. |
| `Byte Serializer Primitives Test Support` | `Tests/Support/` | Re-export spine carrying upstream `Byte` test support to test consumers. |

Dependencies: `swift-serializer-primitives` (for the `Serializer` namespace, `Serializer.Protocol`, and `Serializer.Builder`) and `swift-byte-primitives` (for the `Byte` type at the API surface).

Foundation-free.

---

## Platform Support

| Platform | Status |
|----------|--------|
| macOS 26 | Full support |
| Linux | Full support |
| Windows | Full support |
| iOS / tvOS / watchOS / visionOS | Supported |

---

## Mirror Relationship to swift-byte-parser-primitives

| Parser side | Serializer side |
|-------------|-----------------|
| `Byte.Parser<Input>` matches one byte from input | `Byte.Serializer<Buffer>` emits one byte to a buffer |
| `Byte.Literal.Parser<Input>` matches a fixed sequence | `Byte.Literal.Serializer<Buffer>` emits a fixed sequence |
| `Failure = Either<EndOfInput.Error, Match.Error>` | `Failure = Never` (emitting to `RangeReplaceableCollection` is infallible) |
| `Byte.Input` is the canonical streaming cursor | (no analog — buffers are `RangeReplaceableCollection<Byte>`; `[Byte]` is the natural concrete choice) |
| `parse(_:into:)` consumes input | `serialize(_:into:)` appends to buffer |

Serializers are one-way per `Serializer.Protocol`; the parser side carries a separate `Parser.Printer` conformance for reverse emission, but the serializer side has no analogous reverse role because serialization is its sole direction.

---

## Relationship to Other Packages

- [`swift-serializer-primitives`](https://github.com/swift-primitives/swift-serializer-primitives) — Buffer-agnostic combinator algebra (Map, Filter, Many, Sequence, Literal, Optional, …). This package depends on it.
- [`swift-byte-primitives`](https://github.com/swift-primitives/swift-byte-primitives) — The `Byte` value type. This package depends on it.
- [`swift-byte-parser-primitives`](https://github.com/swift-primitives/swift-byte-parser-primitives) — Sibling parser package; this package mirrors its surface on the serialization side.

---

## Community

<!-- BEGIN: discussion -->
<!-- Discussion thread created at publication. -->
<!-- END: discussion -->

## License

Apache 2.0. See [LICENSE.md](LICENSE.md).
