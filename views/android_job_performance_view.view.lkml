view: android_job_performance_view {
  sql_table_name: `moz-mobile-tools.testops_stats.android_job_performance_view` ;;

  parameter: repository_name {
    type: string
    label: "Repository Name"
    allowed_value: {
      label: "Mozilla-Central"
      value: "mozilla-central"
    }
    default_value: "mozilla-central"
  }

  parameter: job_name {
    type: string
    label: "Job Name"
    allowed_value: {
      label: "Fenix Debug UI Test"
      value: "ui-test-apk-fenix-arm-debug"
    }
    default_value: "ui-test-apk-fenix-arm-debug"
  }

  dimension: job_name_field {
    sql: ${TABLE}.job_name ;;
    type: string
  }

  dimension: repository_name_field {
    sql: ${TABLE}.repository_name ;;
    type: string
  }

  measure: avg_queue_time {
    type: average
    sql: ${TABLE}.queued_seconds ;;
    value_format_name: decimal_2
    label: "Avg Queue Time (s)"
  }

  measure: avg_run_time {
    type: average
    sql: ${TABLE}.run_seconds ;;
    value_format_name: decimal_2
    label: "Avg Run Time (s)"
  }

  measure: total_avg_time {
    type: number
    sql: ${avg_queue_time} + ${avg_run_time} ;;
    value_format_name: decimal_2
    label: "Total Avg Time (s)"
  }

  filter: repository_filter {
    sql: ${TABLE}.repository_name = {% parameter repository_name %} ;;
  }

  filter: job_filter {
    sql: ${TABLE}.job_name = {% parameter job_name %} ;;
  }
}
