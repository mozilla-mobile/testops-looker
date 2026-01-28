view: android_fenix_test_results {
  sql_table_name: `moz-mobile-tools.testops_results.fenix_ui_tests` ;;

  dimension: class_name {
    type: string
    sql: ${TABLE}.class_name ;;
  }

  dimension: test_name {
    type: string
    sql: ${TABLE}.test_name ;;
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

  dimension: last_updated {
    type: date_time
    sql: ${TABLE}.last_updated ;;
  }

  # Computed rates
  dimension: flaky_rate {
    type: number
    sql: SAFE_DIVIDE(${flaky_runs}, ${total_runs}) * 100 ;;
    value_format: "0.00\%"
  }

  dimension: failure_rate {
    type: number
    sql: SAFE_DIVIDE(${failed_runs}, ${total_runs}) * 100 ;;
    value_format: "0.00\%"
  }
}
