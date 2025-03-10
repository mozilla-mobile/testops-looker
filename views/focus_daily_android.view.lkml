view: focus_daily_android {
  sql_table_name: `moz-mobile-tools.testops_stats.focus_daily_android` ;;

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
    description: "Percentage as a float (e.g., 0.0004 for 0.04%)."
    sql: ${TABLE}.`Failure Rate` ;;
    value_format: "0.##%"  # Ensures percentage display
  }
  dimension: flaky_rate {
    type: number
    description: "Percentage as a float (e.g., 0.0023 for 0.23%)."
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
}
