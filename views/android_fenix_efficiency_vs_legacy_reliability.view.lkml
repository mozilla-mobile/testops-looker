view: android_fenix_efficiency_vs_legacy_reliability {
  derived_table: {
    sql:
      WITH combined AS (
        SELECT
          a.date,
          a.total_runs AS all_runs,
          a.flaky_runs AS all_flaky,
          a.failed_runs AS all_failed,
          COALESCE(e.total_runs, 0) AS tae_runs,
          COALESCE(e.flaky_runs, 0) AS tae_flaky,
          COALESCE(e.failed_runs, 0) AS tae_failed
        FROM `moz-mobile-tools.testops_results.fenix_daily_totals` a
        LEFT JOIN `moz-mobile-tools.testops_results.fenix_efficiency_daily_totals` e
          ON a.date = e.date
        WHERE a.date >= DATE_SUB(CURRENT_DATE(), INTERVAL 90 DAY)
      ),
      totals AS (
        SELECT
          SUM(tae_runs) AS tae_runs,
          SUM(tae_flaky) AS tae_flaky,
          SUM(tae_failed) AS tae_failed,
          SUM(all_runs - tae_runs) AS legacy_runs,
          SUM(all_flaky - tae_flaky) AS legacy_flaky,
          SUM(all_failed - tae_failed) AS legacy_failed,
          MIN(date) AS window_start,
          MAX(date) AS window_end
        FROM combined
      )
      SELECT
        1 AS sort_order,
        'TAE' AS suite,
        tae_runs AS total_runs,
        tae_flaky AS flaky_runs,
        tae_failed AS failed_runs,
        ROUND(SAFE_DIVIDE(tae_flaky, tae_runs) * 100, 3) AS flaky_pct,
        ROUND(SAFE_DIVIDE(tae_failed, tae_runs) * 100, 3) AS failure_pct,
        window_start,
        window_end
      FROM totals
      UNION ALL
      SELECT
        2,
        'Legacy',
        legacy_runs,
        legacy_flaky,
        legacy_failed,
        ROUND(SAFE_DIVIDE(legacy_flaky, legacy_runs) * 100, 3),
        ROUND(SAFE_DIVIDE(legacy_failed, legacy_runs) * 100, 3),
        window_start,
        window_end
      FROM totals
    ;;
  }

  dimension: suite {
    type: string
    sql: ${TABLE}.suite ;;
    primary_key: yes
    label: "Suite"
  }

  dimension: sort_order {
    type: number
    sql: ${TABLE}.sort_order ;;
    hidden: yes
  }

  dimension: total_runs {
    type: number
    sql: ${TABLE}.total_runs ;;
    label: "Total Runs (90d)"
  }

  dimension: flaky_runs {
    type: number
    sql: ${TABLE}.flaky_runs ;;
    label: "Flaky Runs"
  }

  dimension: failed_runs {
    type: number
    sql: ${TABLE}.failed_runs ;;
    label: "Failed Runs"
  }

  dimension: flaky_pct {
    type: number
    sql: ${TABLE}.flaky_pct ;;
    value_format: "0.000\%"
    label: "Flaky Rate"
  }

  dimension: failure_pct {
    type: number
    sql: ${TABLE}.failure_pct ;;
    value_format: "0.000\%"
    label: "Failure Rate"
  }

  dimension: window_start {
    type: date
    datatype: date
    sql: ${TABLE}.window_start ;;
    label: "Window Start"
  }

  # Measures — required for bar charts; dimensions won't plot as bars
  measure: flaky_rate {
    type: max
    sql: ${flaky_pct} ;;
    value_format: "0.000\%"
    label: "Flaky Rate"
  }

  measure: failure_rate {
    type: max
    sql: ${failure_pct} ;;
    value_format: "0.000\%"
    label: "Failure Rate"
  }

  measure: runs {
    type: max
    sql: ${total_runs} ;;
    label: "Total Runs"
  }
}
