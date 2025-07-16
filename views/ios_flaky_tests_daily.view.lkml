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
    description: "Flaky rate as a percentage (e.g., 0.23% displayed as 23%)."
    sql: ${TABLE}.flaky_tests_ratio ;;
    value_format: "0.##%"  # Ensures percentage display
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

  measure: total_tests_this_month {
    type: sum
    sql: CASE WHEN EXTRACT(MONTH FROM ${report_date}) = EXTRACT(MONTH FROM CURRENT_DATE())
            THEN ${total_tests}
            ELSE 0 END ;;
  }

  measure: total_tests_last_month {
    type: sum
    sql: CASE WHEN EXTRACT(MONTH FROM ${report_date}) = EXTRACT(MONTH FROM DATE_SUB(CURRENT_DATE(), INTERVAL 1 MONTH))
            THEN ${total_tests}
            ELSE 0 END ;;
  }

  measure: total_tests_percentage_change {
    type: number
    sql: (${total_tests_this_month} - ${total_tests_last_month}) / NULLIF(${total_tests_last_month}, 0) ;;
    value_format_name: percent_2
    group_label: "Summary KPIs"
  }

  measure: flaky_failure_rate {
    type: number
    description: "Monthly flaky rate calculated as total flaky runs divided by total failures."
    sql: SUM(${flaky_test_count}) / NULLIF(SUM(${total_tests}), 0) ;;
    value_format: "0.##%"
    group_label: "Monthly Metrics"
  }

}
