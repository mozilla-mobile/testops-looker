view: report_test_coverage_show_status {
  sql_table_name: `moz-mobile-tools.testops_dashboard.report_test_coverage_show_status`
    ;;

  dimension: coverage {
    type: string
    sql: ${TABLE}.coverage ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: test_count_sum {
    type: number
    sql: ${TABLE}.test_count_sum ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
