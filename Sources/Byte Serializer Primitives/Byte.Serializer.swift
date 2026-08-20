// Byte.Serializer.swift
//
// Single byte literal emission. The serializer lives in the `Byte` domain
// per the institute's Domain.Subdomain naming convention: `Byte` is the
// byte-domain namespace; `Serializer` is its serialization sub-role.

public import Byte_Primitives
public import Serializer_Primitive
import Serializer_Primitives

extension Byte {
    /// A serializer that emits a single byte.
    ///
    /// Symmetric to ``Byte/Parser``: where the parser matches an expected
    /// byte from input, the serializer appends a fixed byte to a buffer.
    public struct Serializer<Buffer: RangeReplaceableCollection>
    where Buffer.Element == Byte {
        @usableFromInline
        let byte: Byte

        /// Creates a serializer that emits the given byte.
        @inlinable
        public init(_ byte: Byte) {
            self.byte = byte
        }
    }
}

extension Byte.Serializer: Serializer.`Protocol` {
    /// The value consumed on serialization; a single-byte emitter needs no input, so it is `Void`.
    public typealias Output = Void

    /// The error type; appending to a `RangeReplaceableCollection` cannot fail, so it is `Never`.
    public typealias Failure = Never

    /// The composed-serializer body; this serializer is a leaf with no sub-serializers, so it is `Never`.
    public typealias Body = Never

    /// Appends this serializer's byte to the buffer.
    @inlinable
    public func serialize(_ output: Void, into buffer: inout Buffer) {
        buffer.append(byte)
    }
}
