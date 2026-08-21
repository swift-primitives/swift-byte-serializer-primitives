public import Byte_Primitives
public import Serializer_Primitive
import Serializer_Primitives

extension Serializer.Builder
where B: RangeReplaceableCollection, B.Element == Byte {

    @inlinable
    public static func buildExpression(
        _ literal: Byte.Literal.Serializer<B>
    ) -> Byte.Literal.Serializer<B> {
        literal
    }

    @inlinable
    public static func buildExpression<S: Serializer.`Protocol`>(
        _ serializer: S
    ) -> S where S.Buffer == B {
        serializer
    }
}
