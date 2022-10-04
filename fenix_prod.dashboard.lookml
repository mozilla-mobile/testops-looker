- dashboard: fenix
  title: Fenix
  layout: newspaper
  preferred_viewer: dashboards-next
  description: ''
  preferred_slug: ZoHdWYKEgGNBDWH71tACOJ
  elements:
  - title: Automation Status Trend
    name: Automation Status Trend
    model: mobile_testops
    explore: report_test_case_coverage_prod
    type: looker_line
    fields: [report_test_case_coverage_prod.created_week, completed, disabled, suitable,
      unsuitable, untriaged]
    fill_fields: [report_test_case_coverage_prod.created_week]
    sorts: [report_test_case_coverage_prod.created_week desc]
    limit: 500
    dynamic_fields: [{category: measure, expression: "${report_test_case_coverage_prod.projects_id}\
          \ = 1 AND ${report_test_case_coverage_prod.test_sub_suites_id} = 1", label: Completed,
        value_format: !!null '', value_format_name: !!null '', based_on: report_test_case_coverage_prod.test_count,
        filter_expression: "${report_test_case_coverage_prod.projects_id} = 1 AND\
          \ ${report_test_case_coverage_prod.test_sub_suites_id} = 1", _kind_hint: measure,
        measure: completed, type: sum, _type_hint: number, filters: {report_test_case_coverage_prod.test_automation_status_id: '4'}},
      {category: measure, expression: "${report_test_case_coverage_prod.projects_id}\
          \ = 1 AND ${report_test_case_coverage_prod.test_sub_suites_id} = 1", label: Disabled,
        value_format: !!null '', value_format_name: !!null '', based_on: report_test_case_coverage_prod.test_count,
        filter_expression: "${report_test_case_coverage_prod.projects_id} = 1 AND\
          \ ${report_test_case_coverage_prod.test_sub_suites_id} = 1", _kind_hint: measure,
        measure: disabled, type: sum, _type_hint: number, filters: {report_test_case_coverage_prod.test_automation_status_id: '5'}},
      {category: measure, expression: "${report_test_case_coverage_prod.projects_id}\
          \ = 1 AND ${report_test_case_coverage_prod.test_sub_suites_id} = 1", label: Suitable,
        value_format: !!null '', value_format_name: !!null '', based_on: report_test_case_coverage_prod.test_count,
        filter_expression: "${report_test_case_coverage_prod.projects_id} = 1 AND\
          \ ${report_test_case_coverage_prod.test_sub_suites_id} = 1", _kind_hint: measure,
        measure: suitable, type: sum, _type_hint: number, filters: {report_test_case_coverage_prod.test_automation_status_id: '2'}},
      {category: measure, expression: "${report_test_case_coverage_prod.projects_id}\
          \ = 1 AND ${report_test_case_coverage_prod.test_sub_suites_id} = 1", label: Unsuitable,
        value_format: !!null '', value_format_name: !!null '', based_on: report_test_case_coverage_prod.test_count,
        filter_expression: "${report_test_case_coverage_prod.projects_id} = 1 AND\
          \ ${report_test_case_coverage_prod.test_sub_suites_id} = 1", _kind_hint: measure,
        measure: unsuitable, type: sum, _type_hint: number, filters: {report_test_case_coverage_prod.test_automation_status_id: '3'}},
      {category: measure, expression: "${report_test_case_coverage_prod.projects_id}\
          \ = 1 AND ${report_test_case_coverage_prod.test_sub_suites_id} = 1", label: Untriaged,
        value_format: !!null '', value_format_name: !!null '', based_on: report_test_case_coverage_prod.test_count,
        filter_expression: "${report_test_case_coverage_prod.projects_id} = 1 AND\
          \ ${report_test_case_coverage_prod.test_sub_suites_id} = 1", _kind_hint: measure,
        measure: untriaged, type: sum, _type_hint: number, filters: {report_test_case_coverage_prod.test_automation_status_id: '1'}}]
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
    show_null_points: false
    interpolation: linear
    series_colors:
      untriaged: "#FFA537"
      completed: "#16e085"
      disabled: "#ff302d"
      suitable: "#33f6ff"
      unsuitable: "#e7e4f5"
    defaults_version: 1
    listen: {}
    row: 2
    col: 8
    width: 16
    height: 6
  - name: ''
    type: text
    title_text: ''
    subtitle_text: ''
    body_text: |-
      ## Test Automation Coverage
      ----------------------------------------------------------------------------------------------------------------------------    row: 0
    col: 0
    width: 24
    height: 2
  - title: Full Functional Test Suite
    name: Full Functional Test Suite
    model: mobile_testops
    explore: report_test_coverage_by_project_prod
    type: looker_pie
    fields: [report_test_coverage_by_project_prod.status, sum_tests_same_status]
    filters:
      report_test_coverage_by_project_prod.created_week: 2 weeks
    sorts: [report_test_coverage_by_project_prod.status]
    limit: 500
    dynamic_fields: [{category: measure, expression: !!null '', label: Sum tests same
          status, value_format: !!null '', value_format_name: !!null '', based_on: report_test_coverage_by_project_prod.test_count_sum,
        _kind_hint: measure, measure: sum_tests_same_status, type: sum, _type_hint: number}]
    filter_expression: ${report_test_coverage_by_project_prod.test_sub_suite_abbrev}
      = "functional" AND ${report_test_coverage_by_project_prod.project_name_abbrev}
      = "fenix"
    value_labels: legend
    label_type: labPer
    series_colors:
      Completed: "#16e085"
      Suitable: "#33f6ff"
      Unsuitable: "#e7e4f5"
      Untriaged: "#FFA537"
      Disabled: "#ff302d"
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
    defaults_version: 1
    series_types: {}
    listen: {}
    row: 2
    col: 0
    width: 8
    height: 6
  - title: Smoke Test Suite
    name: Smoke Test Suite
    model: mobile_testops
    explore: report_test_coverage_by_project_prod
    type: looker_pie
    fields: [report_test_coverage_by_project_prod.status, sum_tests_same_status]
    filters:
      report_test_coverage_by_project_prod.created_week: 2 weeks
    sorts: [report_test_coverage_by_project_prod.status]
    limit: 500
    dynamic_fields: [{category: measure, expression: !!null '', label: Sum tests same
          status, value_format: !!null '', value_format_name: !!null '', based_on: report_test_coverage_by_project_prod.test_count_sum,
        _kind_hint: measure, measure: sum_tests_same_status, type: sum, _type_hint: number}]
    filter_expression: ${report_test_coverage_by_project_prod.test_sub_suite_abbrev}
      = "smoke" AND ${report_test_coverage_by_project_prod.project_name_abbrev} =
      "fenix"
    value_labels: legend
    label_type: labPer
    series_colors:
      Completed: "#16e085"
      Suitable: "#33f6ff"
      Unsuitable: "#e7e4f5"
      Untriaged: "#FFA537"
      Disabled: "#ff302d"
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
    defaults_version: 1
    series_types: {}
    listen: {}
    row: 8
    col: 0
    width: 8
    height: 6
  - title: Automation Status Trend
    name: Automation Status Trend (2)
    model: mobile_testops
    explore: report_test_case_coverage_prod
    type: looker_line
    fields: [report_test_case_coverage_prod.created_week, completed, disabled, suitable,
      unsuitable, untriaged]
    fill_fields: [report_test_case_coverage_prod.created_week]
    sorts: [report_test_case_coverage_prod.created_week desc]
    limit: 500
    dynamic_fields: [{category: measure, expression: '', label: Completed, value_format: !!null '',
        value_format_name: !!null '', based_on: report_test_case_coverage_prod.test_count,
        _kind_hint: measure, measure: completed, type: sum, _type_hint: number, filters: {
          report_test_case_coverage_prod.test_automation_status_id: '4'}}, {category: measure,
        expression: '', label: Disabled, value_format: !!null '', value_format_name: !!null '',
        based_on: report_test_case_coverage_prod.test_count, _kind_hint: measure,
        measure: disabled, type: sum, _type_hint: number, filters: {report_test_case_coverage_prod.test_automation_status_id: '5'}},
      {category: measure, expression: '', label: Suitable, value_format: !!null '',
        value_format_name: !!null '', based_on: report_test_case_coverage_prod.test_count,
        _kind_hint: measure, measure: suitable, type: sum, _type_hint: number, filters: {
          report_test_case_coverage_prod.test_automation_status_id: '2'}}, {category: measure,
        expression: '', label: Unsuitable, value_format: !!null '', value_format_name: !!null '',
        based_on: report_test_case_coverage_prod.test_count, _kind_hint: measure,
        measure: unsuitable, type: sum, _type_hint: number, filters: {report_test_case_coverage_prod.test_automation_status_id: '3'}},
      {category: measure, expression: '', label: Untriaged, value_format: !!null '',
        value_format_name: !!null '', based_on: report_test_case_coverage_prod.test_count,
        _kind_hint: measure, measure: untriaged, type: sum, _type_hint: number, filters: {
          report_test_case_coverage_prod.test_automation_status_id: '1'}}]
    filter_expression: "${report_test_case_coverage_prod.projects_id} = 1 AND  ${report_test_case_coverage_prod.test_sub_suites_id}\
      \ = 2"
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
    show_null_points: false
    interpolation: linear
    series_colors:
      untriaged: "#FFA537"
      completed: "#16e085"
      disabled: "#ff302d"
      suitable: "#33f6ff"
      unsuitable: "#e7e4f5"
    defaults_version: 1
    listen: {}
    row: 8
    col: 8
    width: 16
    height: 6
  - name: Q2 2022
    type: text
    title_text: Q2 2022
    subtitle_text: ''
    body_text: ''
    row: 16
    col: 0
    width: 6
    height: 2
  - name: " (2)"
    type: text
    title_text: ''
    subtitle_text: ''
    body_text: |-
      ## Releases Tested
      ----------------------------------------------------------------------------------------------------------------------------    row: 14
    col: 0
    width: 24
    height: 2
  - name: " (3)"
    type: text
    title_text: ''
    subtitle_text: ''
    body_text: "# 32"
    row: 18
    col: 2
    width: 2
    height: 2
  - name: " (4)"
    type: text
    title_text: ''
    subtitle_text: ''
    body_text: "| Versions                     \t|\n|------------------------------\t\
      |\n| Firefox Beta 103.0.0-beta.1  \t|\n| Firefox RC 102.1.1           \t|\n\
      | Firefox Beta 102.0.0-beta.5  \t|\n| Firefox RC 102.1.0           \t|\n| Firefox\
      \ Beta 102.0.0-beta.4  \t|\n| Firefox RC 101.2.0           \t|\n| Firefox Beta\
      \ 102.0.0-beta.3  \t|\n|  Firefox Beta 102.0.0-beta.2 \t|\n| Firefox Beta 102.0.0-beta.1\
      \  \t|\n| Firefox 101.1.1              \t|\n| Firefox 101.1.0              \t\
      |\n| Firefox 100.3.0              \t|\n| Firefox 101.0.0-beta.6       \t|\n\
      |  Firefox 100.2.0             \t|\n| Firefox Beta 101.0.0-beta.5  \t|\n| Firefox\
      \ Beta 101.0.0-beta.4  \t|\n| Firefox Beta 101.0.0-beta.2  \t|\n|  Firefox 100.1.2\
      \             \t|\n|  Firefox Beta 101.0.0-beta.3 \t|\n| Firefox Beta 101.0.0-beta.1\
      \  \t|\n| Firefox Beta 100.0.0-beta.5  \t|\n| Firefox Beta 100.0.0-beta.6  \t\
      |\n| Firefox 100.1.1              \t|\n| Firefox Beta 100.0.0-beta.7  \t|\n\
      | Firefox 100.1.0              \t|\n| Firefox 99.2.0               \t|\n| Firefox\
      \ Beta 100.0.0-beta.1  \t|\n| Firefox Beta 100.0.0-beta.3  \t|\n| Firefox Beta\
      \ 100.0.0-beta.4  \t|\n| Firefox 98.3.0               \t|\n| Firefox Beta 99.0.0-beta.5\
      \   \t|\n| Firefox Beta 99.0.0-beta.4   \t|"
    row: 16
    col: 6
    width: 8
    height: 11
