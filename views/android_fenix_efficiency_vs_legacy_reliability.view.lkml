view: android_fenix_efficiency_vs_legacy_reliability {
  derived_table: {
    sql:
      WITH all_dedup AS (
        -- fenix_daily_totals has picked up duplicate rows per date from
        -- concurrent MERGE INSERTs (two instances both finding no match and
        -- both inserting). Take the largest row per date: all duplicates
        -- receive identical subsequent updates, so the max is the most
        -- complete. Without this, legacy run counts are overstated.
        SELECT date, total_runs, flaky_runs, failed_runs
        FROM `moz-mobile-tools.testops_results.fenix_daily_totals`
        QUALIFY ROW_NUMBER() OVER (PARTITION BY date ORDER BY total_runs DESC) = 1
      ),
      eff_dedup AS (
        -- No duplicates observed here today, but the same MERGE pattern is
        -- used, so dedup defensively.
        SELECT date, total_runs, flaky_runs, failed_runs
        FROM `moz-mobile-tools.testops_results.fenix_efficiency_daily_totals`
        QUALIFY ROW_NUMBER() OVER (PARTITION BY date ORDER BY total_runs DESC) = 1
      ),
      combined AS (
        SELECT
          a.date,
          a.total_runs AS all_runs,
          a.flaky_runs AS all_flaky,
          a.failed_runs AS all_failed,
          COALESCE(e.total_runs, 0) AS tae_runs,
          COALESCE(e.flaky_runs, 0) AS tae_flaky,
          COALESCE(e.failed_runs, 0) AS tae_failed
        FROM all_dedup a
        LEFT JOIN eff_dedup e
          ON a.date = e.date
        WHERE a.date >= DATE_SUB(CURRENT_DATE(), INTERVAL 90 DAY)
      ),
      totals AS (
        SELECT
          COUNT(*) AS days_in_window,
          MIN(date) AS window_start,
          MAX(date) AS window_end,
          SUM(tae_runs) AS tae_runs,
          SUM(tae_flaky) AS tae_flaky,
          SUM(tae_failed) AS tae_failed,
          SUM(all_runs - tae_runs) AS legacy_runs,
          SUM(all_flaky - tae_flaky) AS legacy_flaky,
          SUM(all_failed - tae_failed) AS legacy_failed
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
        days_in_window,
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
        days_in_window,
        window_start,
        window_end
      FROM totals
    ;;
  }

  # ---------- Dimensions ----------

  dimension: suite {
    type: string
    sql: ${TABLE}.suite ;;
    primary_key: yes
    label: "Suite"
    description: "TAE = efficiency package. Legacy = all other tests, derived by subtracting efficiency totals from the all-tests daily table."
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

  dimension: days_in_window {
    type: number
    sql: ${TABLE}.days_in_window ;;
    label: "Days in Window"
    description: "Distinct dates with data in the last 90 days. Should be ~91."
  }

  dimension: window_start {
    type: date
    datatype: date
    sql: ${TABLE}.window_start ;;
    label: "Window Start"
  }

  dimension: window_end {
    type: date
    datatype: date
    sql: ${TABLE}.window_end ;;
    label: "Window End"
  }

  # ---------- Measures ----------
  # Passthrough max() aggregates: one row per suite, so max returns that row's
  # value. Required because Looker bar charts plot measures, not dimensions.

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
