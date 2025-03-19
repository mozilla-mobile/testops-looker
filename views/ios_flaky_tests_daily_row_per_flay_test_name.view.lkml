view: ios_flaky_tests_daily_row_per_flay_test_name {
  sql_table_name: `moz-mobile-tools.testops_stats.ios_flaky_tests_daily_row_per_flay_test_name` ;;

  dimension: branch {
    type: string
    sql: ${TABLE}.branch ;;
  }
  dimension: device {
    type: string
    sql: ${TABLE}.device ;;
  }
  dimension_group: report {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.report_date ;;
  }
  dimension: test_name {
    type: string
    sql: ${TABLE}.test_name ;;
  }
  measure: count {
    type: count
    drill_fields: [test_name]
  }
}
