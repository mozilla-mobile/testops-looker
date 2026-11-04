view: android_fenix_test_sunset_verdict {
  derived_table: {
    sql:
      WITH pairs AS (
        SELECT
          e.test_name,
          e.class_name AS tae_class,
          l.class_name AS legacy_class,
          e.total_runs AS tae_runs,
          e.flaky_runs AS tae_flaky_runs,
          e.failed_runs AS tae_failed_runs,
          ROUND(SAFE_DIVIDE(e.flaky_runs, e.total_runs) * 100, 2) AS tae_flaky_pct,
          ROUND(SAFE_DIVIDE(e.failed_runs, e.total_runs) * 100, 2) AS tae_failure_pct,
          e.last_failure_date AS tae_last_failure,
          e.last_flaky_date AS tae_last_flaky,
          DATE_DIFF(CURRENT_DATE(), e.last_failure_date, DAY) AS days_since_failure,
          DATE_DIFF(CURRENT_DATE(), e.last_flaky_date, DAY) AS days_since_flaky,
          e.first_seen_date AS tae_first_seen,
          ROUND(SAFE_DIVIDE(e.total_duration, e.total_runs), 2) AS tae_avg_duration,
          l.total_runs AS legacy_runs,
          ROUND(SAFE_DIVIDE(l.total_duration, l.total_runs), 2) AS legacy_avg_duration,
          ROUND(SAFE_DIVIDE(l.flaky_runs, l.total_runs) * 100, 2) AS legacy_flaky_pct,
          COUNT(*) OVER (PARTITION BY e.test_name) AS legacy_instance_count
        FROM `moz-mobile-tools.testops_results.fenix_ui_tests` e
        JOIN `moz-mobile-tools.testops_results.fenix_ui_tests` l
          ON e.test_name = l.test_name
        WHERE e.class_name LIKE '%efficiency%'
          AND l.class_name NOT LIKE '%efficiency%'
          AND l.class_name NOT LIKE '%benchmark%'
          AND e.last_updated >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 14 DAY)
          AND l.last_updated >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 14 DAY)
      )
      SELECT
        test_name,
        tae_class,
        legacy_class,
        legacy_instance_count,
        tae_runs,
        tae_flaky_runs,
        tae_failed_runs,
        tae_flaky_pct,
        tae_failure_pct,
        tae_last_failure,
        tae_last_flaky,
        days_since_failure,
        days_since_flaky,
        tae_first_seen,
        tae_avg_duration,
        legacy_runs,
        legacy_avg_duration,
        legacy_flaky_pct,
        ROUND(SAFE_DIVIDE(tae_avg_duration, legacy_avg_duration), 2) AS duration_ratio,
        ROUND(legacy_avg_duration * legacy_runs / 3600, 1) AS legacy_ci_hours,
        CASE
          WHEN SAFE_DIVIDE(tae_avg_duration, legacy_avg_duration) > 2.0 THEN 'Investigate'
          WHEN SAFE_DIVIDE(tae_avg_duration, legacy_avg_duration) > 1.25 THEN 'Slower'
          ELSE 'OK'
        END AS duration_flag,
        CASE
          WHEN tae_runs >= 200
            AND (tae_last_failure IS NULL OR days_since_failure >= 30)
            AND (tae_last_flaky IS NULL OR days_since_flaky >= 30)
          THEN 'Ready to Sunset'
          WHEN tae_runs >= 200
          THEN 'Monitoring'
          ELSE 'Building Runs'
        END AS verdict
      FROM pairs
    ;;
  }

  # ---------- Identity ----------

  dimension: test_name {
    type: string
    sql: ${TABLE}.test_name ;;
    primary_key: yes
    label: "Test Name"
  }

  dimension: tae_class {
    type: string
    sql: ${TABLE}.tae_class ;;
    label: "TAE Class"
    description: "Efficiency class containing the replacement test"
  }

  dimension: legacy_class {
    type: string
    sql: ${TABLE}.legacy_class ;;
    label: "Legacy Class"
    description: "Legacy class to be retired. Use the full path when filing the bug."
  }

  dimension: legacy_instance_count {
    type: number
    sql: ${TABLE}.legacy_instance_count ;;
    label: "Legacy Instances"
    description: "Number of legacy classes containing this test name. Greater than 1 means one bug covers multiple deletions."
  }

  # ---------- Verdict ----------

  dimension: verdict {
    type: string
    sql: ${TABLE}.verdict ;;
    label: "Sunset Verdict"
    description: "Ready to Sunset: 200+ runs, no failure or flake in 30 days. Monitoring: 200+ runs but recent failure or flake. Building Runs: under 200 runs."
  }

  # ---------- TAE health ----------

  dimension: tae_runs {
    type: number
    sql: ${TABLE}.tae_runs ;;
    label: "TAE Runs"
  }

  dimension: tae_flaky_runs {
    type: number
    sql: ${TABLE}.tae_flaky_runs ;;
    label: "TAE Flaky Runs"
  }

  dimension: tae_failed_runs {
    type: number
    sql: ${TABLE}.tae_failed_runs ;;
    label: "TAE Failed Runs"
  }

  dimension: tae_flaky_pct {
    type: number
    sql: ${TABLE}.tae_flaky_pct ;;
    value_format: "0.00\%"
    label: "TAE Flaky % (lifetime)"
    description: "Lifetime rate. Includes historical incidents and does not reflect current health. Not used in the verdict."
  }

  dimension: tae_failure_pct {
    type: number
    sql: ${TABLE}.tae_failure_pct ;;
    value_format: "0.00\%"
    label: "TAE Failure % (lifetime)"
    description: "Lifetime rate. Includes historical incidents and does not reflect current health. Not used in the verdict."
  }

  dimension: days_since_failure {
    type: number
    sql: ${TABLE}.days_since_failure ;;
    label: "Days Since Last Failure"
    description: "Null means the test has never failed."
  }

  dimension: days_since_flaky {
    type: number
    sql: ${TABLE}.days_since_flaky ;;
    label: "Days Since Last Flake"
    description: "Null means the test has never flaked."
  }

  dimension: tae_last_failure {
    type: date
    datatype: date
    sql: ${TABLE}.tae_last_failure ;;
    label: "TAE Last Failure"
  }

  dimension: tae_last_flaky {
    type: date
    datatype: date
    sql: ${TABLE}.tae_last_flaky ;;
    label: "TAE Last Flake"
  }

  dimension: tae_first_seen {
    type: date
    datatype: date
    sql: ${TABLE}.tae_first_seen ;;
    label: "TAE First Seen"
  }

  # ---------- Duration ----------

  dimension: tae_avg_duration {
    type: number
    sql: ${TABLE}.tae_avg_duration ;;
    value_format: "0.00"
    label: "TAE Avg Duration (s)"
  }

  dimension: legacy_avg_duration {
    type: number
    sql: ${TABLE}.legacy_avg_duration ;;
    value_format: "0.00"
    label: "Legacy Avg Duration (s)"
  }

  dimension: duration_ratio {
    type: number
    sql: ${TABLE}.duration_ratio ;;
    value_format: "0.00"
    label: "TAE / Legacy Duration"
    description: "Ratio of TAE runtime to legacy runtime. Below 1.0 means TAE is faster."
  }

  dimension: duration_flag {
    type: string
    sql: ${TABLE}.duration_flag ;;
    label: "Duration"
    description: "OK at or below 1.25x, Slower 1.25 to 2x, Investigate above 2x. Informational only, does not gate the verdict."
  }

  # ---------- Legacy cost ----------

  dimension: legacy_runs {
    type: number
    sql: ${TABLE}.legacy_runs ;;
    label: "Legacy Runs"
  }

  dimension: legacy_flaky_pct {
    type: number
    sql: ${TABLE}.legacy_flaky_pct ;;
    value_format: "0.00\%"
    label: "Legacy Flaky %"
  }

  dimension: legacy_ci_hours {
    type: number
    sql: ${TABLE}.legacy_ci_hours ;;
    value_format: "0.0"
    label: "Legacy CI Hours"
    description: "Total CI hours consumed by this legacy test to date. Recovered when the test is retired. Use to prioritise the retirement ramp."
  }

  # ---------- Measures ----------

  measure: count {
    type: count
    label: "Converted Pairs"
    description: "Number of TAE tests paired to a legacy test by method name"
  }

  measure: ready_count {
    type: count
    filters: [verdict: "Ready to Sunset"]
    label: "Ready"
  }

  measure: monitoring_count {
    type: count
    filters: [verdict: "Monitoring"]
    label: "Monitoring"
  }

  measure: building_runs_count {
    type: count
    filters: [verdict: "Building Runs"]
    label: "Building Runs"
  }

  measure: ready_ci_hours {
    type: sum
    sql: ${legacy_ci_hours} ;;
    filters: [verdict: "Ready to Sunset"]
    value_format: "0"
    label: "Recoverable CI Hours"
    description: "Total legacy CI hours recoverable across all tests currently Ready to Sunset"
  }

  measure: total_ci_hours {
    type: sum
    sql: ${legacy_ci_hours} ;;
    value_format: "0"
    label: "Total Legacy CI Hours"
  }

  measure: investigate_duration_count {
    type: count
    filters: [duration_flag: "Investigate"]
    label: "Duration Investigate"
    description: "TAE tests running more than 2x slower than the legacy test they replace"
  }
}
