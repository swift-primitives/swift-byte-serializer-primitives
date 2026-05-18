// Byte.Serializer.swift
//
// Single byte literal emission. The serializer lives in the `Byte` domain
// per the institute's Domain.Subdomain naming convention: `Byte` is the
// byte-domain namespace; `Serializer` is its serialization sub-role.
//
// Internally the serializer writes against `Buffer.Element == UInt8`; the
// API takes `Byte` at the surface so the type-domain story reads at the
// call site.

public import Byte_Primitives
public import Serializer_Namespace
public import Serializer_Primitives_Core

extension Byte {
    /// A serializer that emits a single byte.
    ///
    /// Symmetric to ``Byte/Parser``: where the parser matches an expected
    /// byte from input, the serializer appends a fixed byte to a buffer.
    ///
    /// The value is taken as `Byte` at the API boundary; the buffer is
    /// written as `UInt8` because the buffer's `Element` is `UInt8`. The
    /// Byte type gives consumers a typed-domain anchor for the emitted
    /// value at the call site.
    public struct Serializer<Buffer: RangeReplaceableCollection>
    where Buffer.Element == UInt8 {
        @usableFromInline
        let byte: Byte

        @inlinable
        public init(_ byte: Byte) {
            self.byte = byte
        }
    }
}

extension Byte.Serializer: Serializer.`Protocol` {
    public typealias Output = Void
    public typealias Failure = Never
    public typealias Body = Never

    @inlinable
    public func serialize(_ output: Void, into buffer: inout Buffer) {
        buffer.append(byte.underlying)
    }
}
