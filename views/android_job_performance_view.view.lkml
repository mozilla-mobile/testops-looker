view: android_job_performance_view {
    derived_table: {
      sql:
      SELECT
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
        AND job.start_time >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 30 DAY)
        AND repository.name = {% parameter repository_name %}
        AND job_type.name = {% parameter job_name %}
    ;;
    }

    # 📌 Parameter: Repository Name (Dropdown Filter)
    parameter: repository_name {
      type: string
      label: "Repository Name"
      default_value: "mozilla-central"

      allowed_value: {
        label: "Mozilla Central"
        value: "mozilla-central"
      }

      allowed_value: {
        label: "Mozilla Beta"
        value: "mozilla-beta"
      }
    }

    # 📌 Parameter: Job Name (Dropdown Filter)
    parameter: job_name {
      type: string
      label: "Job Name"
      default_value: "ui-test-apk-fenix-arm-debug"

      allowed_value: {
        label: "Fenix Debug UI Test"
        value: "ui-test-apk-fenix-arm-debug"
      }

      allowed_value: {
        label: "Fenix Release UI Test"
        value: "ui-test-apk-fenix-arm-release"
      }
    }

    # 📊 Job Name Dimension
    dimension: job_name_field {
      sql: ${TABLE}.job_name ;;
      type: string
    }

    # 📊 Repository Name Dimension
    dimension: repository_name_field {
      sql: ${TABLE}.repository_name ;;
      type: string
    }

    # 🔢 Measure: Average Queue Time
    measure: avg_queue_time {
      type: average
      sql: ${TABLE}.queued_seconds ;;
      value_format_name: decimal_2
      label: "Avg Queue Time (s)"
    }

    # 🔢 Measure: Average Run Time
    measure: avg_run_time {
      type: average
      sql: ${TABLE}.run_seconds ;;
      value_format_name: decimal_2
      label: "Avg Run Time (s)"
    }

    # 🔍 Filter by Repository Name
    filter: repository_filter {
      sql: ${TABLE}.repository_name = {% parameter repository_name %} ;;
    }

    # 🔍 Filter by Job Name
    filter: job_filter {
      sql: ${TABLE}.job_name = {% parameter job_name %} ;;
    }
}
