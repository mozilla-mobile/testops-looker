view: fennec_test_results_ios {
  sql_table_name: `moz-mobile-tools.testops_stats.fennec_test_results_ios` ;;

  dimension: branch {
    type: string
    sql: ${TABLE}.branch ;;
  }
  dimension: device {
    type: string
    sql: ${TABLE}.device ;;
  }
  dimension: execution_time_s {
    type: number
    sql: ${TABLE}.execution_time_s ;;
  }
  dimension: result {
    type: string
    sql: ${TABLE}.result ;;
  }
  dimension: suite {
    type: string
    sql: ${TABLE}.suite ;;
  }
  dimension: test_case {
    type: string
    sql: ${TABLE}.test_case ;;
  }
  dimension: test_suite {
    type: string
    sql: ${TABLE}.test_suite ;;
  }
  dimension_group: timestamp {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.timestamp ;;
  }
  measure: count {
    type: count
  }
}
