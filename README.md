# GGSpec

GGSpec contains a collection of `Codable` swift value types (structs an enums) generated from the Vega schema. 

It enables reading, modifying, and writing JSON in the Vega grammar format with a type-safe Swift API.

This cross-platform library contains only the raw value types. To render the specifications into an image, a higher-level project that uses native rendering (like Glance) can be layered atop this module.

The version numbers follow the Vega Lite specification version; new versions are automatically built periodically from the [Actions](https://github.com/glimpseio/GGSpec/actions).

The source of the generated schema is a single ~5M (~66K SLOC) [GGSchema.swift](https://github.com/glimpseio/GGSpec/blob/main/Sources/GGSpec/GGSchema.swift?raw=true) source file.

The only dependency of this project is [BricBrac](https://github.com/glimpseio/BricBrac/), which is used for representing the `JSONSchema` types..

