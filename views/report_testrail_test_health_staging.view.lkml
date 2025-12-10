view: report_testrail_test_health_staging {
  sql_table_name: `moz-mobile-tools.staging.report_testrail_test_health_staging` ;;

  dimension: avg_runtime {
    type: number
    sql: ${TABLE}.avg_runtime ;;
  }
  dimension_group: created {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.created_on ;;
  }
  dimension: most_recent_runtime {
    type: number
    sql: ${TABLE}.most_recent_runtime ;;
  }
  dimension: most_recent_status {
    type: number
    sql: ${TABLE}.most_recent_status ;;
  }
  dimension_group: most_recent_timestamp {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.most_recent_timestamp ;;
  }
  dimension: num_executions {
    type: number
    sql: ${TABLE}.num_executions ;;
  }
  dimension: pass_rate {
    type: number
    sql: ${TABLE}.pass_rate ;;
  }
  dimension: status_history_1 {
    type: number
    sql: ${TABLE}.status_history_1 ;;
  }
  dimension: status_history_2 {
    type: number
    sql: ${TABLE}.status_history_2 ;;
  }
  dimension: status_history_3 {
    type: number
    sql: ${TABLE}.status_history_3 ;;
  }
  dimension: status_history_4 {
    type: number
    sql: ${TABLE}.status_history_4 ;;
  }
  dimension: testrail_case_id {
    type: number
    sql: ${TABLE}.testrail_case_id ;;
  }
  dimension: testrail_case_name {
    type: string
    sql: ${TABLE}.testrail_case_name ;;
  }
  dimension: testrail_project_id {
    type: number
    sql: ${TABLE}.testrail_project_id ;;
  }
  dimension: testrail_suite_name {
    type: string
    sql: ${TABLE}.testrail_suite_name ;;
  }
  measure: count {
    type: count
    drill_fields: [testrail_case_name, testrail_suite_name]
  }
}
