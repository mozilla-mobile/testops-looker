view: android_ios_coverage_trend {
  derived_table: {
    sql:
      WITH ranked AS (
        SELECT
          created_at,
          DATE_TRUNC(DATE(created_at), WEEK(MONDAY)) AS coverage_week,
          project_name_abbrev,
          test_sub_suite_abbrev,
          status,
          test_count_sum,
          DENSE_RANK() OVER (
            PARTITION BY DATE_TRUNC(DATE(created_at), WEEK(MONDAY))
            ORDER BY DATE(created_at) DESC
          ) AS day_rank
        FROM `moz-mobile-tools.testops_dashboard.report_test_coverage_by_project_prod`
        WHERE project_name_abbrev IN ('fenix', 'firefox-ios')
          AND test_sub_suite_abbrev IN ('functional', 'smoke')
          AND DATE(created_at) >= '2026-01-01'
      ),
      weekly AS (
        SELECT
          coverage_week,
          CASE
            WHEN project_name_abbrev = 'fenix' AND test_sub_suite_abbrev = 'functional' THEN 'Android Full Functional'
            WHEN project_name_abbrev = 'fenix' AND test_sub_suite_abbrev = 'smoke' THEN 'Android Smoke Test'
            WHEN project_name_abbrev = 'firefox-ios' AND test_sub_suite_abbrev = 'functional' THEN 'iOS Full Functional'
            WHEN project_name_abbrev = 'firefox-ios' AND test_sub_suite_abbrev = 'smoke' THEN 'iOS Smoke Test'
          END AS category,
          SUM(CASE WHEN status = 'Completed' THEN test_count_sum ELSE 0 END) AS automated,
          SUM(CASE WHEN status IN ('Completed', 'Suitable', 'Untriaged') THEN test_count_sum ELSE 0 END) AS addressable
        FROM ranked
        WHERE day_rank = 1
        GROUP BY coverage_week, category
      )
      SELECT
        FORMAT_DATE('%Y-%m-%d', coverage_week) AS coverage_week,
        category,
        automated,
        addressable,
        ROUND(SAFE_DIVIDE(automated, addressable) * 100, 1) AS coverage_pct
      FROM weekly
      WHERE category IS NOT NULL
    ;;
  }

  dimension: coverage_week {
    type: string
    sql: ${TABLE}.coverage_week ;;
  }

  dimension: category {
    type: string
    sql: ${TABLE}.category ;;
  }

  dimension: automated {
    type: number
    sql: ${TABLE}.automated ;;
  }

  dimension: addressable {
    type: number
    sql: ${TABLE}.addressable ;;
  }

  dimension: coverage_pct {
    type: number
    sql: ${TABLE}.coverage_pct ;;
    value_format: "0.0\%"
  }

  measure: avg_coverage_pct {
    type: average
    sql: ${coverage_pct} ;;
    value_format: "0.0\%"
    description: "Average automation coverage percentage"
  }

  measure: total_automated {
    type: sum
    sql: ${automated} ;;
    description: "Number of automated (Completed) test cases"
  }
}
