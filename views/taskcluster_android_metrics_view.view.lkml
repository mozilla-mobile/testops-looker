view: taskcluster_android_metrics_view {
  derived_table: {
    sql:
      WITH data AS (
        SELECT
          t.value AS label,
          SUM(IF(result = 'completed', 1, 0)) AS completed,
          SUM(IF(result = 'failed', 1, 0)) AS failed,
          SUM(IF(result = 'canceled', 1, 0)) AS canceled,
          SUM(IF(result = 'deadline-exceeded', 1, 0)) AS deadline,
          COUNT(*) AS count,
          APPROX_QUANTILES(lag, 100)[OFFSET(50)] AS lag_p50,
          APPROX_QUANTILES(lag, 100)[OFFSET(75)] AS lag_p75,
          APPROX_QUANTILES(lag, 100)[OFFSET(99)] AS lag_p99,
          APPROX_QUANTILES(execution, 100)[OFFSET(50)] AS execution_p50,
          APPROX_QUANTILES(execution, 100)[OFFSET(75)] AS execution_p75,
          APPROX_QUANTILES(execution, 100)[OFFSET(99)] AS execution_p99
        FROM
          `moz-fx-data-shared-prod.taskclusteretl.task_definition` A
          INNER JOIN `moz-fx-data-shared-prod.taskclusteretl.derived_task_summary` B
            ON A.taskId = B.taskId,
          UNNEST(tags) AS t
        WHERE
          t.key = "label"
          AND REGEXP_CONTAINS(t.value, r"ui-test-apk|android-startup-test")
          AND A.created > TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 30 DAY)
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
    type: number
    sql: ${TABLE}.completed ;;
  }

  measure: complete_ratio {
    type: average
    sql: ${TABLE}.complete_ratio ;;
    value_format_name: percent_2
  }

  measure: failed {
    type: number
    sql: ${TABLE}.failed ;;
  }

  measure: failed_ratio {
    type: average
    sql: ${TABLE}.failed_ratio ;;
    value_format_name: percent_2
  }

  measure: deadline {
    type: number
    sql: ${TABLE}.deadline ;;
  }

  measure: lag_p50 { type: average sql: ${TABLE}.lag_p50 ;; }
  measure: lag_p75 { type: average sql: ${TABLE}.lag_p75 ;; }
  measure: lag_p99 { type: average sql: ${TABLE}.lag_p99 ;; }

  measure: execution_p50 { type: average sql: ${TABLE}.execution_p50 ;; }
  measure: execution_p75 { type: average sql: ${TABLE}.execution_p75 ;; }
  measure: execution_p99 { type: average sql: ${TABLE}.execution_p99 ;; }
}
