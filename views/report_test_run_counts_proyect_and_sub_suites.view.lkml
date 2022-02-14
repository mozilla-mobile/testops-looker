view: report_test_run_counts_proyect_and_sub_suites {
  sql_table_name: `moz-mobile-tools.testops_dashboard.report_test_run_counts_proyect_and_sub_suites`
    ;;

  dimension: project_name_abbrev {
    type: string
    sql: ${TABLE}.project_name_abbrev ;;
  }

  dimension: test_failed_count {
    type: number
    sql: ${TABLE}.test_failed_count ;;
  }

  dimension: test_passed_count {
    type: number
    sql: ${TABLE}.test_passed_count ;;
  }

  dimension: test_sub_suite {
    type: string
    sql: ${TABLE}.test_sub_suite ;;
  }

  dimension: testrail_test_suites_id {
    type: number
    sql: ${TABLE}.testrail_test_suites_id ;;
  }

  dimension_group: testrail_completed {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.testrail_completed_on ;;
  }

  dimension: total_sum {
    type: number
    sql: ${TABLE}.total_sum ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
