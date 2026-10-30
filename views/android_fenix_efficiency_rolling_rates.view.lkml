view: android_fenix_efficiency_rolling_rates {
  derived_table: {
    sql:
      WITH d AS (
        SELECT 'TAE' AS suite, date, total_runs, failed_runs, flaky_runs
        FROM `moz-mobile-tools.testops_results.fenix_efficiency_daily_totals`
        WHERE date >= DATE_SUB(CURRENT_DATE(), INTERVAL 30 DAY)
        QUALIFY ROW_NUMBER() OVER (PARTITION BY date ORDER BY total_runs DESC) = 1
        UNION ALL
        SELECT 'Legacy', date, total_runs, failed_runs, flaky_runs
        FROM `moz-mobile-tools.testops_results.fenix_daily_totals`
        WHERE date >= DATE_SUB(CURRENT_DATE(), INTERVAL 30 DAY)
        QUALIFY ROW_NUMBER() OVER (PARTITION BY date ORDER BY total_runs DESC) = 1
      ),
      w AS (
        SELECT '7 days' AS window_label, 1 AS sort_order, * FROM d
        WHERE date >= DATE_SUB(CURRENT_DATE(), INTERVAL 7 DAY)
        UNION ALL
        SELECT '30 days', 2, * FROM d
      )
      SELECT
        CONCAT(suite, ' ', window_label) AS row_key,
        suite,
        window_label,
        sort_order,
        SUM(total_runs) AS runs,
        SUM(failed_runs) AS failed_runs,
        SUM(flaky_runs) AS flaky_runs,
        SAFE_DIVIDE(SUM(failed_runs), SUM(total_runs)) * 100 AS failure_pct,
        SAFE_DIVIDE(SUM(flaky_runs), SUM(total_runs)) * 100 AS flaky_pct
      FROM w
      GROUP BY suite, window_label, sort_order
    ;;
  }

  dimension: row_key {
    type: string
    primary_key: yes
    hidden: yes
    sql: ${TABLE}.row_key ;;
  }

  dimension: suite {
    type: string
    sql: ${TABLE}.suite ;;
    label: "Suite"
  }

  dimension: window_label {
    type: string
    sql: ${TABLE}.window_label ;;
    order_by_field: sort_order
    label: "Window"
  }

  dimension: sort_order {
    type: number
    hidden: yes
    sql: ${TABLE}.sort_order ;;
  }

  measure: runs {
    type: sum
    sql: ${TABLE}.runs ;;
    label: "Runs"
  }

  measure: failed_runs {
    type: sum
    sql: ${TABLE}.failed_runs ;;
    label: "Failed Runs"
  }

  measure: flaky_runs {
    type: sum
    sql: ${TABLE}.flaky_runs ;;
    label: "Flaky Runs"
  }

  measure: failure_pct {
    type: average
    sql: ${TABLE}.failure_pct ;;
    value_format: "0.00\%"
    label: "Failure %"
  }

  measure: flaky_pct {
    type: average
    sql: ${TABLE}.flaky_pct ;;
    value_format: "0.00\%"
    label: "Flaky %"
  }
}
