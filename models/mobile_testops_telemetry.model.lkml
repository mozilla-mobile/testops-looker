connection: "telemetry"

include: "/views/*.view.lkml"                # include all views in the views/ folder in this project

datagroup: job_performance_refresh {
  label: "Job Performance Data Refresh"
  max_cache_age: "1 minute"  # Temporarily force rebuild
  sql_trigger: SELECT CURRENT_TIMESTAMP() ;;  # Always triggers
}

explore: android_job_performance_view {}

explore: android_job_durations {}

explore: taskcluster_android_metrics_view {}

explore: android_fxci_task_durations {}
