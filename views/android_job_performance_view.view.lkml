view: android_job_performance_view {
  derived_table: {
    datagroup_trigger: job_performance_refresh
    sql:
    WITH job_data AS (
      SELECT
        DATE_TRUNC(job.start_time, DAY) AS job_date,
        job_type.name AS job_name,
        repository.name AS repository_name,
        TIMESTAMP_DIFF(job.start_time, job.submit_time, SECOND) AS queued_seconds,
        TIMESTAMP_DIFF(job.end_time, job.start_time, SECOND) AS run_seconds
      FROM `moz-fx-data-shared-prod.treeherder_db.job` AS job
      JOIN `moz-fx-data-shared-prod.treeherder_db.repository` AS repository
        ON job.repository_id = repository.id
      JOIN `moz-fx-data-shared-prod.treeherder_db.job_type` AS job_type
        ON job.job_type_id = job_type.id
      WHERE job.result = 'success'
        AND job.start_time >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL CAST({% parameter time_interval %} AS INT64) DAY)
        AND repository.name = {% parameter repository_name %}
        AND job_type.name = {% parameter job_name %}
    )
    SELECT
      job_date,
      job_name,
      repository_name,
      AVG(queued_seconds) AS avg_queued_seconds,
      AVG(run_seconds) AS avg_run_seconds,
      -- Compute rolling averages within SQL
      AVG(queued_seconds) OVER (
        PARTITION BY repository_name, job_name
        ORDER BY job_date
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
      ) / 60 AS rolling_avg_queue_time,
      AVG(run_seconds) OVER (
        PARTITION BY repository_name, job_name
        ORDER BY job_date
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
      ) / 60 AS rolling_avg_run_time
    FROM job_data
    GROUP BY job_date, job_name, repository_name
    ;;
  }

  parameter: time_interval {
    type: string
    label: "Time Interval"
    default_value: "30"

    allowed_value: { label: "Past 7 Days" value: "7" }
    allowed_value: { label: "Past 30 Days" value: "30" }
    allowed_value: { label: "Past 90 Days" value: "90" }
  }

  parameter: repository_name {
    type: string
    label: "Repository Name"
    default_value: "mozilla-central"

    allowed_value: { label: "Autoland" value: "autoland" }
    allowed_value: { label: "Mozilla Central" value: "mozilla-central" }
    allowed_value: { label: "Mozilla Beta" value: "mozilla-beta" }
  }

  parameter: job_name {
    type: string
    label: "Job Name"
    default_value: "ui-test-apk-fenix-arm-debug"

    allowed_value: { label: "Fenix Debug UI Test" value: "ui-test-apk-fenix-arm-debug" }
    allowed_value: { label: "Focus Debug UI Test" value: "ui-test-apk-focus-arm-debug" }
  }

  dimension: job_date {
    type: date
    sql: ${TABLE}.job_date ;;
  }

  dimension: job_name_field {
    type: string
    sql: ${TABLE}.job_name ;;
  }

  dimension: repository_name_field {
    type: string
    sql: ${TABLE}.repository_name ;;
  }

  measure: avg_queue_time_seconds {
    type: average
    sql: ${TABLE}.avg_queued_seconds ;;
    value_format_name: decimal_2
    label: "Avg Queue Time (sec)"
  }

  measure: avg_run_time_seconds {
    type: average
    sql: ${TABLE}.avg_run_seconds ;;
    value_format_name: decimal_2
    label: "Avg Run Time (sec)"
  }

  measure: avg_queue_time_minutes {
    type: number
    sql: ${avg_queue_time_seconds} / 60 ;;
    value_format_name: decimal_2
    label: "Avg Queue Time (min)"
  }

  measure: avg_run_time_minutes {
    type: number
    sql: ${avg_run_time_seconds} / 60 ;;
    value_format_name: decimal_2
    label: "Avg Run Time (min)"
  }

  dimension: rolling_avg_queue_time {
    type: number
    sql: ${TABLE}.rolling_avg_queue_time ;;
    value_format_name: decimal_2
    label: "7-Day Moving Avg Queue Time (min)"
  }

  dimension: rolling_avg_run_time {
    type: number
    sql: ${TABLE}.rolling_avg_run_time ;;
    value_format_name: decimal_2
    label: "7-Day Moving Avg Run Time (min)"
  }

  filter: repository_filter {
    sql: ${TABLE}.repository_name = {% parameter repository_name %} ;;
  }

  filter: job_filter {
    sql: ${TABLE}.job_name = {% parameter job_name %} ;;
  }
}
