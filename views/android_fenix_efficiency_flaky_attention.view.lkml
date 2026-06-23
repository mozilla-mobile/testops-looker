view: android_fenix_efficiency_flaky_attention {
  derived_table: {
    sql:
      SELECT
        test_name,
        class_name,
        total_runs,
        flaky_runs,
        ROUND(SAFE_DIVIDE(flaky_runs, total_runs) * 100, 2) AS flaky_pct,
        last_flaky_date,
        DATE_DIFF(CURRENT_DATE(), last_flaky_date, DAY) AS days_since_flaky,
        DATE_DIFF(CURRENT_DATE(), first_seen_date, DAY) AS test_age_days,
        ROUND(SAFE_DIVIDE(flaky_runs, DATE_DIFF(CURRENT_DATE(), first_seen_date, DAY)), 2) AS flakes_per_day,
        CASE
          WHEN last_flaky_date >= DATE_SUB(CURRENT_DATE(), INTERVAL 7 DAY)
            AND SAFE_DIVIDE(flaky_runs, total_runs) > 0.01 THEN 'Needs Attention'
          WHEN last_flaky_date >= DATE_SUB(CURRENT_DATE(), INTERVAL 7 DAY) THEN 'Watch'
          WHEN last_flaky_date >= DATE_SUB(CURRENT_DATE(), INTERVAL 14 DAY) THEN 'Cooling'
          WHEN flaky_runs > 0 THEN 'Stale'
          ELSE 'Clean'
        END AS flaky_status
      FROM `moz-mobile-tools.testops_results.fenix_ui_tests`
      WHERE class_name LIKE '%efficiency%'
        AND flaky_runs > 0
        AND last_updated >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 14 DAY)
    ;;
  }

  dimension: test_name {
    type: string
    sql: ${TABLE}.test_name ;;
  }

  dimension: class_name {
    type: string
    sql: ${TABLE}.class_name ;;
  }

  dimension: total_runs {
    type: number
    sql: ${TABLE}.total_runs ;;
  }

  dimension: flaky_runs {
    type: number
    sql: ${TABLE}.flaky_runs ;;
  }

  dimension: flaky_pct {
    type: number
    sql: ${TABLE}.flaky_pct ;;
    value_format: "0.00\%"
    label: "Flaky %"
  }

  dimension: last_flaky_date {
    type: date
    datatype: date
    sql: ${TABLE}.last_flaky_date ;;
  }

  dimension: days_since_flaky {
    type: number
    sql: ${TABLE}.days_since_flaky ;;
  }

  dimension: test_age_days {
    type: number
    sql: ${TABLE}.test_age_days ;;
  }

  dimension: flakes_per_day {
    type: number
    sql: ${TABLE}.flakes_per_day ;;
    value_format: "0.00"
  }

  dimension: flaky_status {
    type: string
    sql: ${TABLE}.flaky_status ;;
    label: "Flaky Status"
  }

  measure: count {
    type: count
    description: "Number of flaky tests"
  }

  measure: needs_attention_count {
    type: count
    filters: [flaky_status: "Needs Attention"]
    label: "Needs Attention"
  }

  measure: watch_count {
    type: count
    filters: [flaky_status: "Watch"]
    label: "Watch"
  }

  measure: cooling_count {
    type: count
    filters: [flaky_status: "Cooling"]
    label: "Cooling"
  }

  measure: stale_count {
    type: count
    filters: [flaky_status: "Stale"]
    label: "Stale"
  }
}
