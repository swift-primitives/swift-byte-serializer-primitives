// Byte Serializer Primitives Test Support.swift
//
// Test Support is a thin re-export of the main target plus upstream Byte
// fixtures. Serialization buffers are stdlib `RangeReplaceableCollection`
// (typically `[UInt8]`) — no cursor/slice infrastructure analogous to
// `Byte.Input` is needed on the serializer side.
