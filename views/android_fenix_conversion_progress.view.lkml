view: android_fenix_conversion_progress {
  derived_table: {
    sql:
      SELECT
        'Converted' AS status,
        IFNULL(c.converted_count, 0) AS test_count
      FROM (
        SELECT converted_count
        FROM `moz-mobile-tools.testops_results.conversion_tracking`
        ORDER BY date DESC
        LIMIT 1
      ) c
      UNION ALL
      SELECT
        'Not Yet Converted' AS status,
        COUNT(*) - IFNULL((
          SELECT converted_count
          FROM `moz-mobile-tools.testops_results.conversion_tracking`
          ORDER BY date DESC
          LIMIT 1
        ), 0) AS test_count
      FROM `moz-mobile-tools.testops_results.fenix_ui_tests`
      WHERE class_name NOT LIKE '%efficiency%'
        AND class_name NOT LIKE '%benchmark%'
        AND last_updated >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 7 DAY)
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
