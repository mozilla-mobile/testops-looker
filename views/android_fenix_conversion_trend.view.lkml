view: android_fenix_conversion_trend {
  derived_table: {
    sql:
      WITH ranked AS (
        SELECT
          date,
          DATE_TRUNC(date, WEEK(MONDAY)) AS conversion_week,
          converted_count,
          smoke_test_count,
          DENSE_RANK() OVER (
            PARTITION BY DATE_TRUNC(date, WEEK(MONDAY))
            ORDER BY date DESC
          ) AS day_rank
        FROM `moz-mobile-tools.testops_results.conversion_tracking`
      )
      SELECT
        FORMAT_DATE('%Y-%m-%d', conversion_week) AS conversion_week,
        converted_count,
        smoke_test_count,
        ROUND(SAFE_DIVIDE(converted_count, smoke_test_count) * 100, 1) AS conversion_pct
      FROM ranked
      WHERE day_rank = 1
    ;;
  }

  dimension: conversion_week {
    type: string
    sql: ${TABLE}.conversion_week ;;
  }

  dimension: converted_count {
    type: number
    sql: ${TABLE}.converted_count ;;
  }

  dimension: smoke_test_count {
    type: number
    sql: ${TABLE}.smoke_test_count ;;
  }

  dimension: conversion_pct {
    type: number
    sql: ${TABLE}.conversion_pct ;;
    value_format: "0.0\%"
  }

  measure: latest_conversion_pct {
    type: max
    sql: ${conversion_pct} ;;
    value_format: "0.0\%"
    description: "Conversion percentage of smoke tests"
  }

  measure: latest_converted_count {
    type: max
    sql: ${converted_count} ;;
    description: "Number of converted smoke tests"
  }
}
