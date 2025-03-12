view: android_job_performance_view {
    derived_table: {
      datagroup_trigger: job_performance_refresh
      sql:
      SELECT
        DATE_TRUNC(job.start_time, DAY) AS job_date
        job_type.name AS job_name,
        repository.name AS repository_name,
        TIMESTAMP_DIFF(job.start_time, job.submit_time, SECOND) AS queued_seconds,
        TIMESTAMP_DIFF(job.end_time, job.start_time, SECOND) AS run_seconds
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
        AND job.start_time >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL CAST({% parameter time_interval %} AS INT64) DAY)
        AND repository.name = {% parameter repository_name %}
        AND job_type.name = {% parameter job_name %}
      GROUP BY 1, 2, 3
    ;;
    }

    parameter: time_interval {
      type: string
      label: "Time Interval"
      default_value: "30"

      allowed_value: {
        label: "Past 7 Days"
        value: "7"
      }

      allowed_value: {
        label: "Past 30 Days"
        value: "30"
      }

      allowed_value: {
        label: "Past 90 Days"
        value: "90"
      }
    }

    parameter: repository_name {
      type: string
      label: "Repository Name"
      default_value: "mozilla-central"

      allowed_value: {
        label: "Autoland"
        value: "autoland"
      }

      allowed_value: {
        label: "Mozilla Central"
        value: "mozilla-central"
      }

      allowed_value: {
        label: "Mozilla Beta"
        value: "mozilla-beta"
      }
    }

    parameter: job_name {
      type: string
      label: "Job Name"
      default_value: "ui-test-apk-fenix-arm-debug"

      allowed_value: {
        label: "Fenix Debug UI Test"
        value: "ui-test-apk-fenix-arm-debug"
      }

      allowed_value: {
        label: "Focus Debug UI Test"
        value: "ui-test-apk-focus-arm-debug"
      }
    }

    dimension: job_date {
      type: date
      sql: DATE_TRUNC(${TABLE}.job_date, DAY) ;;
    }

    dimension: job_name_field {
      sql: ${TABLE}.job_name ;;
      type: string
    }

    dimension: repository_name_field {
      sql: ${TABLE}.repository_name ;;
      type: string
    }

    dimension: avg_queue_time_minutes {
      type: number
      sql: ${TABLE}.queued_seconds / 60 ;;
      value_format_name: decimal_2
      label: "Avg Queue Time (min)"
    }

    dimension: avg_run_time_minutes {
      type: number
      sql: ${TABLE}.run_seconds / 60 ;;
      value_format_name: decimal_2
      label: "Avg Run Time (min)"
    }

    measure: rolling_avg_queue_time {
      type: average
      sql: AVG(${avg_queue_time_minutes}) OVER (ORDER BY ${job_date} ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) ;;
      value_format_name: decimal_2
      label: "7-Day Moving Avg Queue Time (min)"
    }

    measure: rolling_avg_run_time {
      type: average
      sql: AVG(${avg_run_time_minutes}) OVER (ORDER BY ${job_date} ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) ;;
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
