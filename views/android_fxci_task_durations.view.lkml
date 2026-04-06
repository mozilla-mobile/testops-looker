view: android_fxci_task_durations {
  derived_table: {
    sql: SELECT
        DATE(t.submission_date) AS date,
        t.task_id AS taskId,
        t.tags.label AS symbol,
        TIMESTAMP_DIFF(r.resolved, r.started, MINUTE) AS duration_in_minutes,
        TIMESTAMP_DIFF(r.resolved, r.started, SECOND) AS duration_in_seconds,
        CONCAT('https://firefox-ci-tc.services.mozilla.com/tasks/', t.task_id) AS task_link
      FROM
        `moz-fx-data-shared-prod.fxci.tasks` t
      JOIN
        `moz-fx-data-shared-prod.fxci_derived.task_runs_v1` r
      ON
        t.task_id = r.task_id
      WHERE
        r.state = "completed"
        AND t.tags.kind IN ('ui-test-apk')
        AND t.tags.project IN ('autoland')
        AND t.submission_date >= DATE_SUB(CURRENT_DATE(), INTERVAL 90 DAY)
        AND r.submission_date >= DATE_SUB(CURRENT_DATE(), INTERVAL 90 DAY) ;;
  }
  measure: count {
    type: count
    drill_fields: [detail*]
  }
  measure: avg_duration_minutes {
    type: average
    sql: ${duration_in_minutes} ;;
    value_format: "0.0"
    description: "Average task wall-clock duration in minutes"
  }
  measure: median_duration_minutes {
    type: median
    sql: ${duration_in_minutes} ;;
    value_format: "0.0"
    description: "Median (p50) task wall-clock duration in minutes"
  }
  measure: max_duration_minutes {
    type: max
    sql: ${duration_in_minutes} ;;
    value_format: "0.0"
    description: "Longest task wall-clock duration in minutes"
  }
  measure: min_duration_minutes {
    type: min
    sql: ${duration_in_minutes} ;;
    value_format: "0.0"
    description: "Shortest task wall-clock duration in minutes"
  }
  dimension: date {
    type: date
    datatype: date
    sql: ${TABLE}.date ;;
  }
  dimension: task_id {
    type: string
    primary_key: yes
    sql: ${TABLE}.taskId ;;
  }
  dimension: symbol {
    type: string
    sql: ${TABLE}.symbol ;;
  }
  dimension: duration_in_minutes {
    type: number
    sql: ${TABLE}.duration_in_minutes ;;
  }
  dimension: duration_in_seconds {
    type: number
    sql: ${TABLE}.duration_in_seconds ;;
    hidden: yes
  }
  dimension: task_link {
    type: string
    sql: ${TABLE}.task_link ;;
  }
  set: detail {
    fields: [
      date,
      task_id,
      symbol,
      duration_in_minutes,
      task_link
    ]
  }
}
