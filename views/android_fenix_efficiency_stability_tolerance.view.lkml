view: android_fenix_efficiency_stability_tolerance {
  derived_table: {
    sql:
      WITH daily AS (
        SELECT
          date,
          total_runs,
          (flaky_rate <= 0.005) AS flaky_clean,
          (failure_rate <= 0.005) AS failure_clean,
          (flaky_rate <= 0.005 AND failure_rate <= 0.005) AS is_clean
        FROM `moz-mobile-tools.testops_results.fenix_efficiency_daily_totals`
        WHERE date <= CURRENT_DATE()
      )
      SELECT
        MIN(date) AS history_start,
        COUNT(*) AS days_with_runs,
        COUNTIF(is_clean) AS clean_days,
        COUNTIF(NOT is_clean) AS breach_days,
        COUNTIF(NOT flaky_clean) AS flaky_breach_days,
        COUNTIF(NOT failure_clean) AS failure_breach_days,
        ROUND(SAFE_DIVIDE(COUNTIF(is_clean), COUNT(*)) * 100, 1) AS clean_day_pct,
        ROUND(SAFE_DIVIDE(COUNTIF(flaky_clean), COUNT(*)) * 100, 1) AS flaky_clean_pct,
        ROUND(SAFE_DIVIDE(COUNTIF(failure_clean), COUNT(*)) * 100, 1) AS failure_clean_pct
      FROM daily
    ;;
  }

  dimension: history_start {
    type: date
    datatype: date
    sql: ${TABLE}.history_start ;;
    label: "Tracking Since"
  }

  dimension: days_with_runs {
    type: number
    sql: ${TABLE}.days_with_runs ;;
    label: "Days With Runs"
  }

  dimension: clean_days {
    type: number
    sql: ${TABLE}.clean_days ;;
  }

  dimension: breach_days {
    type: number
    sql: ${TABLE}.breach_days ;;
  }

  dimension: flaky_breach_days {
    type: number
    sql: ${TABLE}.flaky_breach_days ;;
    label: "Flaky Breach Days"
  }

  dimension: failure_breach_days {
    type: number
    sql: ${TABLE}.failure_breach_days ;;
    label: "Failure Breach Days"
  }

  dimension: clean_day_pct {
    type: number
    sql: ${TABLE}.clean_day_pct ;;
    value_format: "0.0\%"
    label: "Clean Day Rate"
  }

  dimension: flaky_clean_pct {
    type: number
    sql: ${TABLE}.flaky_clean_pct ;;
    value_format: "0.0\%"
    label: "Flaky Clean Rate"
  }

  dimension: failure_clean_pct {
    type: number
    sql: ${TABLE}.failure_clean_pct ;;
    value_format: "0.0\%"
    label: "Failure Clean Rate"
  }

  measure: max_clean_day_pct {
    type: max
    sql: ${clean_day_pct} ;;
    value_format: "0.0\%"
    label: "Clean Day Rate"
  }
}
