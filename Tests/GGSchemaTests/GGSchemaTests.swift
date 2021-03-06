import XCTest
import Curio
import BricBrac
import GGSchema

#if canImport(FoundationNetworking)
import FoundationNetworking // needed for networking on Linux
#endif

final class GGSchemaTests: XCTestCase {
    func testDecoding() {
        XCTAssertEqual(["XYZ"], try Bric.parse("[\"XYZ\"]"))
    }

    func testExampleSpec() throws {
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

//        // parse the GGSchema from the JSON literal…
//        let parsedSpec = try GG.TopLevelUnitSpec.parseJSON(specJSON)
//
//        // …and also create the same spec in code
//        var codeSpec = GG.TopLevelUnitSpec(data:
//                                            GG.TopLevelUnitSpec.DataChoice(
//                                                GG.DataProvider(
//                                                    GG.DataSource(
//                                                        GG.InlineData(values:
//                                                                        GG.InlineDataset([
//                                        ["a": "CAT1", "b": 5.6],
//                                        ["a": "CAT2", "b": 0.1]
//                                    ])
//                        )
//                    )
//                )
//            ),
//                                           mark: GG.AnyMark(.bar))
//
//        // initialize the encodings with a single `x` scaled to the `a` field…
//        codeSpec.encoding = GG.EncodingChannelMap(x:
//                                                    GG.EncodingChannelMap.XEncoding(
//                                                        GG.EncodingChannelMap.X(
//                                                            GG.PositionFieldDef(field: .init(GG.FieldName("a"))))))
//
//        // …then add a `y` encoding scaled to the `b` field
//        codeSpec.encoding!.y = GG.EncodingChannelMap.YEncoding(
//            GG.EncodingChannelMap.Y(
//                GG.PositionFieldDef(field: .init(GG.FieldName("b")))))
//
//        #if canImport(ObjectiveC) // *sigh* Apple
//        let expectedJSON = """
//        {"data":{"values":[{"a":"CAT1","b":5.5999999999999996},{"a":"CAT2","b":0.10000000000000001}]},"encoding":{"x":{"field":"a"},"y":{"field":"b"}},"mark":"bar"}
//        """
//        #else // Linux FTW
//        let expectedJSON = """
//        {"data":{"values":[{"a":"CAT1","b":5.6},{"a":"CAT2","b":0.1}]},"encoding":{"x":{"field":"a"},"y":{"field":"b"}},"mark":"bar"}
//        """
//        #endif
//
//        XCTAssertEqual(expectedJSON, codeSpec.jsonDebugDescription)
//
//        XCTAssertEqual(parsedSpec, codeSpec)
    }

    func testCurio() {
        _ = Curio()
    }
}

#if os(Linux) || os(macOS) // or any OS that can run an NSTask…

let codeDir = URL(fileURLWithPath: #file)
    .deletingLastPathComponent() // Tests/GGSchemaTests/
    .deletingLastPathComponent() // Tests/
    .deletingLastPathComponent() // .
    .appendingPathComponent("Sources") // Sources/
    .appendingPathComponent("GGSchema") // Sources/GGSchema/

final class GGSchemaGenerator: XCTestCase {
    static let rootName = "GGSchema"
    static let moduleName = "GGGrammar"

    /// Download the latest schema
    func testGGSchemaGeneration() throws {
        let _ = try generateGGSchema()
    }
}

private extension GGSchemaGenerator {
    private func generateGGSchema(from url: URL = URL(string: "https://vega.github.io/schema/vega-lite/v5.json")!) throws -> Bool {
        // download the latest schema and generate the GGSchema.swift
        let source = try String(contentsOf: url)
        let json = try JSONSchema.impute(source)

        var curio = Curio()
        curio.registryTypeName = "GGSchema"
        curio.conformances = [.init(name: "GGType")]
        // curio.includeSchemaSourceVar = "GGSchema.schemaSource" // include the raw source string

        curio.accessor = { _ in .`public` }
        curio.anyOfAsOneOf = true
        //curio.imports.append("struct Foundation.UUID") // for UUID

        curio.indirectCountThreshold = 80 // Config has about 62 fields

        fixup(&curio)

        let schemas: [(String, JSONSchema)] = try JSONSchema.generate(json, rootName: nil)

        let module = try curio.assemble(schemas, rootName: nil)
        module.imports.append("struct Foundation.UUID") // for UUID
        module.namespace = "GG" // wrap everything in a top-level "GG" namespace

        return try curio.emit(module, name: GGSchemaGenerator.rootName + ".swift", dir: codeDir.path, source: source)
    }

    private func fixup(_ curio: inout Curio) {
        let renames = [
            "#/definitions/Data": "DataProvider", // `Data` conflicts with Swift's built-in Data type

            "#/definitions/Axis": "AxisDef",
            "#/definitions/Legend": "LegendDef",
            "#/definitions/Scale": "ScaleDef",
            "#/definitions/Header": "HeaderDef",

            "#/definitions/FacetedEncoding": "EncodingChannelMap",
            "#/definitions/Config": "ConfigTheme",
            "#/definitions/Transform": "DataTransformation",
            "#/definitions/Field": "SourceColumnRef",

            "#/definitions/MarkType": "VgMarkType",

            "#/definitions/Type": "MeasureType", // `Type` is a reserved name in Swift
            "#/definitions/Mark": "PrimitiveMarkType", // `Mark` is too generic a name for the enum
            "#/definitions/BoxPlot": "BoxPlotLiteral",
            "#/definitions/ErrorBar": "ErrorBarLiteral",
            "#/definitions/ErrorBand": "ErrorBandLiteral",

            "#/definitions/StandardType": "StandardMeasureType",

            "#/definitions/Binding": "BindControl",
            "#/definitions/Text": "StringList",

            "#/definitions/Color": "ColorLiteral",
            "#/definitions/Gradient": "ColorGradient",
            "#/definitions/LinearGradient": "ColorGradientLinear",
            "#/definitions/RadialGradient": "ColorGradientRadial",

            // work around an ambigious type bug in the generator (there are two ConditionalPredicateValueDefStringNullExpr types generated otherwise)
            "#/definitions/ConditionalPredicate<ValueDef<(string|null|ExprRef)>>": "ConditionalPredicateValueDefStringNullExprReference",

            "#/definitions/TimeInterval": "TemporalUnit", // `TimeInterval` conflicts with the Foundation type
            //"#/definitions/Stream": "StreamChoice", // `Stream` conflicts with the Foundation type

        ]

        curio.renamer = { (parents, id) in
            let key = (parents + [id]).joined(separator: ".")
            return renames[id] ?? renames[key]
        }


        /// Remove all Spec permutations, since they take up a lot of time and make a huge file (65M vs. 21M after removal) – we instead use our own hand-rolled VizSpec which aggregates all the specs into a single type with only a small loss of validation expressiveness.
        /// The types that we exclude are significant because they may include other types.
        /// Without excluding them, the generated specs would be:
        ///
        /// ```
        /// typealias Spec = OneOf7<FacetedUnitSpec, LayerSpec, RepeatSpec, FacetSpec, ConcatSpecGenericSpec, VConcatSpecGenericSpec, HConcatSpecGenericSpec>
        ///
        /// typealias TopLevelSpec = OneOf7<TopLevelUnitSpec, TopLevelFacetSpec, TopLevelLayerSpec, TopLevelRepeatSpec, TopLevelNormalizedConcatSpecGenericSpec, TopLevelNormalizedVConcatSpecGenericSpec, TopLevelNormalizedHConcatSpecGenericSpec>
        ///
        /// typealias NormalizedSpec = OneOf7<FacetedUnitSpec, LayerSpec, RepeatSpec, NormalizedFacetSpec, NormalizedConcatSpecGenericSpec, NormalizedVConcatSpecGenericSpec, NormalizedHConcatSpecGenericSpec>
        ///
        /// typealias RepeatSpec = OneOf2<NonLayerRepeatSpec, LayerRepeatSpec>
        /// ```
        ///
        /// Referencing `NormalizedSpec` are: `NormalizedConcatSpecGenericSpec`, `NormalizedHConcatSpecGenericSpec`,  `NormalizedVConcatSpecGenericSpec`, `TopLevelNormalizedConcatSpecGenericSpec`, `TopLevelNormalizedHConcatSpecGenericSpec`, and `TopLevelNormalizedVConcatSpecGenericSpec`

        curio.excludes = [
            // "TopLevelUnitSpec",
            "Spec", // FacetedUnitSpec | LayerSpec | RepeatSpec | FacetSpec | ConcatSpecGenericSpec | VConcatSpecGenericSpec | HConcatSpecGenericSpec
             "TopLevelRepeatSpec",
            "UnitSpec",
            "UnitSpecWithFrame",
            "GenericUnitSpecEncodingAnyMark", // “A unit specification, which can contain either [primitive marks or composite marks](https://vega.github.io/vega-lite/docs/mark.html#types)”
            "NormalizedSpec", // FacetedUnitSpec | LayerSpec | RepeatSpec | NormalizedFacetSpec | NormalizedConcatSpecGenericSpec | NormalizedVConcatSpecGenericSpec | NormalizedHConcatSpecGenericSpec

            "TopLevelSpec", // TopLevelUnitSpec | TopLevelFacetSpec | TopLevelLayerSpec | TopLevelRepeatSpec | TopLevelNormalizedConcatSpecGenericSpec | TopLevelNormalizedVConcatSpecGenericSpec | TopLevelNormalizedHConcatSpecGenericSpec
            "NonNormalizedSpec",
            "TopLevelRepeatSpecTypes",
            "TopLevelConcatSpec",
            "TopLevelLayerSpec",
            "TopLevelFacetSpec",
            "TopLevelHConcatSpec",
            "TopLevelVConcatSpec",

            "LayerRepeatSpec",
            "NonLayerRepeatSpec",

            "ConcatSpecGenericSpec",
            "HConcatSpecGenericSpec",
            "VConcatSpecGenericSpec",

            "FacetedUnitSpec",
            "FacetSpec",
            "RepeatSpec",
            "LayerSpec",
            "ConcatSpec",
            "HConcatSpec",
            "VConcatSpec",
    //        "Encoding", // we should only be using "EncodingChannelMap"; all specs that reference "Encoding" (e.g., "GenericUnitSpecEncodingAnyMark") should not be removed


            // thowing all these in here – there may be some duplicates

    //        "FacetedUnitSpec", "LayerSpec", "RepeatSpec", "FacetSpec", "ConcatSpecGenericSpec", "VConcatSpecGenericSpec", "HConcatSpecGenericSpec",
    //        "TopLevelFacetSpec", "TopLevelLayerSpec", "TopLevelRepeatSpec", "TopLevelNormalizedConcatSpecGenericSpec", "TopLevelNormalizedVConcatSpecGenericSpec", "TopLevelNormalizedHConcatSpecGenericSpec",
    //        "FacetedUnitSpec", "LayerSpec", "RepeatSpec", "NormalizedFacetSpec", "NormalizedConcatSpecGenericSpec", "NormalizedVConcatSpecGenericSpec", "NormalizedHConcatSpecGenericSpec",
    //        "NonLayerRepeatSpec", "LayerRepeatSpec",
        ]

        // manually specify some inirections so the generated `Config` doesn't blow up the stack for background queues
        curio.propertyIndirects = [
            "ConfigTheme.axisBand",
            "ConfigTheme.axis",
            "ConfigTheme.axisBand",
            "ConfigTheme.axisX",
            "ConfigTheme.axisY",
            "ConfigTheme.axisBottom",
            "ConfigTheme.axisDiscrete",
            "ConfigTheme.axisLeft",
            "ConfigTheme.axisPoint",
            "ConfigTheme.axisQuantitative",
            "ConfigTheme.axisRight",
            "ConfigTheme.axisTemporal",
            "ConfigTheme.axisTop",
            "ConfigTheme.axisXBand",
            "ConfigTheme.axisXDiscrete",
            "ConfigTheme.axisXPoint",
            "ConfigTheme.axisXQuantitative",
            "ConfigTheme.axisXTemporal",
            "ConfigTheme.axisYBand",
            "ConfigTheme.axisYDiscrete",
            "ConfigTheme.axisYPoint",
            "ConfigTheme.axisYQuantitative",
            "ConfigTheme.axisYTemporal",

            "ConfigTheme.header",
            "ConfigTheme.headerColumn",
            "ConfigTheme.headerFacet",
            "ConfigTheme.headerRow",

            "ConfigTheme.mark",
            "ConfigTheme.arc",
            "ConfigTheme.area",
            "ConfigTheme.bar",
            "ConfigTheme.circle",
            "ConfigTheme.line",
            "ConfigTheme.image",
            "ConfigTheme.geoshape",
            "ConfigTheme.point",
            "ConfigTheme.rect",
            "ConfigTheme.rule",
            "ConfigTheme.square",
            "ConfigTheme.text",
            "ConfigTheme.tick",
            "ConfigTheme.trail",
            
            "ConfigTheme.selection",
            "ConfigTheme.projection",
            "ConfigTheme.range",
            "ConfigTheme.title",
            "ConfigTheme.view",
            "ConfigTheme.scale",
            "ConfigTheme.legend",
            "ConfigTheme.facet",
            "ConfigTheme.concat",
            "ConfigTheme.boxplot",
            "ConfigTheme.errorbar",
            "ConfigTheme.errorband",

            // there's a bug that forces us to use both the un-pretified and pretified versions of the keys
            "StyleConfigIndex.group-subtitle",
            "StyleConfigIndex.group-title",
            "StyleConfigIndex.guide-label",
            "StyleConfigIndex.guide-title",
            "StyleConfigIndex.groupsubtitle",
            "StyleConfigIndex.grouptitle",
            "StyleConfigIndex.guidelabel",
            "StyleConfigIndex.guidetitle",

            "StyleConfigIndex.arc",
            "StyleConfigIndex.area",
            "StyleConfigIndex.bar",
            "StyleConfigIndex.circle",
            "StyleConfigIndex.geoshape",
            "StyleConfigIndex.image",
            "StyleConfigIndex.line",
            "StyleConfigIndex.mark",
            "StyleConfigIndex.point",
            "StyleConfigIndex.rect",
            "StyleConfigIndex.rule",
            "StyleConfigIndex.square",
            "StyleConfigIndex.text",
            "StyleConfigIndex.tick",
            "StyleConfigIndex.trail",
        ]

        curio.excludes.formUnion([
        ])

        // TopLevelSpec = OneOf<TopLevelUnitSpec>.Or<TopLevelFacetSpec>.Or<TopLevelLayerSpec>.Or<TopLevelRepeatSpec>.Or<TopLevelConcatSpec>.Or<TopLevelVConcatSpec>.Or<TopLevelHConcatSpec>

        // Spec = OneOf<FacetedUnitSpec>.Or<LayerSpec>.Or<RepeatSpec>.Or<FacetSpec>.Or<ConcatSpecGenericSpec>.Or<VConcatSpecGenericSpec>.Or<HConcatSpecGenericSpec>

        curio.identifiables = [
            "TopLevelUnitSpec": "LayerId!",
            "TopLevelVConcatSpec": "LayerId!",
            "TopLevelConcatSpec": "LayerId!",
            "TopLevelFacetSpec": "LayerId!",
            "TopLevelHConcatSpec": "LayerId!",
            "TopLevelLayerSpec": "LayerId!",
            "TopLevelRepeatSpec": "LayerId!",

            "FacetedUnitSpec": "LayerId!",
            "LayerSpec": "LayerId!",
            "RepeatSpec": "LayerId!",
            "FacetSpec": "LayerId!",
            "ConcatSpecGenericSpec": "LayerId!",
            "VConcatSpecGenericSpec": "LayerId!",
            "HConcatSpecGenericSpec": "LayerId!",

            "LayerRepeatSpec": "LayerId!",
            "NonLayerRepeatSpec": "LayerId!",

            "AggregateTransform": "TransformId!",
            "CalculateTransform": "TransformId!",
            "DensityTransform": "TransformId!",
            "FlattenTransform": "TransformId!",
            "FoldTransform": "TransformId!",
            "LoessTransform": "TransformId!",
            "LookupTransform": "TransformId!",
            "RegressionTransform": "TransformId!",
            "TimeUnitTransform": "TransformId!",
            "WindowTransform": "TransformId!",
            "QuantileTransform": "TransformId!",
            "JoinAggregateTransform": "TransformId!",
            "BinTransform": "TransformId!",
            "StackTransform": "TransformId!",
            "FilterTransform": "TransformId!",
            "ImputeTransform": "TransformId!",
            "PivotTransform": "TransformId!",
            "SampleTransform": "TransformId!",

            "TopLevelSelectionParameter": "ParameterId!",
            "SelectionParameter": "ParameterId!",
            "VariableParameter": "ParameterId!",
        ]

        /// Promote the types of the properties to the given expected type
        curio.propertyWrap = [
            "EncodingChannelMap.latitude": "LatitudeEncoding",
            "EncodingChannelMap.latitude2": "Latitude2Encoding",
            "EncodingChannelMap.longitude": "LongitudeEncoding",
            "EncodingChannelMap.longitude2": "Longitude2Encoding",
            "EncodingChannelMap.key": "KeyEncoding",
            "EncodingChannelMap.angle": "AngleEncoding",
            "EncodingChannelMap.color": "ColorEncoding",
            "EncodingChannelMap.column": "ColumnEncoding",
            "EncodingChannelMap.detail": "DetailEncoding",
            "EncodingChannelMap.facet": "FacetEncoding",
            "EncodingChannelMap.fill": "FillEncoding",
            "EncodingChannelMap.fillOpacity": "FillOpacityEncoding",
            "EncodingChannelMap.href": "HrefEncoding",
            "EncodingChannelMap.opacity": "OpacityEncoding",
            "EncodingChannelMap.order": "OrderEncoding",
            "EncodingChannelMap.radius": "RadiusEncoding",
            "EncodingChannelMap.radius2": "Radius2Encoding",
            "EncodingChannelMap.row": "RowEncoding",
            "EncodingChannelMap.shape": "ShapeEncoding",
            "EncodingChannelMap.size": "SizeEncoding",
            "EncodingChannelMap.stroke": "StrokeEncoding",
            "EncodingChannelMap.strokeDash": "StrokeDashEncoding",
            "EncodingChannelMap.strokeOpacity": "StrokeOpacityEncoding",
            "EncodingChannelMap.strokeWidth": "StrokeWidthEncoding",
            "EncodingChannelMap.text": "TextEncoding",
            "EncodingChannelMap.theta": "ThetaEncoding",
            "EncodingChannelMap.theta2": "Theta2Encoding",
            "EncodingChannelMap.tooltip": "TooltipEncoding",
            "EncodingChannelMap.url": "UrlEncoding",
            "EncodingChannelMap.x": "XEncoding",
            "EncodingChannelMap.x2": "X2Encoding",
            "EncodingChannelMap.xError": "XErrorEncoding",
            "EncodingChannelMap.xError2": "XError2Encoding",
            "EncodingChannelMap.y": "YEncoding",
            "EncodingChannelMap.y2": "Y2Encoding",
            "EncodingChannelMap.yError": "YErrorEncoding",
            "EncodingChannelMap.yError2": "YError2Encoding",
            "EncodingChannelMap.description": "DescriptionEncoding",

            "Encoding.latitude": "LatitudeEncoding",
            "Encoding.latitude2": "Latitude2Encoding",
            "Encoding.longitude": "LongitudeEncoding",
            "Encoding.longitude2": "Longitude2Encoding",
            "Encoding.key": "KeyEncoding",
            "Encoding.angle": "AngleEncoding",
            "Encoding.color": "ColorEncoding",
            "Encoding.column": "ColumnEncoding",
            "Encoding.detail": "DetailEncoding",
            "Encoding.facet": "FacetEncoding",
            "Encoding.fill": "FillEncoding",
            "Encoding.fillOpacity": "FillOpacityEncoding",
            "Encoding.href": "HrefEncoding",
            "Encoding.opacity": "OpacityEncoding",
            "Encoding.order": "OrderEncoding",
            "Encoding.radius": "RadiusEncoding",
            "Encoding.radius2": "Radius2Encoding",
            "Encoding.row": "RowEncoding",
            "Encoding.shape": "ShapeEncoding",
            "Encoding.size": "SizeEncoding",
            "Encoding.stroke": "StrokeEncoding",
            "Encoding.strokeDash": "StrokeDashEncoding",
            "Encoding.strokeOpacity": "StrokeOpacityEncoding",
            "Encoding.strokeWidth": "StrokeWidthEncoding",
            "Encoding.text": "TextEncoding",
            "Encoding.theta": "ThetaEncoding",
            "Encoding.theta2": "Theta2Encoding",
            "Encoding.tooltip": "TooltipEncoding",
            "Encoding.url": "UrlEncoding",
            "Encoding.x": "XEncoding",
            "Encoding.x2": "X2Encoding",
            "Encoding.xError": "XErrorEncoding",
            "Encoding.xError2": "XError2Encoding",
            "Encoding.y": "YEncoding",
            "Encoding.y2": "Y2Encoding",
            "Encoding.yError": "YErrorEncoding",
            "Encoding.yError2": "YError2Encoding",
            "Encoding.description": "DescriptionEncoding",
        ]

        curio.propertyTypeOverrides = [
            "ConfigTheme.font": "FontName",
            "AreaConfig.font": "FontName",
            "BarConfig.font": "FontName",
            "LineConfig.font": "FontName",
            "RectConfig.font": "FontName",
            "MarkConfig.font": "FontName",
            "MarkConfigAny.font": "FontName",
            "MarkDef.font": "FontName",
            "OverlayMarkDef.font": "FontName",
            "TextConfig.font": "FontName",
            "TitleParams.font": "FontName",
            "TitleParams.subtitleFont": "FontName",
            "BaseMarkConfig.font": "FontName",
            "ExcludeMappedValueRefBaseTitle.font": "FontName",
            "ExcludeMappedValueRefBaseTitle.subtitleFont": "FontName",
            "AxisDef.labelFont": "FontName",
            "AxisDef.titleFont": "FontName",
            "AxisConfig.labelFont": "FontName",
            "AxisConfig.titleFont": "FontName",
            "HeaderDef.labelFont": "FontName",
            "HeaderDef.titleFont": "FontName",
            "HeaderConfig.labelFont": "FontName",
            "HeaderConfig.titleFont": "FontName",
            "LegendDef.labelFont": "FontName",
            "LegendDef.titleFont": "FontName",
            "LegendConfig.labelFont": "FontName",
            "LegendConfig.titleFont": "FontName",
            "TickConfig.font": "FontName",
            "BaseTitleNoValueRefs.font": "FontName",
            "BaseTitleNoValueRefs.subtitleFont": "FontName",
            "MarkConfigExprOrSignalRef.font": "OneOf2<FontName, ExprRef>",

            "MarkDef.shape": "SymbolShape",
            "OverlayMarkDef.shape": "SymbolShape",
            "AreaConfig.shape": "SymbolShape",
            "BaseMarkConfig.shape": "SymbolShape",
            "LineConfig.shape": "SymbolShape",
            "MarkConfig.shape": "SymbolShape",
            "MarkDefConfig.shape": "SymbolShape",
            "OverlayMarkDefConfig.shape": "SymbolShape",
            "RectConfig.shape": "SymbolShape",
            "TextConfig.shape": "SymbolShape",
            "TickConfig.shape": "SymbolShape",
            "ValueDefWithConditionMarkPropFieldOrDatumDefTypeForShapeStringNull.value": "Nullable<SymbolShape>",

            "ArgmaxDef.argmax": "FieldName",
            "ArgminDef.argmin": "FieldName",

            "ExprRef.expr": "Expr", // was "string"
            "CalculateTransform.calculate": "Expr",
            "HeaderDef.labelExpr": "Expr",
            "HeaderConfig.labelExpr": "Expr",
            "AxisDef.labelExpr": "Expr",
            "AxisConfig.labelExpr": "Expr",
            "LegendDef.labelExpr": "Expr",
            "LegendConfig.labelExpr": "Expr", // doesn't exist, but maybe eventually…

            "ConditionExprType.expr": "Expr",
            "ExprTestType.expr": "Expr",

            "LayerRepeatMapping.column": "[FieldName]",
            "LayerRepeatMapping.row": "[FieldName]",
            "LayerRepeatMapping.layer": "[FieldName]",

            "RepeatMapping.column": "[FieldName]",
            "RepeatMapping.row": "[FieldName]",

            // https://github.com/vega/vega-lite/pull/5382

            "DensityTransform.density": "FieldName",
            "DensityTransform.as": "[FieldName]",
            "DensityTransform.groupby": "[FieldName]",

            "LoessTransform.loess": "FieldName",
            "LoessTransform.on": "FieldName",
            "LoessTransform.as": "[FieldName]",
            "LoessTransform.groupby": "[FieldName]",

            "LookupTransform.lookup": "FieldName",
            "LookupTransform.default": "Bric", // https://github.com/vega/vega-lite/issues/7073

            "PivotTransform.pivot": "FieldName",
            "PivotTransform.value": "FieldName",
            "PivotTransform.groupby": "[FieldName]",

            "RegressionTransform.on": "FieldName",
            "RegressionTransform.regression": "FieldName",
            "RegressionTransform.as": "[FieldName]",
            "RegressionTransform.groupby": "[FieldName]",

            "NonLayerRepeatSpec.repeat": "OneOf<[FieldName]>.Or<RepeatMapping>", // was: OneOf<[String]>.Or<RepeatMapping>
        ]

        // public typealias PrimitiveValue = Nullable<OneOf3<Decimal, String, Bool>>

        // Some types should be encapsulated so we can re-use them (and extend them to conform to protocols)
        curio.encapsulate = [
            "LayerId": CodeExternalType("UUID"),
            "TransformId": CodeExternalType("UUID"),
            "ParameterId": CodeExternalType("UUID"),

            "PrimitiveValue": CodeExternalType("OneOf4<ExplicitNull, Double, String, Bool>"), // was: Nullable<OneOf3<Double, String, Bool>>
            // "PrimitiveValue": CodeExternalType("OneOf4<ExplicitNull, Decimal, String, Bool>"), // TODO: we can benefit from making this a Decimal if https://bugs.swift.org/browse/SR-7054 is ever fixed

            // "ColorExpr": CodeExternalType("OneOf2<ColorCode, ExprRef>"),

            "FontName": CodeExternalType("String"), // FontName is not defined, so we define it ourselves; it is a string

            "FontStyle": CodeExternalType("FontStyle"), // wrap the string in its own type
            "FontWeight": CodeExternalType("FontWeight"),

            "ColorLiteral": CodeExternalType("ColorLiteral"), // ColorCode = OneOf3<ColorName, HexColor, String>
            "ColorGradient": CodeExternalType("ColorGradient"), // ColorGradient = OneOf2<LinearGradient, RadialGradient>
            "HexColor": CodeExternalType("HexColor"), // HexColor = String

            "DataProvider": CodeExternalType("DataProvider"), // DataProvider = OneOf2<DataSource, Generator>
            "DataSource": CodeExternalType("DataSource"), // DataSource = OneOf3<UrlData, InlineData, NamedData>
            "SourceColumnRef": CodeExternalType("SourceColumnRef"), // SourceColumnRef = OneOf2<FieldName, RepeatRef>
            "Sort": CodeExternalType("Sort"), // Sort = Nullable<OneOf4<SortArray, AllSortString, EncodingSortField, SortByEncoding>>

            "FieldName": CodeExternalType("FieldName"), // FieldName = string
            "ParameterName": CodeExternalType("ParameterName"), // ParameterName = string

            "Expr": CodeExternalType("Expr"), // Expr = string

            "Element": CodeExternalType("String"), // Element = string

            "Day": CodeExternalType("UInt8"), // Day = number
            "Month": CodeExternalType("UInt8"), // Month = number
            "SymbolShape": CodeExternalType("String"), // SymbolShape = string
            "SymbolItem": CodeExternalType("SymbolShape"), // SymbolItem = string – this could be made into some SVGShape instance

            "Aggregate": CodeExternalType("Aggregate"), // Aggregate = OneOf3<NonArgAggregateOp, ArgmaxDef, ArgminDef>
            "AllSortString": CodeExternalType("AllSortString"), // AllSortString = OneOf3<SortOrder, SortByChannel, SortByChannelDesc>
            "AnyMark": CodeExternalType("AnyMark"), // AnyMark = OneOf4<CompositeMark, CompositeMarkDef, Mark, MarkDef>
            "BindControl": CodeExternalType("BindControl"), // BindControl = OneOf4<BindCheckbox, BindRadioSelect, BindRange, InputBinding>
            "ColorScheme": CodeExternalType("ColorScheme"), // ColorScheme = OneOf5<Categorical, SequentialSingleHue, SequentialMultiHue, Diverging, Cyclical>
            "CompositeMark": CodeExternalType("CompositeMark"), // CompositeMark = OneOf3<BoxPlot, ErrorBar, ErrorBand>
            "CompositeMarkDef": CodeExternalType("CompositeMarkDef"), // CompositeMarkDef = OneOf3<BoxPlotDef, ErrorBarDef, ErrorBandDef>
            "DataFormat": CodeExternalType("DataFormat"), // DataFormat = OneOf4<CsvDataFormat, DsvDataFormat, JsonDataFormat, TopoDataFormat>
            "Generator": CodeExternalType("Generator"), // Generator = OneOf3<SequenceGenerator, SphereGenerator, GraticuleGenerator>
            "InlineDataset": CodeExternalType("InlineDataset"), // InlineDataset = OneOf6<[Double], [String], [Bool], [Bric], String, Bric>
            "LabelOverlap": CodeExternalType("LabelOverlap"), // LabelOverlap = OneOf3<Bool, LiteralParity, LiteralGreedy>
            "Predicate": CodeExternalType("Predicate"), // Predicate = OneOf10<FieldEqualPredicate, FieldRangePredicate, FieldOneOfPredicate, FieldLTPredicate, FieldGTPredicate, FieldLTEPredicate, FieldGTEPredicate, FieldValidPredicate, SelectionPredicate, String>
            //"SelectionDef": CodeExternalType("SelectionDef"), // SelectionDef = OneOf3<SingleSelection, MultiSelection, IntervalSelection>
            //"SelectionComposition": CodeExternalType("SelectionComposition"), // SelectionComposition = OneOf4<SelectionNot, SelectionAnd, SelectionOr, String>
            "SortArray": CodeExternalType("SortArray"), // SortArray = OneOf4<[Double], [String], [Bool], [DateTime]>
            "Stream": CodeExternalType("Stream"), // Stream = OneOf3<EventStream, DerivedStream, MergedStream>

    //        "XXX": CodeExternalType("XXX"), // XXX
        ]


    }
}
#endif

