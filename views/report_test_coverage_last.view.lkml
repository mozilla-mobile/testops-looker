view: report_test_coverage_last {
  sql_table_name: `moz-mobile-tools.testops_dashboard.report_test_coverage_last`
    ;;

  dimension: projects_id {
    type: number
    sql: ${TABLE}.projects_id ;;
  }

  dimension: test_automation_status_id {
    type: number
    sql: ${TABLE}.test_automation_status_id ;;
  }

  dimension: test_count_sum {
    type: number
    sql: ${TABLE}.test_count_sum ;;
  }

  dimension: test_sub_suites_id {
    type: number
    sql: ${TABLE}.test_sub_suites_id ;;
  }

  dimension: test_suites_id {
    type: number
    sql: ${TABLE}.test_suites_id ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
