view: android_job_durations {
  derived_table: {
    sql:
    WITH tasks_with_duration AS (
      SELECT
        date,
        taskId,
        symbol,
        TIMESTAMP_DIFF(resolved, started, MINUTE) AS duration_in_minutes
      FROM `moz-fx-data-shared-prod.taskclusteretl.derived_task_summary`
      WHERE result = "completed"
      AND kind IN ( {% parameter kind %} )
      AND date >= DATE_SUB(CURRENT_DATE(), INTERVAL 7 DAY)
      AND project IN ( {% parameter project %} )
    )

      SELECT DISTINCT
      date,
      taskId,
      symbol,
      duration_in_minutes
      FROM tasks_with_duration
      WHERE duration_in_minutes > 10
      ORDER BY duration_in_minutes DESC
      ;;
  }

  parameter: project {
    type: string
    label: "Project"
    default_value: "autoland"
    allowed_value: { value: "autoland" label: "Autoland" }
    allowed_value: { value: "mozilla-central" label: "Mozilla Central" }
    allowed_value: { value: "mozilla-beta" label: "Mozilla Beta" }
    allowed_value: { value: "mozilla-release" label: "Mozilla Release" }
  }

  parameter: kind {
    type: string
    label: "Task Kind"
    default_value: "ui-test-apk"
    allowed_value: { value: "ui-test-apk" label: "UI Test APK" }
    allowed_value: { value: "build-apk" label: "Build APK" }
  }

  dimension: date {
    type: date
    sql: ${TABLE}.date ;;
  }

  dimension: taskId {
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

  dimension: task_link {
    type: string
    label: "Task Link"
    description: "Clickable link to the Task in TaskCluster"
    sql: CONCAT('https://firefox-ci-tc.services.mozilla.com/tasks/', ${taskId}) ;;
    link: {
      label: "View Task"
      url: "https://firefox-ci-tc.services.mozilla.com/tasks/{{taskId}}"
    }
  }

  measure: count {
    type: count
    description: "Number of Completed Tasks"
  }
}
