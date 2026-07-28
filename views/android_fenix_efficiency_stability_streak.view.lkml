view: android_fenix_efficiency_stability_streak {
  derived_table: {
    sql:
      WITH daily AS (
        SELECT
          date,
          total_runs,
          flaky_runs,
          failed_runs,
          flaky_rate,
          failure_rate,
          (flaky_rate <= 0.005 AND failure_rate <= 0.005) AS is_clean
        FROM `moz-mobile-tools.testops_results.fenix_efficiency_daily_totals`
        WHERE date <= CURRENT_DATE()
      ),
      last_breach AS (
        SELECT MAX(date) AS breach_date
        FROM daily
        WHERE NOT is_clean
      ),
      streak AS (
        SELECT d.*
        FROM daily d, last_breach b
        WHERE d.date > b.breach_date
      )
      SELECT
        (SELECT breach_date FROM last_breach) AS last_breach_date,
        DATE_DIFF(CURRENT_DATE(), (SELECT breach_date FROM last_breach), DAY) AS clean_streak_days,
        MIN(date) AS streak_start,
        COUNT(*) AS days_with_runs,
        SUM(total_runs) AS streak_total_runs,
        SUM(flaky_runs) AS streak_flaky_runs,
        SUM(failed_runs) AS streak_failed_runs,
        ROUND(MAX(flaky_rate) * 100, 3) AS peak_daily_flaky_pct,
        ROUND(SAFE_DIVIDE(SUM(flaky_runs), SUM(total_runs)) * 100, 3) AS streak_flaky_pct,
        ROUND(SAFE_DIVIDE(SUM(failed_runs), SUM(total_runs)) * 100, 3) AS streak_failure_pct
      FROM streak
    ;;
  }

  dimension: clean_streak_days {
    type: number
    sql: ${TABLE}.clean_streak_days ;;
    label: "Clean Streak (Days)"
  }

  dimension: last_breach_date {
    type: date
    datatype: date
    sql: ${TABLE}.last_breach_date ;;
    label: "Last Threshold Breach"
  }

  dimension: streak_start {
    type: date
    datatype: date
    sql: ${TABLE}.streak_start ;;
  }

  dimension: days_with_runs {
    type: number
    sql: ${TABLE}.days_with_runs ;;
  }

  dimension: streak_total_runs {
    type: number
    sql: ${TABLE}.streak_total_runs ;;
    label: "Total Runs in Streak"
  }

  dimension: peak_daily_flaky_pct {
    type: number
    sql: ${TABLE}.peak_daily_flaky_pct ;;
    value_format: "0.000\%"
    label: "Peak Daily Flaky %"
  }

  dimension: streak_flaky_pct {
    type: number
    sql: ${TABLE}.streak_flaky_pct ;;
    value_format: "0.000\%"
    label: "Streak Flaky %"
  }

  dimension: streak_failure_pct {
    type: number
    sql: ${TABLE}.streak_failure_pct ;;
    value_format: "0.000\%"
    label: "Streak Failure %"
  }

  measure: max_streak_days {
    type: max
    sql: ${clean_streak_days} ;;
    label: "Clean Streak (Days)"
  }
}
