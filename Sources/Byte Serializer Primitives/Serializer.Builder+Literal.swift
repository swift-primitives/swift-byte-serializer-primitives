// Serializer.Builder+Literal.swift
//
// Byte-specific `Serializer.Builder` `buildExpression` overload enabling
// bare string literals inside declarative serializer bodies.
//
// String literals infer as `Byte.Literal.Serializer` (the byte-domain
// serializer for literal byte sequences). The overload bridges SwiftPM
// Result Builder's spec-mirroring naming (`buildExpression` — exempt per
// [API-NAME-002] spec-mirroring) into the byte-domain types.

public import Byte_Primitives
public import Serializer_Primitive
import Serializer_Primitives

// MARK: - Serializer.Builder String Literal Support

extension Serializer.Builder
where B: RangeReplaceableCollection, B.Element == Byte {
    /// Enables bare string literals as `Byte.Literal.Serializer` in `var body` builders.
    @inlinable
    public static func buildExpression(
        _ literal: Byte.Literal.Serializer<B>
    ) -> Byte.Literal.Serializer<B> {
        literal
    }

    /// Re-declared generic pass-through for the constrained extension.
    ///
    /// Without this, the `Byte.Literal.Serializer` overload above would
    /// shadow the generic `buildExpression` from the unconstrained
    /// extension, causing non-literal serializers to fail type-checking.
    @inlinable
    public static func buildExpression<S: Serializer.`Protocol`>(
        _ serializer: S
    ) -> S where S.Buffer == B {
        serializer
    }
}
