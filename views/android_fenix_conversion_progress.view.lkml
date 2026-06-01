view: android_fenix_conversion_progress {
  derived_table: {
    sql:
      WITH latest AS (
        SELECT converted_count, smoke_test_count
        FROM `moz-mobile-tools.testops_results.conversion_tracking`
        ORDER BY date DESC
        LIMIT 1
      )
      SELECT 'Converted' AS status, converted_count AS test_count FROM latest
      UNION ALL
      SELECT 'Not Yet Converted' AS status, smoke_test_count - converted_count AS test_count FROM latest
    ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  measure: count {
    type: sum
    sql: ${TABLE}.test_count ;;
  }
}
