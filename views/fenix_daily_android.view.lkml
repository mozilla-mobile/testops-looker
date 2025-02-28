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
    description: "Percentage as a float (e.g., 0.0004 for 0.04%)."
    sql: ${TABLE}.`Failure Rate` ;;
  }
  dimension: flaky_rate {
    type: number
    description: "Percentage as a float (e.g., 0.0023 for 0.23%)."
    sql: ${TABLE}.`Flaky Rate` ;;
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
