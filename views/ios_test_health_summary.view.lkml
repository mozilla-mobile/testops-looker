view: ios_test_health_summary {
  derived_table: {
    sql:
      SELECT
        results.branch AS branch,
        result.device AS device,
        DATE(timestamp) AS report_date,
        -- agregamos joins virtuales
        AVG(CASE WHEN result = 'failed' THEN 1 ELSE 0 END) AS monthly_failure_rate,
        -- suponiendo que puedes traer el flaky rate y change desde la otra tabla (join previo)
        ANY_VALUE(flakiness.current_flaky_rate) AS current_flaky_rate,
        ANY_VALUE(flakiness.total_tests_percentage_change) AS total_tests_percentage_change
      FROM moz-mobile-tools.testops_stats.fennec_test_results_ios AS results
      LEFT JOIN moz-mobile-tools.testops_stats.ios_flaky_tests_daily AS flakiness
        ON results.branch = flakiness.branch
        AND results.device = flakiness.device
        AND DATE(results.timestamp) = flakiness.report_date
      WHERE EXTRACT(MONTH FROM results.timestamp) = EXTRACT(MONTH FROM CURRENT_DATE())
      GROUP BY 1, 2, 3
    ;;
  }

  dimension: branch {
    type: string
    sql: ${TABLE}.branch ;;
  }

  dimension: device {
    type: string
    sql: ${TABLE}.device ;;
  }

  dimension: report_date {
    type: date
    sql: ${TABLE}.report_date ;;
  }

  measure: test_health_index {
    type: number
    description: "iOS test health score: -1 = unstable, 0 = monitor, 1 = stable"
    sql:
      CASE
        WHEN ${current_flaky_rate} >= 0.02
          OR ${monthly_failure_rate} >= 0.02
          OR (EXTRACT(DAY FROM CURRENT_DATE()) >= 21 AND ${total_tests_percentage_change} < -0.5)
        THEN -1
        WHEN ${current_flaky_rate} BETWEEN 0.01 AND 0.02
          OR ${monthly_failure_rate} BETWEEN 0.01 AND 0.02
        THEN 0
        ELSE 1
      END ;;
    group_label: "Summary KPIs"
    value_format: "#"
  }

  measure: current_flaky_rate {
    type: number
    sql: ${TABLE}.current_flaky_rate ;;
  }

  measure: monthly_failure_rate {
    type: number
    sql: ${TABLE}.monthly_failure_rate ;;
  }

  measure: total_tests_percentage_change {
    type: number
    sql: ${TABLE}.total_tests_percentage_change ;;
    value_format_name: percent_2
  }
}
