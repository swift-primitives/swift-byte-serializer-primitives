public import Byte_Primitives
public import Serializer_Primitive
import Serializer_Primitives

extension Byte {

    public struct Serializer<Buffer: RangeReplaceableCollection>
    where Buffer.Element == Byte {
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
        buffer.append(byte)
    }
}
