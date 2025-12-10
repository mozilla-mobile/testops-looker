view: report_testrail_test_health_preflight {
  sql_table_name: `moz-mobile-tools.tmp.report_testrail_test_health_preflight` ;;

  dimension: avg_runtime {
    type: number
    sql: ${TABLE}.avg_runtime ;;
  }
  dimension: case_id {
    type: number
    sql: ${TABLE}.case_id ;;
  }
  dimension: case_name {
    type: string
    sql: ${TABLE}.case_name ;;
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
  dimension: project_id {
    type: number
    sql: ${TABLE}.project_id ;;
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
  dimension: suite_name {
    type: string
    sql: ${TABLE}.suite_name ;;
  }
  measure: count {
    type: count
    drill_fields: [case_name, suite_name]
  }
}
