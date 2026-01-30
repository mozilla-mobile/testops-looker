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

  dimension: total_duration {
    type: number
    sql: ${TABLE}.total_duration ;;
    hidden: yes
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

  # Average duration
  dimension: avg_duration_seconds {
    type: number
    sql: SAFE_DIVIDE(${total_duration}, ${total_runs}) ;;
    value_format: "0.00"
    description: "Average test duration in seconds"
  }

  # Health status based on rates
  dimension: test_health_status {
    type: string
    sql: CASE
      WHEN ${total_runs} < 10 THEN 'Low Sample'
      WHEN SAFE_DIVIDE(${flaky_runs}, ${total_runs}) > 0.01 THEN 'Flaky'
      WHEN SAFE_DIVIDE(${failed_runs}, ${total_runs}) > 0.01 THEN 'Failing'
      ELSE 'Healthy'
    END ;;
  }

  # Extract just the short class name (without package)
  dimension: short_class_name {
    type: string
    sql: REGEXP_EXTRACT(${class_name}, r'\.([^.]+)$') ;;
    description: "Class name without package prefix"
  }

  # Test package (e.g., org.mozilla.fenix.ui.efficiency)
  dimension: test_package {
    type: string
    sql: REGEXP_REPLACE(${class_name}, r'\.[^.]+$', '') ;;
    description: "Package path without class name"
  }

  # Is efficiency test
  dimension: is_efficiency_test {
    type: yesno
    sql: ${class_name} LIKE '%efficiency%' ;;
  }

  # Pass rate (inverse of flaky + failure)
  dimension: pass_rate {
    type: number
    sql: SAFE_DIVIDE(${total_runs} - ${flaky_runs} - ${failed_runs}, ${total_runs}) * 100 ;;
    value_format: "0.00\%"
  }

  # Duration tier for grouping
  dimension: duration_tier {
    type: tier
    tiers: [5, 15, 30, 60, 120]
    style: integer
    sql: SAFE_DIVIDE(${total_duration}, ${total_runs}) ;;
    description: "Test duration buckets in seconds"
  }

  measure: avg_duration_overall {
    type: average
    sql: SAFE_DIVIDE(${total_duration}, ${total_runs}) ;;
    value_format: "0.00"
    description: "Average duration across all tests"
  }

  measure: total_runs_sum {
    type: sum
    sql: ${total_runs} ;;
    description: "Sum of all test runs"
  }

  measure: flaky_runs_sum {
    type: sum
    sql: ${flaky_runs} ;;
    description: "Sum of all flaky runs"
  }

  measure: failed_runs_sum {
    type: sum
    sql: ${failed_runs} ;;
    description: "Sum of all failed runs"
  }

  measure: overall_flaky_rate {
    type: number
    sql: SAFE_DIVIDE(${flaky_runs_sum}, ${total_runs_sum}) * 100 ;;
    value_format: "0.00\%"
    description: "Overall flaky rate across all tests"
  }

  measure: overall_failure_rate {
    type: number
    sql: SAFE_DIVIDE(${failed_runs_sum}, ${total_runs_sum}) * 100 ;;
    value_format: "0.00\%"
    description: "Overall failure rate across all tests"
  }

  measure: count {
    type: count
  }
}
