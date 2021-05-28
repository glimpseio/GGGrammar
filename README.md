# GGSpec

[![Build Status](https://github.com/glimpseio/GGSpec/workflows/GGSpec%20CI/badge.svg?branch=main)](https://github.com/glimpseio/GGSpec/actions)
[![Swift Package Manager compatible](https://img.shields.io/badge/SPM-compatible-brightgreen.svg)](https://github.com/apple/swift-package-manager)
[![Platform](https://img.shields.io/badge/Platforms-macOS%20|%20iOS%20|%20Windows%20|%20tvOS%20|%20watchOS%20|%20Linux-lightgrey.svg)](https://github.com/glimpseio/GGSpec)
[![](https://tokei.rs/b1/github/glimpseio/GGSpec)](https://github.com/glimpseio/GGSpec)

GGSpec contains a collection of `Codable` swift value types (structs and enums) generated from the Vega schema. 

It enables reading, modifying, and writing JSON in the vega-lite grammar with a type-safe Swift API.

This cross-platform library contains only the raw value types for the visualiztion grammar. To render the specifications into an image, the higher-level [GGViz](https://github.com/glimpseio/GGViz) package can be used.

The version numbers follow the Vega Lite specification version; new versions are automatically built periodically from the [Actions](https://github.com/glimpseio/GGSpec/actions).

The source of the generated schema is a single ~5M (~66K SLOC) [GGSchema.swift](https://github.com/glimpseio/GGSpec/blob/main/Sources/GGSpec/GGSchema.swift?raw=true) source file.

The only dependency of this project is [BricBrac](https://github.com/glimpseio/BricBrac/), which is used for representing the `JSONSchema` types.

The following unit test from [GGSpecTests.swift](https://github.com/glimpseio/GGSpec/blob/main/Tests/GGSpecTests/GGSpecTests.swift) illustrates the API & featues:

```swift 
import GGSpec

let specJSON = """
{
    "mark": "bar",
    "data": {
        "values": [
            { "a": "CAT1", "b": 5.6 },
            { "a": "CAT2", "b": 0.1 }
        ]
    },
    "encoding": {
        "x": { "field": "a" },
        "y": { "field": "b" }
    }
}
"""

// parse the GGSpec from the JSON literal…
let parsedSpec = try TopLevelUnitSpec.parseJSON(specJSON)

// …and also create the same spec in code
var codeSpec = TopLevelUnitSpec(data:
    TopLevelUnitSpec.DataChoice(
        DataProvider(
            DataSource(
                InlineData(values:
                            InlineDataset([
                                ["a": "CAT1", "b": 5.6],
                                ["a": "CAT2", "b": 0.1]
                            ])
                )
            )
        )
    ),
    mark: AnyMark(.bar))

// initialize the encodings with a single `x` scaled to the `a` field…
codeSpec.encoding = FacetedEncoding(x:
    FacetedEncoding.EncodingX(
        FacetedEncoding.X(
            PositionFieldDef(field: .init(FieldName("a"))))))

// …then add a `y` encoding scaled to the `b` field
codeSpec.encoding!.y = FacetedEncoding.EncodingY(
    FacetedEncoding.Y(
        PositionFieldDef(field: .init(FieldName("b")))))

#if canImport(ObjectiveC) // *sigh* Apple
let expectedJSON = """
{"data":{"values":[{"a":"CAT1","b":5.5999999999999996},{"a":"CAT2","b":0.10000000000000001}]},"encoding":{"x":{"field":"a"},"y":{"field":"b"}},"mark":"bar"}
"""
#else // Linux FTW
let expectedJSON = """
{"data":{"values":[{"a":"CAT1","b":5.6},{"a":"CAT2","b":0.1}]},"encoding":{"x":{"field":"a"},"y":{"field":"b"}},"mark":"bar"}
"""
#endif

XCTAssertEqual(expectedJSON, codeSpec.jsonDebugDescription)

XCTAssertEqual(parsedSpec, codeSpec)
```




