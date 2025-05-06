view: ios_flaky_tests_daily {
  sql_table_name: `moz-mobile-tools.testops_stats.ios_flaky_tests_daily` ;;

  dimension: branch {
    type: string
    sql: ${TABLE}.branch ;;
  }
  dimension: device {
    type: string
    sql: ${TABLE}.device ;;
  }
  dimension: flaky_test_count {
    type: number
    sql: ${TABLE}.flaky_test_count ;;
  }
  dimension: flaky_test_details {
    type: string
    sql: ${TABLE}.flaky_test_details ;;
  }
  dimension: flaky_tests_ratio {
    type: number
    sql: ${TABLE}.flaky_tests_ratio ;;
  }
  dimension_group: report {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.report_date ;;
  }
  dimension: total_tests {
    type: number
    sql: ${TABLE}.total_tests ;;
  }
  measure: count {
    type: count
  }

  measure: current_flaky_rate {
    type: average
    description: "Flaky rate over the last 30 days."
    sql: ${flaky_test_count} / ${total_tests} ;;
    value_format: "0.##%"
    group_label: "Summary KPIs"
    filters: [report_date: "this month"]
  }
}
