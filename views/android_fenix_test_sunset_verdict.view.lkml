view: android_fenix_test_sunset_verdict {
  derived_table: {
    sql:
      WITH pairs AS (
        SELECT
          e.test_name,
          e.class_name AS tae_class,
          l.class_name AS legacy_class,
          e.total_runs AS tae_runs,
          l.total_runs AS legacy_runs,
          ROUND(SAFE_DIVIDE(e.total_duration, e.total_runs), 2) AS tae_avg_duration,
          ROUND(SAFE_DIVIDE(l.total_duration, l.total_runs), 2) AS legacy_avg_duration,
          ROUND(SAFE_DIVIDE(e.flaky_runs, e.total_runs) * 100, 2) AS tae_flaky_pct,
          ROUND(SAFE_DIVIDE(e.failed_runs, e.total_runs) * 100, 2) AS tae_failure_pct,
          e.last_failure_date AS tae_last_failure,
          e.last_flaky_date AS tae_last_flaky,
          DATE_DIFF(CURRENT_DATE(), e.last_failure_date, DAY) AS days_since_failure,
          DATE_DIFF(CURRENT_DATE(), e.last_flaky_date, DAY) AS days_since_flaky,
          e.first_seen_date AS tae_first_seen
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
        tae_runs,
        legacy_runs,
        tae_avg_duration,
        legacy_avg_duration,
        tae_flaky_pct,
        tae_failure_pct,
        tae_last_failure,
        tae_last_flaky,
        days_since_failure,
        days_since_flaky,
        tae_first_seen,
        CASE
          WHEN tae_runs >= 200
            AND tae_flaky_pct <= 0.5
            AND tae_failure_pct <= 0.5
            AND (tae_last_failure IS NULL OR days_since_failure >= 14)
            AND (tae_last_flaky IS NULL OR days_since_flaky >= 14)
          THEN 'Ready to Sunset'
          WHEN tae_runs >= 200
            AND tae_flaky_pct <= 0.5
            AND tae_failure_pct <= 0.5
          THEN 'Monitoring'
          WHEN tae_runs < 200
            AND tae_flaky_pct <= 0.5
            AND tae_failure_pct <= 0.5
          THEN 'Monitoring'
          ELSE 'Not Ready'
        END AS verdict
      FROM pairs
    ;;
  }

  dimension: test_name {
    type: string
    sql: ${TABLE}.test_name ;;
    primary_key: yes
  }

  dimension: tae_class {
    type: string
    sql: ${TABLE}.tae_class ;;
    label: "TAE Class"
  }

  dimension: legacy_class {
    type: string
    sql: ${TABLE}.legacy_class ;;
    label: "Legacy Class"
  }

  dimension: tae_runs {
    type: number
    sql: ${TABLE}.tae_runs ;;
    label: "TAE Runs"
  }

  dimension: legacy_runs {
    type: number
    sql: ${TABLE}.legacy_runs ;;
    label: "Legacy Runs"
  }

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

  dimension: tae_flaky_pct {
    type: number
    sql: ${TABLE}.tae_flaky_pct ;;
    value_format: "0.00\%"
    label: "TAE Flaky %"
  }

  dimension: tae_failure_pct {
    type: number
    sql: ${TABLE}.tae_failure_pct ;;
    value_format: "0.00\%"
    label: "TAE Failure %"
  }

  dimension: days_since_failure {
    type: number
    sql: ${TABLE}.days_since_failure ;;
    label: "Days Since Last Failure"
  }

  dimension: days_since_flaky {
    type: number
    sql: ${TABLE}.days_since_flaky ;;
    label: "Days Since Last Flake"
  }

  dimension: tae_first_seen {
    type: date
    datatype: date
    sql: ${TABLE}.tae_first_seen ;;
    label: "TAE First Seen"
  }

  dimension: verdict {
    type: string
    sql: ${TABLE}.verdict ;;
    label: "Sunset Verdict"
  }

  measure: count {
    type: count
    description: "Number of paired tests"
  }

  measure: ready_count {
    type: count
    filters: [verdict: "Ready to Sunset"]
    description: "Tests ready to sunset"
  }

  measure: monitoring_count {
    type: count
    filters: [verdict: "Monitoring"]
    description: "Tests in monitoring"
  }

  measure: not_ready_count {
    type: count
    filters: [verdict: "Not Ready"]
    description: "Tests not ready"
  }
}
