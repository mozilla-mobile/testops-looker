view: android_job_performance_view {
  derived_table: {
    datagroup_trigger: job_performance_refresh
    sql:
    WITH weekly_aggregates AS (
        SELECT
            DATE_TRUNC(job.start_time, WEEK) AS week_start,
            job_type.name AS job_name,
            repository.name AS repository_name,
            AVG(TIMESTAMP_DIFF(job.start_time, job.submit_time, SECOND)) AS weekly_avg_queued_seconds,
            AVG(TIMESTAMP_DIFF(job.end_time, job.start_time, SECOND)) AS weekly_avg_run_seconds
        FROM
            `moz-fx-data-shared-prod.treeherder_db.job` AS job
        JOIN
            `moz-fx-data-shared-prod.treeherder_db.repository` AS repository
            ON job.repository_id = repository.id
        JOIN
            `moz-fx-data-shared-prod.treeherder_db.job_type` AS job_type
            ON job.job_type_id = job_type.id
        WHERE
            job.result = 'success'
            AND TIMESTAMP(job.start_time) >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 90 DAY)
            AND repository.name = "mozilla-central"
            AND job_type.name = "ui-test-apk-fenix-arm-debug"
        GROUP BY
            week_start, job_name, repository_name
    )

    SELECT
        *,
        -- 4-week Rolling Average Calculation
        AVG(weekly_avg_queued_seconds) OVER (
            PARTITION BY repository_name, job_name
            ORDER BY week_start
            ROWS BETWEEN 3 PRECEDING AND CURRENT ROW
        ) AS rolling_4_week_avg_queued_seconds,

        AVG(weekly_avg_run_seconds) OVER (
            PARTITION BY repository_name, job_name
            ORDER BY week_start
            ROWS BETWEEN 3 PRECEDING AND CURRENT ROW
        ) AS rolling_4_week_avg_run_seconds

    FROM weekly_aggregates
    WHERE DATE(week_start) >= DATE_SUB(CURRENT_DATE(), INTERVAL 5 WEEK)
    ORDER BY week_start DESC;
        ;;
  }

  parameter: repository_name {
    type: string
    label: "Repository Name"
    default_value: "mozilla-central"

    allowed_value: { label: "Autoland" value: "autoland" }
    allowed_value: { label: "Mozilla Central" value: "mozilla-central" }
    allowed_value: { label: "Mozilla Beta" value: "mozilla-beta" }
    allowed_value: { label: "Mozilla Release" value: "mozilla-release" }
  }

  parameter: job_name {
    type: string
    label: "Job Name"
    default_value: "ui-test-apk-fenix-arm-debug"

    allowed_value: { label: "Fenix Debug UI Test" value: "ui-test-apk-fenix-arm-debug" }
    allowed_value: { label: "Focus Debug UI Test" value: "ui-test-apk-focus-arm-debug" }
    allowed_value: { label: "Fenix Build APK" value: "build-apk-fenix-debug" }
    allowed_value: { label: "Focus Build APK" value: "build-apk-focus-debug" }
    allowed_value: { label: "Fenix Debug Unit Test" value: "test-apk-fenix-debug" }
    allowed_value: { label: "Focus Debug Unit Test" value: "test-apk-focus-debug" }
  }

  dimension: week_start {
    type: date
    sql: ${TABLE}.week_start ;;
  }

  dimension: job_name_field {
    type: string
    sql: ${TABLE}.job_name ;;
  }

  dimension: repository_name_field {
    type: string
    sql: ${TABLE}.repository_name ;;
  }

  measure: rolling_avg_queue_time {
    type: average
    sql: ${TABLE}.rolling_4_week_avg_queued_seconds / 60 ;;
    value_format_name: decimal_2
    label: "4-Week Moving Avg Queue Time (min)"
  }

  measure: rolling_avg_run_time {
    type: average
    sql: ${TABLE}.rolling_4_week_avg_run_seconds / 60 ;;
    value_format_name: decimal_2
    label: "4-Week Moving Avg Run Time (min)"
  }

  measure: weekly_avg_queue_time {
    type: average
    sql: ${TABLE}.weekly_avg_queued_seconds / 60 ;;
    value_format_name: decimal_2
    label: "Weekly Avg Queue Time (min)"
  }

  measure: weekly_avg_run_time {
    type: average
    sql: ${TABLE}.weekly_avg_run_seconds / 60 ;;
    value_format_name: decimal_2
    label: "Weekly Avg Run Time (min)"
  }

  # filter: repository_filter {
  #  sql: ${TABLE}.repository_name = {% parameter repository_name %} ;;
  # }

  # filter: job_filter {
  #  sql: ${TABLE}.job_name = {% parameter job_name %} ;;
  # }
}
