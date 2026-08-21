import Byte_Serializer_Primitives_Test_Support
import Testing

@Suite
struct `Byte.Serializer Tests` {
    @Suite struct Unit {}
    @Suite struct `Edge Case` {}
    @Suite struct Integration {}
    @Suite(.serialized) struct Performance {}
}

extension `Byte.Serializer Tests`.Unit {
    @Test
    func `appends expected byte to buffer`() {
        let serializer = Byte.Serializer<[Byte]>(0x41)
        var buffer: [Byte] = []

        serializer.serialize((), into: &buffer)

        #expect(buffer == [0x41])
    }

    @Test
    func `appends to non-empty buffer`() {
        let serializer = Byte.Serializer<[Byte]>(0xFF)
        var buffer: [Byte] = [0x01, 0x02]

        serializer.serialize((), into: &buffer)

        #expect(buffer == [0x01, 0x02, 0xFF])
    }

    @Test
    func `init takes Byte type at API surface`() {
        let value: Byte = 0x42
        let serializer = Byte.Serializer<[Byte]>(value)
        var buffer: [Byte] = []

        serializer.serialize((), into: &buffer)

        #expect(buffer == [0x42])
    }

    @Test
    func `Byte literal flows through ExpressibleByIntegerLiteral`() {

        let serializer = Byte.Serializer<[Byte]>(0x55)
        var buffer: [Byte] = []
        serializer.serialize((), into: &buffer)
        #expect(buffer == [0x55])
    }
}

extension `Byte.Serializer Tests`.`Edge Case` {
    @Test
    func `zero byte emits correctly`() {
        let serializer = Byte.Serializer<[Byte]>(0x00)
        var buffer: [Byte] = []
        serializer.serialize((), into: &buffer)
        #expect(buffer == [0x00])
    }

    @Test
    func `max byte emits correctly`() {
        let serializer = Byte.Serializer<[Byte]>(0xFF)
        var buffer: [Byte] = []
        serializer.serialize((), into: &buffer)
        #expect(buffer == [0xFF])
    }
}

extension `Byte.Serializer Tests`.Integration {
    @Test
    func `Byte.zero constant flows through serializer init`() {
        let serializer = Byte.Serializer<[Byte]>(Byte.zero)
        var buffer: [Byte] = []
        serializer.serialize((), into: &buffer)
        #expect(buffer == [0x00])
    }

    @Test
    func `Byte.max constant flows through serializer init`() {
        let serializer = Byte.Serializer<[Byte]>(Byte.max)
        var buffer: [Byte] = []
        serializer.serialize((), into: &buffer)
        #expect(buffer == [0xFF])
    }

    @Test(arguments: UInt8.min...UInt8.max)
    func `serializes byte value`(_ i: UInt8) {
        let serializer = Byte.Serializer<[Byte]>(Byte(i))
        var buffer: [Byte] = []
        serializer.serialize((), into: &buffer)
        #expect(buffer == [Byte(i)])
    }

    @Test
    func `convenience serialize returns buffer`() {
        let serializer = Byte.Serializer<[Byte]>(0x42)
        let buffer: [Byte] = serializer.serialize(())
        #expect(buffer == [0x42])
    }
}
