view: fenix_daily_android {
  sql_table_name: `moz-mobile-tools.testops_stats.fenix_daily_android` ;;

  dimension_group: date {
    type: time
    description: "Date of the test results."
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.Date ;;
  }

  dimension: failed_runs {
    type: number
    description: "Number of failed test runs."
    sql: ${TABLE}.`Failed Runs` ;;
  }

  dimension: failure_rate {
    type: number
    description: "Failure rate as a percentage (e.g., 0.04% displayed as 4%)."
    sql: ${TABLE}.`Failure Rate` ;;
    value_format: "0.##%"  # Ensures percentage display
  }

  dimension: flaky_rate {
    type: number
    description: "Flaky rate as a percentage (e.g., 0.23% displayed as 23%)."
    sql: ${TABLE}.`Flaky Rate` ;;
    value_format: "0.##%"  # Ensures percentage display
  }

  dimension: flaky_runs {
    type: number
    description: "Number of flaky test runs."
    sql: ${TABLE}.`Flaky Runs` ;;
  }

  dimension: total_runs {
    type: number
    description: "Total number of test runs."
    sql: ${TABLE}.`Total Runs` ;;
  }

  measure: count {
    type: count
  }

  measure: monthly_failure_rate {
    type: number
    description: "Monthly failure rate calculated as total failed runs divided by total test runs."
    sql: SUM(${failed_runs}) / SUM(${total_runs}) ;;
    value_format: "0.##%"
    group_label: "Monthly Metrics"
  }

  measure: monthly_flaky_rate {
    type: number
    description: "Monthly flaky rate calculated as total flaky runs divided by total test runs."
    sql: SUM(${flaky_runs}) / SUM(${total_runs}) ;;
    value_format: "0.##%"
    group_label: "Monthly Metrics"
  }

  measure: monthly_run_volume {
    type: number
    description: "Total number of test runs per month."
    sql: SUM(${total_runs}) ;;
    value_format: "#,##0"  # Formats as a whole number
    group_label: "Monthly Metrics"
  }

  measure: current_flaky_rate {
    type: average
    description: "Flaky rate over the last 30 days."
    sql: ${flaky_runs} / ${total_runs} ;;
    value_format: "0.##%"
    group_label: "Summary KPIs"
    filters: [date_date: "this month"]
  }

  measure: current_failure_rate {
    type: average
    description: "Failure rate for the current month."
    sql: ${failed_runs} / ${total_runs} ;;
    value_format: "0.##%"
    group_label: "Summary KPIs"
    filters: [date_date: "this month"]
  }

  measure: total_tests_this_month {
    type: sum
    description: "Total number of test runs executed in the current month."
    sql: ${total_runs} ;;
    value_format: "#,##0"
    group_label: "Summary KPIs"
    filters: [date_date: "this month"]
  }

  measure: total_tests_last_month {
    type: sum
    description: "Total number of test runs executed in the previous month."
    sql: ${total_runs} ;;
    value_format: "#,##0"
    group_label: "Summary KPIs"
    filters: [date_date: "last month"]
  }

  measure: total_tests_change {
    type: number
    description: "Difference in total test runs between this month and last month."
    sql: ${total_tests_this_month} - ${total_tests_last_month} ;;
    value_format: "#,##0"
    group_label: "Summary KPIs"
  }

  measure: total_tests_percentage_change {
    type: number
    description: "Percentage change in test runs compared to last month."
    sql:
    CASE
      WHEN ${total_tests_last_month} IS NULL OR ${total_tests_last_month} = 0 THEN NULL
      ELSE ((${total_tests_this_month} - ${total_tests_last_month}) / ${total_tests_last_month})
    END ;;
    value_format: "0.##%"
    group_label: "Summary KPIs"
  }

}
