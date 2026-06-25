import Byte_Serializer_Primitives_Test_Support
import Testing

// MARK: - Test Suite Structure

@Suite
struct `Byte.Literal.Serializer Tests` {
    @Suite struct Unit {}
    @Suite struct `Edge Case` {}
    @Suite struct Integration {}
    @Suite(.serialized) struct Performance {}
}

// MARK: - Unit Tests

extension `Byte.Literal.Serializer Tests`.Unit {
    @Test
    func `emits byte sequence to buffer`() {
        let serializer = Byte.Literal.Serializer<[Byte]>([0x48, 0x65, 0x6C] as [Byte])
        var buffer: [Byte] = []

        serializer.serialize((), into: &buffer)

        #expect(buffer == [0x48, 0x65, 0x6C])
    }

    @Test
    func `string literal construction emits UTF-8 bytes`() {
        let serializer: Byte.Literal.Serializer<[Byte]> = "OK"
        var buffer: [Byte] = []

        serializer.serialize((), into: &buffer)

        #expect(buffer == "OK".utf8.map(Byte.init))
    }

    @Test
    func `appends to non-empty buffer`() {
        let serializer: Byte.Literal.Serializer<[Byte]> = "end"
        var buffer: [Byte] = [0x21]

        serializer.serialize((), into: &buffer)

        #expect(buffer == [0x21] + "end".utf8.map(Byte.init))
    }
}

// MARK: - Edge Case Tests

extension `Byte.Literal.Serializer Tests`.`Edge Case` {
    @Test
    func `empty literal emits nothing`() {
        let serializer = Byte.Literal.Serializer<[Byte]>([] as [Byte])
        var buffer: [Byte] = [0x01, 0x02]

        serializer.serialize((), into: &buffer)

        #expect(buffer == [0x01, 0x02])
    }

    @Test
    func `StaticString init produces matching bytes`() {
        let serializer = Byte.Literal.Serializer<[Byte]>("xyz" as StaticString)
        var buffer: [Byte] = []

        serializer.serialize((), into: &buffer)

        #expect(buffer == "xyz".utf8.map(Byte.init))
    }
}

// MARK: - Integration Tests

extension `Byte.Literal.Serializer Tests`.Integration {
    @Test
    func `Byte.Literal.Serializer composes with Byte.Serializer`() {
        let prefix: Byte.Literal.Serializer<[Byte]> = "hi"
        let suffix = Byte.Serializer<[Byte]>(0x21)  // '!'
        var buffer: [Byte] = []

        prefix.serialize((), into: &buffer)
        suffix.serialize((), into: &buffer)

        #expect(buffer == "hi!".utf8.map(Byte.init))
    }

    @Test
    func `emits long literal`() {
        let bytes: [Byte] = Swift.Array(repeating: Byte(0x61), count: 1024)
        let serializer = Byte.Literal.Serializer<[Byte]>(bytes)
        var buffer: [Byte] = []

        serializer.serialize((), into: &buffer)

        #expect(buffer == bytes)
    }

    @Test
    func `convenience serialize returns buffer`() {
        let serializer: Byte.Literal.Serializer<[Byte]> = "hello"
        let buffer: [Byte] = serializer.serialize(())
        #expect(buffer == "hello".utf8.map(Byte.init))
    }
}
