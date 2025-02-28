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
}
