// Byte.Literal.Serializer.swift
//
// Literal byte sequence emission. The serializer lives in the `Byte.Literal`
// sub-domain per the institute's Domain.Subdomain naming convention: `Byte`
// is the byte-domain namespace; `Literal` is the byte-literal sub-concept;
// `Serializer` is its serialization role.
//
// Symmetric to ``Byte/Literal/Parser`` — the parser matches a fixed byte
// sequence against input; this serializer appends the same fixed sequence
// to a buffer.

public import Byte_Primitives
public import Serializer_Primitive
public import Serializer_Primitives

extension Byte.Literal {
    /// A serializer that emits a fixed byte sequence.
    ///
    /// ``Byte/Literal/Serializer`` appends exact bytes to the buffer. It
    /// accepts `Void` output, making it ideal for delimiters, magic
    /// numbers, and keyword emission.
    public struct Serializer<Buffer: RangeReplaceableCollection>
    where Buffer.Element == Byte {
        @usableFromInline
        let bytes: [Byte]

        /// Creates a serializer that emits the given sequence of bytes.
        @inlinable
        public init(_ bytes: some Swift.Sequence<some Byte.`Protocol`>) {
            self.bytes = Swift.Array(bytes.lazy.map(\.byte))
        }

        /// Creates a serializer that emits the UTF-8 bytes of the given static string.
        @inlinable
        public init(_ string: StaticString) {
            unsafe (
                self.bytes = Swift.Array(
                    string.utf8Start.withMemoryRebound(to: UInt8.self, capacity: string.utf8CodeUnitCount) {
                        unsafe UnsafeBufferPointer(start: $0, count: string.utf8CodeUnitCount)
                    }.lazy.map(Byte.init)
                )
            )
        }
    }
}

extension Byte.Literal.Serializer: Serializer.`Protocol` {
    /// The value consumed on serialization; a fixed-sequence emitter needs no input, so it is `Void`.
    public typealias Output = Void

    /// The error type; appending to a `RangeReplaceableCollection` cannot fail, so it is `Never`.
    public typealias Failure = Never

    /// The composed-serializer body; this serializer is a leaf with no sub-serializers, so it is `Never`.
    public typealias Body = Never

    /// Appends this serializer's fixed byte sequence to the buffer.
    @inlinable
    public func serialize(_ output: Void, into buffer: inout Buffer) {
        buffer.append(contentsOf: bytes)
    }
}

extension Byte.Literal.Serializer: ExpressibleByStringLiteral {
    /// Creates a serializer from a string literal, emitting its UTF-8 bytes.
    @inlinable
    public init(stringLiteral value: String) {
        self.bytes = value.utf8.map(Byte.init)
    }
}

extension Byte.Literal.Serializer: ExpressibleByUnicodeScalarLiteral {
    /// Creates a serializer from a Unicode scalar literal, emitting its UTF-8 bytes.
    @inlinable
    public init(unicodeScalarLiteral value: Unicode.Scalar) {
        self.bytes = String(value).utf8.map(Byte.init)
    }
}

extension Byte.Literal.Serializer: ExpressibleByExtendedGraphemeClusterLiteral {
    /// Creates a serializer from a character literal, emitting its UTF-8 bytes.
    @inlinable
    public init(extendedGraphemeClusterLiteral value: Character) {
        self.bytes = String(value).utf8.map(Byte.init)
    }
}
