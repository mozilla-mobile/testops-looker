- dashboard: mobile_test_ops_dashboard
  title: Mobile Test Ops Dashboard
  layout: newspaper
  preferred_viewer: dashboards-next
  elements:
  - name: Fenix dashboard
    type: text
    title_text: Fenix dashboard
    subtitle_text: Test Rail data
    body_text: ''
    row: 0
    col: 2
    width: 19
    height: 3
  - title: demo Report Test Coverage data
    name: demo Report Test Coverage data
    model: mobile_testops
    explore: report_test_coverage
    type: looker_grid
    fields: [report_test_coverage.test_count, report_test_coverage.test_automation_status_id,
      report_test_coverage.test_automation_coverage_id]
    sorts: [report_test_coverage.test_count]
    limit: 500
    show_view_names: false
    show_row_numbers: true
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: white
    limit_displayed_rows: false
    enable_conditional_formatting: false
    header_text_alignment: left
    header_font_size: 12
    rows_font_size: 12
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    defaults_version: 1
    series_types: {}
    value_labels: legend
    label_type: labPer
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: ''
    legend_position: center
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    row: 16
    col: 3
    width: 15
    height: 6
  - title: Completed tests - None, Partial, Full
    name: Completed tests - None, Partial, Full
    model: mobile_testops
    explore: report_test_coverage_show_status
    type: looker_column
    fields: [report_test_coverage_show_status.test_count_sum, report_test_coverage_show_status.coverage]
    sorts: [report_test_coverage_show_status.test_count_sum]
    limit: 500
    filter_expression: ${report_test_coverage_show_status.status} = "Completed"
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: ''
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    series_types: {}
    series_colors:
      report_test_coverage_show_status.test_count_sum: "#0060E0"
    show_null_points: true
    defaults_version: 1
    value_labels: legend
    label_type: labPer
    show_row_numbers: true
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: white
    enable_conditional_formatting: false
    header_text_alignment: left
    header_font_size: 12
    rows_font_size: 12
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    listen: {}
    row: 8
    col: 0
    width: 8
    height: 4
  - title: Test Automation Status
    name: Test Automation Status
    model: mobile_testops
    explore: report_test_coverage_show_status
    type: looker_pie
    fields: [new_measure, report_test_coverage_show_status.status]
    sorts: [new_measure desc]
    limit: 500
    dynamic_fields: [{category: measure, expression: !!null '', label: New Measure,
        value_format: !!null '', value_format_name: !!null '', based_on: report_test_coverage_show_status.test_count_sum,
        _kind_hint: measure, measure: new_measure, type: sum, _type_hint: number,
        filters: {}}]
    value_labels: legend
    label_type: labPer
    series_colors:
      Unsuitable: "#FF7139"
    series_types: {}
    show_view_names: false
    show_row_numbers: true
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: white
    limit_displayed_rows: false
    enable_conditional_formatting: false
    header_text_alignment: left
    header_font_size: 12
    rows_font_size: 12
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    defaults_version: 1
    listen: {}
    row: 3
    col: 5
    width: 12
    height: 5
  - title: Disabled tests - None, Partial, Full Automation
    name: Disabled tests - None, Partial, Full Automation
    model: mobile_testops
    explore: report_test_coverage_show_status
    type: looker_column
    fields: [new_measure, report_test_coverage_show_status.coverage]
    sorts: [new_measure desc]
    limit: 500
    dynamic_fields: [{category: measure, expression: !!null '', label: New Measure,
        value_format: !!null '', value_format_name: !!null '', based_on: report_test_coverage_show_status.test_count_sum,
        _kind_hint: measure, measure: new_measure, type: sum, _type_hint: number,
        filters: {}}]
    filter_expression: ${report_test_coverage_show_status.status} = "Disabled"
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: ''
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    series_types: {}
    series_colors:
      new_measure: "#FF2A8A"
    show_row_numbers: true
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: white
    enable_conditional_formatting: false
    header_text_alignment: left
    header_font_size: 12
    rows_font_size: 12
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    defaults_version: 1
    value_labels: legend
    label_type: labPer
    listen: {}
    row: 8
    col: 8
    width: 8
    height: 4
  - title: Suitabled tests - None, Partial, Full Automated
    name: Suitabled tests - None, Partial, Full Automated
    model: mobile_testops
    explore: report_test_coverage_show_status
    type: looker_column
    fields: [new_measure, report_test_coverage_show_status.coverage]
    sorts: [new_measure desc]
    limit: 500
    dynamic_fields: [{category: measure, expression: !!null '', label: New Measure,
        value_format: !!null '', value_format_name: !!null '', based_on: report_test_coverage_show_status.test_count_sum,
        _kind_hint: measure, measure: new_measure, type: sum, _type_hint: number,
        filters: {}}]
    filter_expression: ${report_test_coverage_show_status.status} = "Suitable"
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: ''
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    series_types: {}
    series_colors:
      new_measure: "#9059FF"
    show_row_numbers: true
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: white
    enable_conditional_formatting: false
    header_text_alignment: left
    header_font_size: 12
    rows_font_size: 12
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    defaults_version: 1
    value_labels: legend
    label_type: labPer
    listen: {}
    row: 8
    col: 16
    width: 8
    height: 4
  - name: Draft graphs below
    type: text
    title_text: Draft graphs below
    subtitle_text: ''
    body_text: "-------------------------------------"
    row: 14
    col: 7
    width: 7
    height: 2
  - name: Linear graph to show trending
    type: text
    title_text: Linear graph to show trending
    subtitle_text: ''
    body_text: It may be nice to show in a trend graph how automation numbers increase
      for Completed and decrease for Disabled, Untriaged tests
    row: 12
    col: 5
    width: 12
    height: 2
