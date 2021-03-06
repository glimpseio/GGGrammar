import class Foundation.Bundle
import struct Foundation.URL
import struct Foundation.Data

/// Sample resources provided by this bundle
public enum GGSample : String, CaseIterable {
    case airport_connections
    case arc_donut
    case arc_ordinal_theta
    case arc_params
    case arc_pie
    case arc_pie_pyramid
    case arc_radial
    case arc_radial_histogram
    case area
    case area_cumulative_freq
    case area_density
    case area_density_facet
    case area_density_stacked
    case area_density_stacked_fold
    case area_gradient
    case area_horizon
    case area_overlay
    case area_params
    case area_temperature_range
    case area_vertical
    case argmin_spaces
    case bar
    case bar_1d
    case bar_1d_step_config
    case bar_aggregate
    case bar_aggregate_count
    case bar_aggregate_format
    case bar_aggregate_size
    case bar_aggregate_sort_by_encoding
    case bar_aggregate_sort_mean
    case bar_aggregate_transform
    case bar_aggregate_vertical
    case bar_argmax
    case bar_argmax_transform
    case bar_array_aggregate
    case bar_axis_orient
    case bar_axis_space_saving
    case bar_binned_data
    case bar_bullet_expr_bind
    case bar_color_disabled_scale
    case bar_column_fold
    case bar_column_pivot
    case bar_corner_radius_end
    case bar_count_minimap
    case bar_custom_sort_full
    case bar_custom_sort_partial
    case bar_custom_time_domain
    case bar_default_tooltip_title_null
    case bar_distinct
    case bar_diverging_stack_population_pyramid
    case bar_diverging_stack_transform
    case bar_filter_calc
    case bar_fit
    case bar_gantt
    case bar_grouped
    case bar_grouped_horizontal
    case bar_layered_transparent
    case bar_layered_weather
    case bar_month
    case bar_month_band
    case bar_month_band_config
    case bar_month_temporal
    case bar_month_temporal_initial
    case bar_multi_values_per_categories
    case bar_negative
    case bar_negative_horizontal_label
    case bar_params
    case bar_params_bound
    case bar_size_default
    case bar_size_explicit_bad
    case bar_size_fit
    case bar_size_responsive
    case bar_size_step_small
    case bar_sort_by_count
    case bar_swap_axes
    case bar_swap_custom
    case bar_title
    case bar_title_start
    case bar_tooltip
    case bar_tooltip_aggregate
    case bar_tooltip_groupby
    case bar_tooltip_multi
    case bar_tooltip_title
    case bar_yearmonth
    case bar_yearmonth_custom_format
    case boxplot_1D_horizontal
    case boxplot_1D_horizontal_custom_mark
    case boxplot_1D_horizontal_explicit
    case boxplot_1D_vertical
    case boxplot_2D_horizontal
    case boxplot_2D_horizontal_color_size
    case boxplot_2D_vertical
    case boxplot_minmax_2D_horizontal
    case boxplot_minmax_2D_horizontal_custom_midtick_color
    case boxplot_minmax_2D_vertical
    case boxplot_preaggregated
    case boxplot_tooltip_aggregate
    case boxplot_tooltip_not_aggregate
    case brush_table
    case circle
    case circle_binned
    case circle_binned_maxbins_2
    case circle_binned_maxbins_20
    case circle_binned_maxbins_5
    case circle_bubble_health_income
    case circle_custom_tick_labels
    case circle_flatten
    case circle_github_punchcard
    case circle_labelangle_orient_signal
    case circle_natural_disasters
    case circle_opacity
    case circle_scale_quantile
    case circle_scale_quantize
    case circle_scale_threshold
    case circle_wilkinson_dotplot
    case circle_wilkinson_dotplot_stacked
    case concat_bar_layer_circle
    case concat_bar_scales_discretize
    case concat_bar_scales_discretize_2_cols
    case concat_hover
    case concat_hover_filter
    case concat_layer_voyager_result
    case concat_marginal_histograms
    case concat_population_pyramid
    case concat_weather
    case connected_scatterplot
    case embedded_csv
    case errorband_2d_horizontal_color_encoding
    case errorband_2d_vertical_borders
    case errorband_tooltip
    case errorbar_2d_vertical_ticks
    case errorbar_aggregate
    case errorbar_horizontal_aggregate
    case errorbar_tooltip
    case facet_bullet
    case facet_column_facet_column_point_future
    case facet_column_facet_row_point_future
    case facet_cross_independent_scale
    case facet_custom
    case facet_custom_header
    case facet_grid_bar
    case facet_independent_scale
    case facet_independent_scale_layer_broken
    case facet_row_facet_row_point_future
    case geo_choropleth
    case geo_circle
    case geo_constant_value
    case geo_custom_projection
    case geo_graticule
    case geo_graticule_object
    case geo_layer
    case geo_layer_line_london
    case geo_line
    case geo_params_projections
    case geo_point
    case geo_repeat
    case geo_rule
    case geo_sphere
    case geo_text
    case geo_trellis
    case hconcat_weather
    case histogram
    case histogram_bin_change
    case histogram_bin_spacing
    case histogram_bin_spacing_reverse
    case histogram_bin_transform
    case histogram_log
    case histogram_no_spacing
    case histogram_ordinal
    case histogram_ordinal_sort
    case histogram_rel_freq
    case histogram_reverse
    case interactive_area_brush
    case interactive_bar_select_highlight
    case interactive_bin_extent
    case interactive_bin_extent_bottom
    case interactive_brush
    case interactive_concat_layer
    case interactive_dashboard_europe_pop
    case interactive_global_development
    case interactive_index_chart
    case interactive_layered_crossfilter
    case interactive_layered_crossfilter_discrete
    case interactive_legend
    case interactive_legend_dblclick
    case interactive_line_brush_cursor
    case interactive_line_hover
    case interactive_multi_line_label
    case interactive_multi_line_pivot_tooltip
    case interactive_multi_line_tooltip
    case interactive_overview_detail
    case interactive_paintbrush
    case interactive_paintbrush_color
    case interactive_paintbrush_color_nearest
    case interactive_paintbrush_interval
    case interactive_paintbrush_simple_false
    case interactive_paintbrush_simple_true
    case interactive_panzoom_splom
    case interactive_panzoom_vconcat_shared
    case interactive_point_init
    case interactive_query_widgets
    case interactive_seattle_weather
    case interactive_splom
    case interactive_stocks_nearest_index
    case isotype_bar_chart
    case isotype_bar_chart_emoji
    case isotype_grid
    case joinaggregate_mean_difference
    case joinaggregate_mean_difference_by_year
    case joinaggregate_percent_of_total
    case joinaggregate_residual_graph
    case layer_arc_label
    case layer_bar_annotations
    case layer_bar_fruit
    case layer_bar_labels
    case layer_bar_labels_grey
    case layer_bar_labels_style
    case layer_bar_line
    case layer_bar_line_union
    case layer_bar_month
    case layer_boxplot_circle
    case layer_candlestick
    case layer_circle_independent_color
    case layer_color_legend_left
    case layer_cumulative_histogram
    case layer_dual_axis
    case layer_falkensee
    case layer_histogram
    case layer_histogram_global_mean
    case layer_likert
    case layer_line_co2_concentration
    case layer_line_color_rule
    case layer_line_datum_rule
    case layer_line_datum_rule_datetime
    case layer_line_errorband_2d_horizontal_borders_strokedash
    case layer_line_errorband_ci
    case layer_line_errorband_pre_aggregated
    case layer_line_mean_point_raw
    case layer_line_rolling_mean_point_raw
    case layer_line_window
    case layer_overlay
    case layer_point_errorbar_1d_horizontal
    case layer_point_errorbar_1d_vertical
    case layer_point_errorbar_2d_horizontal
    case layer_point_errorbar_2d_horizontal_ci
    case layer_point_errorbar_2d_horizontal_color_encoding
    case layer_point_errorbar_2d_horizontal_custom_ticks
    case layer_point_errorbar_2d_horizontal_iqr
    case layer_point_errorbar_2d_horizontal_stdev
    case layer_point_errorbar_2d_vertical
    case layer_point_errorbar_ci
    case layer_point_errorbar_pre_aggregated_asymmetric_error
    case layer_point_errorbar_pre_aggregated_symmetric_error
    case layer_point_errorbar_pre_aggregated_upper_lower
    case layer_point_errorbar_stdev
    case layer_point_line_loess
    case layer_point_line_regression
    case layer_precipitation_mean
    case layer_ranged_dot
    case layer_rect_extent
    case layer_scatter_errorband_1D_stdev_global_mean
    case layer_scatter_errorband_1d_stdev
    case layer_single_color
    case layer_text_heatmap
    case layer_text_heatmap_joinaggregate
    case layer_timeunit_rect
    case line
    case line_bump
    case line_calculate
    case line_color
    case line_color_binned
    case line_color_halo
    case line_color_label
    case line_concat_facet
    case line_conditional_axis
    case line_conditional_axis_config
    case line_dashed_part
    case line_detail
    case line_domainminmax
    case line_encoding_impute_keyvals
    case line_encoding_impute_keyvals_sequence
    case line_impute_frame
    case line_impute_keyvals
    case line_impute_method
    case line_impute_transform_frame
    case line_impute_transform_value
    case line_impute_value
    case line_inside_domain_using_clip
    case line_inside_domain_using_transform
    case line_max_year
    case line_mean_month
    case line_mean_year
    case line_monotone
    case line_month
    case line_month_center_band
    case line_outside_domain
    case line_overlay
    case line_overlay_stroked
    case line_params
    case line_quarter_legend
    case line_shape_overlay
    case line_skip_invalid
    case line_skip_invalid_mid
    case line_skip_invalid_mid_cap_square
    case line_skip_invalid_mid_overlay
    case line_slope
    case line_sort_axis
    case line_step
    case line_strokedash
    case line_timestamp_domain
    case line_timeunit_transform
    case lookup
    case nested_concat_align
    case parallel_coordinate
    case param_expr
    case point_1d
    case point_1d_array
    case point_2d
    case point_2d_aggregate
    case point_2d_array
    case point_2d_array_named
    case point_2d_tooltip
    case point_2d_tooltip_data
    case point_aggregate_detail
    case point_angle_windvector
    case point_background
    case point_binned_color
    case point_binned_opacity
    case point_binned_size
    case point_bubble
    case point_color
    case point_color_custom
    case point_color_ordinal
    case point_color_quantitative
    case point_color_shape_constant
    case point_color_with_shape
    case point_colorramp_size
    case point_diverging_color
    case point_dot_timeunit_color
    case point_filled
    case point_href
    case point_invalid_color
    case point_log
    case point_no_axis_domain_grid
    case point_ordinal_color
    case point_overlap
    // case point_params // failed: caught error: "OneOfDecodingError(errors: [BricBrac.OneOfDecodingError(errors: [Swift.DecodingError.typeMismatch(Swift.String, Swift.DecodingError.Context(codingPath: [CodingKeys(stringValue: "mark", intValue: nil)], debugDescription: "Expected to decode String but found a dictionary instead.", underlyingError: nil)), Swift.DecodingError.typeMismatch(Swift.String, Swift.DecodingError.Context(codingPath: [CodingKeys(stringValue: "mark", intValue: nil)], debugDescription: "Expected to decode String but found a dictionary instead.", underlyingError: nil)), Swift.DecodingError.typeMismatch(Swift.String, Swift.DecodingError.Context(codingPath: [CodingKeys(stringValue: "mark", intValue: nil)], debugDescription: "Expected to decode String but found a dictionary instead.", underlyingError: nil))]), BricBrac.OneOfDecodingError(errors: [Swift.DecodingError.dataCorrupted(Swift.DecodingError.Context(codingPath: [CodingKeys(stringValue: "mark", intValue: nil)], debugDescription: "Additional properties forbidden: [\"angle\", \"shape\", \"strokeWidth\"]", underlyingError: nil)), Swift.DecodingError.dataCorrupted(Swift.DecodingError.Context(codingPath: [CodingKeys(stringValue: "mark", intValue: nil)], debugDescription: "Additional properties forbidden: [\"angle\", \"shape\", \"strokeWidth\"]", underlyingError: nil)), Swift.DecodingError.dataCorrupted(Swift.DecodingError.Context(codingPath: [CodingKeys(stringValue: "mark", intValue: nil)], debugDescription: "Additional properties forbidden: [\"angle\", \"size\", \"strokeWidth\", \"shape\"]", underlyingError: nil))]), Swift.DecodingError.typeMismatch(Swift.String, Swift.DecodingError.Context(codingPath: [CodingKeys(stringValue: "mark", intValue: nil)], debugDescription: "Expected to decode String but found a dictionary instead.", underlyingError: nil)), Swift.DecodingError.typeMismatch(Swift.String, Swift.DecodingError.Context(codingPath: [CodingKeys(stringValue: "mark", intValue: nil), CodingKeys(stringValue: "shape", intValue: nil)], debugDescription: "Expected to decode String but found a dictionary instead.", underlyingError: nil))])"

    case point_quantile_quantile
    case point_scale_range_field
    case point_shape_custom
    case point_tooltip
    case rect_binned_heatmap
    case rect_heatmap
    case rect_heatmap_weather
    case rect_lasagna
    case rect_mosaic_labelled
    case rect_mosaic_labelled_with_offset
    case rect_mosaic_simple
    case rect_params
    case repeat_child_layer
    case repeat_histogram
    case repeat_histogram_autosize
    case repeat_histogram_flights
    case repeat_independent_colors
    case repeat_layer
    case repeat_line_weather
    case repeat_splom
    case repeat_splom_cars
    case rule_color_mean
    case rule_extent
    case rule_params
    case sample_scatterplot
    case scatter_image
    case selection_bind_cylyr
    case selection_bind_origin
    case selection_brush_timeunit
    case selection_clear_brush
    case selection_composition_and
    case selection_composition_or
    case selection_concat
    case selection_filter
    case selection_filter_composition
    case selection_filter_false
    case selection_filter_true
    case selection_heatmap
    case selection_insert
    case selection_interval_mark_style
    //case selection_layer // .json, not .vl.json
    case selection_layer_bar_month
    case selection_multi_condition
    case selection_project_binned_interval
    case selection_project_interval
    case selection_project_interval_x
    case selection_project_interval_x_y
    case selection_project_interval_y
    case selection_project_multi
    case selection_project_multi_cylinders
    case selection_project_multi_cylinders_origin
    case selection_project_multi_origin
    case selection_project_single
    case selection_project_single_cylinders
    case selection_project_single_cylinders_origin
    case selection_project_single_origin
    case selection_resolution_global
    case selection_resolution_intersect
    case selection_resolution_union
    case selection_toggle_altKey
    case selection_toggle_altKey_shiftKey
    case selection_toggle_shiftKey
    case selection_translate_brush_drag
    case selection_translate_brush_shift_drag = "selection_translate_brush_shift-drag"
    case selection_translate_scatterplot_drag
    case selection_translate_scatterplot_shift_drag = "selection_translate_scatterplot_shift-drag"
    case selection_type_interval
    case selection_type_interval_invert
    case selection_type_point
    case selection_type_single_dblclick
    case selection_type_single_mouseover
    case selection_zoom_brush_shift_wheel = "selection_zoom_brush_shift-wheel"
    case selection_zoom_brush_wheel
    case selection_zoom_scatterplot_shift_wheel = "selection_zoom_scatterplot_shift-wheel"
    case selection_zoom_scatterplot_wheel
    case sequence_line
    case sequence_line_fold
    case square
    case stacked_area
    case stacked_area_normalize
    case stacked_area_ordinal
    case stacked_area_overlay
    case stacked_area_stream
    case stacked_bar_1d
    case stacked_bar_count
    case stacked_bar_count_corner_radius_config
    case stacked_bar_count_corner_radius_mark
    case stacked_bar_count_corner_radius_mark_x
    case stacked_bar_count_corner_radius_stroke
    case stacked_bar_h
    case stacked_bar_h_order
    case stacked_bar_h_order_custom
    case stacked_bar_normalize
    case stacked_bar_population
    case stacked_bar_population_transform
    case stacked_bar_size
    case stacked_bar_sum_opacity
    case stacked_bar_unaggregate
    case stacked_bar_v
    case stacked_bar_weather
    case test_aggregate_nested
    case test_field_with_spaces
    //case test_minimal // .json, not .vl.json
    case test_single_point_color
    case test_subobject
    case test_subobject_missing
    case test_subobject_nested
    case text_format
    // case text_params // failed - error parsing sample: text_params: OneOfDecodingError(errors: [BricBrac.OneOfDecodingError(errors: [Swift.DecodingError.typeMismatch(Swift.String, Swift.DecodingError.Context(codingPath: [CodingKeys(stringValue: "layer", intValue: nil), _JSONKey(stringValue: "Index 1", intValue: 1), CodingKeys(stringValue: "mark", intValue: nil)], debugDescription: "Expected to decode String but found a dictionary instead.", underlyingError: nil)), Swift.DecodingError.typeMismatch(Swift.String, Swift.DecodingError.Context(codingPath: [CodingKeys(stringValue: "layer", intValue: nil), _JSONKey(stringValue: "Index 1", intValue: 1), CodingKeys(stringValue: "mark", intValue: nil)], debugDescription: "Expected to decode String but found a dictionary instead.", underlyingError: nil)), Swift.DecodingError.typeMismatch(Swift.String, Swift.DecodingError.Context(codingPath: [CodingKeys(stringValue: "layer", intValue: nil), _JSONKey(stringValue: "Index 1", intValue: 1), CodingKeys(stringValue: "mark", intValue: nil)], debugDescription: "Expected to decode String but found a dictionary instead.", underlyingError: nil))]), BricBrac.OneOfDecodingError(errors: [Swift.DecodingError.dataCorrupted(Swift.DecodingError.Context(codingPath: [CodingKeys(stringValue: "layer", intValue: nil), _JSONKey(stringValue: "Index 1", intValue: 1), CodingKeys(stringValue: "mark", intValue: nil)], debugDescription: "Additional properties forbidden: [\"fontStyle\", \"fontSize\", \"xOffset\", \"baseline\", \"dx\", \"limit\", \"fontWeight\", \"align\", \"dy\", \"angle\", \"font\", \"yOffset\"]", underlyingError: nil)), Swift.DecodingError.dataCorrupted(Swift.DecodingError.Context(codingPath: [CodingKeys(stringValue: "layer", intValue: nil), _JSONKey(stringValue: "Index 1", intValue: 1), CodingKeys(stringValue: "mark", intValue: nil)], debugDescription: "Additional properties forbidden: [\"fontStyle\", \"fontSize\", \"xOffset\", \"baseline\", \"dx\", \"limit\", \"fontWeight\", \"align\", \"dy\", \"angle\", \"font\", \"yOffset\"]", underlyingError: nil)), Swift.DecodingError.dataCorrupted(Swift.DecodingError.Context(codingPath: [CodingKeys(stringValue: "layer", intValue: nil), _JSONKey(stringValue: "Index 1", intValue: 1), CodingKeys(stringValue: "mark", intValue: nil)], debugDescription: "Additional properties forbidden: [\"fontStyle\", \"fontSize\", \"xOffset\", \"baseline\", \"dx\", \"limit\", \"fontWeight\", \"align\", \"dy\", \"angle\", \"font\", \"yOffset\"]", underlyingError: nil))]), Swift.DecodingError.typeMismatch(Swift.String, Swift.DecodingError.Context(codingPath: [CodingKeys(stringValue: "layer", intValue: nil), _JSONKey(stringValue: "Index 1", intValue: 1), CodingKeys(stringValue: "mark", intValue: nil)], debugDescription: "Expected to decode String but found a dictionary instead.", underlyingError: nil)), Swift.DecodingError.typeMismatch(Swift.String, Swift.DecodingError.Context(codingPath: [CodingKeys(stringValue: "layer", intValue: nil), _JSONKey(stringValue: "Index 1", intValue: 1), CodingKeys(stringValue: "mark", intValue: nil), CodingKeys(stringValue: "font", intValue: nil)], debugDescription: "Expected to decode String but found a dictionary instead.", underlyingError: nil))])

    case text_scatterplot_colored
    case tick_dot
    case tick_dot_thickness
    case tick_sort
    case tick_strip
    case tick_strip_tick_band
    case time_custom_step
    case time_output_utc_scale
    case time_output_utc_timeunit
    case time_parse_local
    case time_parse_utc
    case time_parse_utc_format
    case trail_color
    case trail_comet
    case trellis_anscombe
    case trellis_area
    case trellis_area_seattle
    case trellis_area_sort_array
    case trellis_bar
    case trellis_bar_histogram
    case trellis_bar_histogram_label_rotated
    case trellis_bar_no_header
    case trellis_barley
    case trellis_barley_independent
    case trellis_barley_layer_median
    case trellis_column_year
    case trellis_cross_sort
    case trellis_cross_sort_array
    case trellis_line_quarter
    case trellis_row_column
    case trellis_scatter
    case trellis_scatter_binned_row
    case trellis_scatter_small
    case trellis_selections
    case trellis_stacked_bar
    case vconcat_flatten
    case vconcat_weather
    case waterfall_chart
    case wheat_wages
    case window_cumulative_running_average
    case window_percent_of_total
    case window_rank
    case window_top_k
    case window_top_k_others

    /// Accesses the sample URL for the given sample name
    public var resourceURL: URL? {
        Bundle.module.url(forResource: rawValue, withExtension: ".vl.json")
    }

    /// Path to the catalog of all the available samples
    public var sampleCatalogURL: URL? {
        Bundle.module.url(forResource: "examples", withExtension: "json")
    }
}
