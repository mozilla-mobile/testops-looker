view: android_fenix_test_results {
  sql_table_name: `moz-mobile-tools.testops_results.fenix_ui_tests` ;;

  dimension: class_name {
    type: string
    sql: ${TABLE}.class_name ;;
  }

  dimension: short_class_name {
    type: string
    sql: REGEXP_EXTRACT(${class_name}, r'\.([^.]+)$') ;;
    description: "Class name without package prefix"
  }

  dimension: test_package {
    type: string
    sql: REGEXP_REPLACE(${class_name}, r'\.[^.]+$', '') ;;
    description: "Package path without class name"
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

  dimension: last_failure_date {
    type: date
    sql: ${TABLE}.last_failure_date ;;
    description: "Date of the most recent failure for this test"
  }

  dimension: last_flaky_date {
    type: date
    sql: ${TABLE}.last_flaky_date ;;
    description: "Date of the most recent flaky occurrence for this test"
  }

  # Is efficiency test
  dimension: is_efficiency_test {
    type: yesno
    sql: ${class_name} LIKE '%efficiency%' ;;
  }

  # Is benchmark test
  dimension: is_benchmark_test {
    type: yesno
    sql: ${class_name} LIKE '%benchmark%' ;;
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

  dimension: pass_rate {
    type: number
    sql: SAFE_DIVIDE(${total_runs} - ${flaky_runs} - ${failed_runs}, ${total_runs}) * 100 ;;
    value_format: "0.00\%"
  }

  # Average duration
  dimension: avg_duration_seconds {
    type: number
    sql: SAFE_DIVIDE(${total_duration}, ${total_runs}) ;;
    value_format: "0.00"
    description: "Average test duration in seconds"
  }

  # Duration tier for grouping
  dimension: duration_tier {
    type: tier
    tiers: [5, 15, 30, 60, 120]
    style: integer
    sql: SAFE_DIVIDE(${total_duration}, ${total_runs}) ;;
    description: "Test duration buckets in seconds"
  }

  # Health status with recency awareness
  dimension: test_health_status {
    type: string
    sql: CASE
      WHEN SAFE_DIVIDE(${TABLE}.failed_runs, ${TABLE}.total_runs) * 100 > 1
        AND ${TABLE}.last_failure_date >= DATE_SUB(CURRENT_DATE(), INTERVAL 7 DAY)
        THEN 'Failing'
      WHEN SAFE_DIVIDE(${TABLE}.failed_runs, ${TABLE}.total_runs) * 100 > 1
        THEN 'Recovered'
      WHEN SAFE_DIVIDE(${TABLE}.flaky_runs, ${TABLE}.total_runs) * 100 > 1
        AND ${TABLE}.last_flaky_date >= DATE_SUB(CURRENT_DATE(), INTERVAL 7 DAY)
        THEN 'Flaky'
      WHEN SAFE_DIVIDE(${TABLE}.flaky_runs, ${TABLE}.total_runs) * 100 > 1
        THEN 'Recovered'
      ELSE 'Healthy'
    END ;;
    description: "Health status based on rates and recency. Tests with high rates but no recent issues show as Recovered."
  }

  # Measures
  measure: count {
    type: count
  }

  measure: total_runs_sum {
    type: sum
    sql: ${total_runs} ;;
  }

  measure: flaky_runs_sum {
    type: sum
    sql: ${flaky_runs} ;;
  }

  measure: failed_runs_sum {
    type: sum
    sql: ${failed_runs} ;;
  }

  measure: avg_flaky_rate {
    type: average
    sql: SAFE_DIVIDE(${TABLE}.flaky_runs, ${TABLE}.total_runs) * 100 ;;
    value_format: "0.00\%"
  }

  measure: avg_failure_rate {
    type: average
    sql: SAFE_DIVIDE(${TABLE}.failed_runs, ${TABLE}.total_runs) * 100 ;;
    value_format: "0.00\%"
  }
}
