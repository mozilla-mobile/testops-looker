view: report_test_run_counts {
  sql_table_name: `moz-mobile-tools.testops_dashboard.report_test_run_counts`
    ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
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

  dimension: projects_id {
    type: number
    sql: ${TABLE}.projects_id ;;
  }

  dimension: test_case_blocked_count {
    type: number
    sql: ${TABLE}.test_case_blocked_count ;;
  }

  dimension: test_case_failed_count {
    type: number
    sql: ${TABLE}.test_case_failed_count ;;
  }

  dimension: test_case_passed_count {
    type: number
    sql: ${TABLE}.test_case_passed_count ;;
  }

  dimension: test_case_retest_count {
    type: number
    sql: ${TABLE}.test_case_retest_count ;;
  }

  dimension: test_sub_suites_id {
    type: number
    sql: ${TABLE}.test_sub_suites_id ;;
  }

  dimension: test_suites_id {
    type: number
    sql: ${TABLE}.test_suites_id ;;
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

  dimension_group: testrail_created {
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
    sql: ${TABLE}.testrail_created_on ;;
  }

  dimension: testrail_run_id {
    type: number
    sql: ${TABLE}.testrail_run_id ;;
  }

  measure: count {
    type: count
    drill_fields: [id]
  }
}
