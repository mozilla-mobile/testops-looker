view: android_focus_daily_totals {
  sql_table_name: `moz-mobile-tools.testops_results.focus_daily_totals` ;;

  dimension: date {
    type: date
    sql: ${TABLE}.date ;;
    primary_key: yes
  }

  dimension: total_runs {
    type: number
    sql: ${TABLE}.total_runs ;;
  }

  dimension: flaky_runs {
    type: number
    sql: ${TABLE}.flaky_runs ;;
  }

  dimension: failed_runs {
    type: number
    sql: ${TABLE}.failed_runs ;;
  }

  dimension: flaky_rate {
    type: number
    sql: ${TABLE}.flaky_rate * 100 ;;
    value_format: "0.00\%"
  }

  dimension: failure_rate {
    type: number
    sql: ${TABLE}.failure_rate * 100 ;;
    value_format: "0.00\%"
  }

  # Measures for aggregation
  measure: count {
    type: count
  }

  measure: total_runs_sum {
    type: sum
    sql: ${total_runs} ;;
  }

  measure: flaky_runs_sum {
    type: sum
    sql: ${flaky_runs} ;;
  }

  measure: failed_runs_sum {
    type: sum
    sql: ${failed_runs} ;;
  }

  measure: avg_flaky_rate {
    type: average
    sql: ${TABLE}.flaky_rate * 100 ;;
    value_format: "0.00\%"
  }

  measure: avg_failure_rate {
    type: average
    sql: ${TABLE}.failure_rate * 100 ;;
    value_format: "0.00\%"
  }
}
