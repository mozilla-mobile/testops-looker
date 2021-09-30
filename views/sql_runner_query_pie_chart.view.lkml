view: sql_runner_query_pie_chart {
  derived_table: {
    sql: SELECT
          sum(report_test_coverage_show_status.test_count_sum)  AS report_test_coverage_show_status_test_count_sum,
          report_test_coverage_show_status.status  AS report_test_coverage_show_status_status
      FROM `moz-mobile-tools.testops_dashboard.report_test_coverage_show_status`
           AS report_test_coverage_show_status
      GROUP BY
          report_test_coverage_show_status.status
      ORDER BY
          1
      LIMIT 500
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: report_test_coverage_show_status_test_count_sum {
    type: number
    sql: ${TABLE}.report_test_coverage_show_status_test_count_sum ;;
  }

  dimension: report_test_coverage_show_status_status {
    type: string
    sql: ${TABLE}.report_test_coverage_show_status_status ;;
  }

  set: detail {
    fields: [report_test_coverage_show_status_test_count_sum, report_test_coverage_show_status_status]
  }
}
