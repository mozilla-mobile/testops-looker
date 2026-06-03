view: android_ios_automation_coverage {
  derived_table: {
    sql:
      WITH latest_snapshot AS (
        SELECT MAX(DATE(created_at)) AS snapshot_date
        FROM `moz-mobile-tools.testops_dashboard.report_test_coverage_by_project_prod`
      ),
      filtered AS (
        SELECT
          project_name_abbrev,
          test_sub_suite_abbrev,
          status,
          test_count_sum
        FROM `moz-mobile-tools.testops_dashboard.report_test_coverage_by_project_prod`, latest_snapshot
        WHERE DATE(created_at) = latest_snapshot.snapshot_date
          AND project_name_abbrev IN ('fenix', 'firefox-ios')
          AND test_sub_suite_abbrev IN ('functional', 'smoke')
          AND status IN ('Completed', 'Suitable', 'Untriaged')
      )
      SELECT
        CASE
          WHEN project_name_abbrev = 'fenix' AND test_sub_suite_abbrev = 'functional' THEN 'Android Full Functional'
          WHEN project_name_abbrev = 'fenix' AND test_sub_suite_abbrev = 'smoke' THEN 'Android Smoke Test'
          WHEN project_name_abbrev = 'firefox-ios' AND test_sub_suite_abbrev = 'functional' THEN 'iOS Full Functional'
          WHEN project_name_abbrev = 'firefox-ios' AND test_sub_suite_abbrev = 'smoke' THEN 'iOS Smoke Test'
        END AS category,
        SUM(CASE WHEN status = 'Completed' THEN test_count_sum ELSE 0 END) AS automated,
        SUM(CASE WHEN status IN ('Suitable', 'Untriaged') THEN test_count_sum ELSE 0 END) AS not_automated,
        SUM(test_count_sum) AS total_cases
      FROM filtered
      GROUP BY category
    ;;
  }

  dimension: category {
    type: string
    sql: ${TABLE}.category ;;
    primary_key: yes
  }

  dimension: automated {
    type: number
    sql: ${TABLE}.automated ;;
  }

  dimension: not_automated {
    type: number
    sql: ${TABLE}.not_automated ;;
  }

  dimension: total_cases {
    type: number
    sql: ${TABLE}.total_cases ;;
  }

  dimension: automated_pct {
    type: number
    sql: ROUND(SAFE_DIVIDE(${TABLE}.automated, ${TABLE}.total_cases) * 100, 1) ;;
    value_format: "0.0\%"
  }

  measure: total_automated {
    type: sum
    sql: ${automated} ;;
    label: "Automated"
  }

  measure: total_not_automated {
    type: sum
    sql: ${not_automated} ;;
    label: "Not Automated"
  }

  measure: total_n {
    type: sum
    sql: ${total_cases} ;;
    label: "Total Cases (n)"
  }
}
