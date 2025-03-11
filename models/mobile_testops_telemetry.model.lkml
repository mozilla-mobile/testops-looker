connection: "telemetry"

include: "/views/*.view.lkml"                # include all views in the views/ folder in this project

datagroup: job_performance_refresh {
  label: "Job Performance Data Refresh"
  max_cache_age: "24 hours"  # Refreshes the PDT once per day
  sql_trigger: SELECT MAX(start_time) FROM `moz-fx-data-shared-prod.treeherder_db.job`;;
}

explore: android_job_performance_view {}
