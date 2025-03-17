view: ios_longest_test_executions {
  sql_table_name: `moz-mobile-tools.testops_stats.ios_longest_test_executions` ;;

  dimension_group: latest_timestamp {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.latest_timestamp ;;
  }
  dimension: max_execution_time {
    type: number
    sql: ${TABLE}.max_execution_time ;;
  }
  dimension: test_case {
    type: string
    sql: ${TABLE}.test_case ;;
  }
  measure: count {
    type: count
  }
}
