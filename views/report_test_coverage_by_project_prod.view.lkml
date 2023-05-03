view: report_test_coverage_by_project_prod {
  sql_table_name: `moz-mobile-tools.testops_dashboard.report_test_coverage_by_project_prod`
    ;;

  dimension: coverage {
    type: string
    sql: ${TABLE}.coverage ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.created_at ;;
  }

  dimension: project_name_abbrev {
    type: string
    sql: ${TABLE}.project_name_abbrev ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: test_count_sum {
    type: number
    sql: ${TABLE}.test_count_sum ;;
  }

  dimension: test_sub_suite_abbrev {
    type: string
    sql: ${TABLE}.test_sub_suite_abbrev ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
