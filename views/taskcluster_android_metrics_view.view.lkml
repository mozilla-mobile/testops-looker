view: taskcluster_android_metrics_view {
  derived_table: {
    sql:
      WITH data AS (
        SELECT
          t.tags.label AS label,
          SUM(IF(r.state = 'completed', 1, 0)) AS completed,
          SUM(IF(r.state = 'failed', 1, 0)) AS failed,
          SUM(IF(r.state = 'canceled', 1, 0)) AS canceled,
          SUM(IF(r.state = 'deadline-exceeded', 1, 0)) AS deadline,
          COUNT(*) AS count,
          APPROX_QUANTILES(TIMESTAMP_DIFF(r.started, r.scheduled, SECOND), 100)[OFFSET(50)] AS lag_p50,
          APPROX_QUANTILES(TIMESTAMP_DIFF(r.started, r.scheduled, SECOND), 100)[OFFSET(75)] AS lag_p75,
          APPROX_QUANTILES(TIMESTAMP_DIFF(r.started, r.scheduled, SECOND), 100)[OFFSET(99)] AS lag_p99,
          APPROX_QUANTILES(TIMESTAMP_DIFF(r.resolved, r.started, SECOND), 100)[OFFSET(50)] AS execution_p50,
          APPROX_QUANTILES(TIMESTAMP_DIFF(r.resolved, r.started, SECOND), 100)[OFFSET(75)] AS execution_p75,
          APPROX_QUANTILES(TIMESTAMP_DIFF(r.resolved, r.started, SECOND), 100)[OFFSET(99)] AS execution_p99
        FROM
          `moz-fx-data-shared-prod.fxci.tasks` t
        JOIN
          `moz-fx-data-shared-prod.fxci_derived.task_runs_v1` r
        ON
          t.task_id = r.task_id
        WHERE
          t.tags.label IS NOT NULL
          AND REGEXP_CONTAINS(t.tags.label, r"ui-test-apk|android-startup-test|test-apk")
          AND t.submission_date >= DATE_SUB(CURRENT_DATE(), INTERVAL 30 DAY)
          AND r.submission_date >= DATE_SUB(CURRENT_DATE(), INTERVAL 30 DAY)
        GROUP BY label
      )
      SELECT
        label,
        count,
        completed,
        SAFE_DIVIDE(completed, count) AS complete_ratio,
        failed,
        SAFE_DIVIDE(failed, count) AS failed_ratio,
        deadline,
        lag_p50, lag_p75, lag_p99,
        execution_p50, execution_p75, execution_p99
      FROM data
      ORDER BY count DESC
    ;;
  }

  dimension: label {
    type: string
    sql: ${TABLE}.label ;;
  }

  measure: count {
    type: sum
    sql: ${TABLE}.count ;;
  }

  measure: completed {
    type: sum
    sql: ${TABLE}.completed ;;
  }

  measure: complete_ratio {
    type: average
    sql: ${TABLE}.complete_ratio ;;
    value_format_name: percent_2
  }

  measure: failed {
    type: sum
    sql: ${TABLE}.failed ;;
  }

  measure: failed_ratio {
    type: average
    sql: ${TABLE}.failed_ratio ;;
    value_format_name: percent_2
  }

  measure: deadline {
    type: sum
    sql: ${TABLE}.deadline ;;
  }

  measure: lag_p50 { type: average sql: ${TABLE}.lag_p50 ;; }
  measure: lag_p75 { type: average sql: ${TABLE}.lag_p75 ;; }
  measure: lag_p99 { type: average sql: ${TABLE}.lag_p99 ;; }

  measure: execution_p50 { type: average sql: ${TABLE}.execution_p50 ;; }
  measure: execution_p75 { type: average sql: ${TABLE}.execution_p75 ;; }
  measure: execution_p99 { type: average sql: ${TABLE}.execution_p99 ;; }
}
