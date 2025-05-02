
view: android_fxci_task_durations {
  derived_table: {
    sql: WITH tasks_with_duration AS (
        SELECT
          DATE(t.submission_date) AS date,
          t.task_id AS taskId,
          t.tags.label AS symbol,  -- Substituting label for symbol
          TIMESTAMP_DIFF(r.resolved, r.started, MINUTE) AS duration_in_minutes
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
          AND t.submission_date >= DATE_SUB(CURRENT_DATE(), INTERVAL 7 DAY)
          AND r.submission_date >= DATE_SUB(CURRENT_DATE(), INTERVAL 7 DAY)
      )
      
      SELECT DISTINCT
        date,
        taskId,
        symbol,
        duration_in_minutes,
        CONCAT('https://firefox-ci-tc.services.mozilla.com/tasks/', taskId) AS task_link
      FROM
        tasks_with_duration
      WHERE
        duration_in_minutes > 20
      ORDER BY
        duration_in_minutes DESC
      LIMIT 25 ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: date {
    type: date
    datatype: date
    sql: ${TABLE}.date ;;
  }

  dimension: task_id {
    type: string
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
