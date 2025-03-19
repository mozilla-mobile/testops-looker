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
}
