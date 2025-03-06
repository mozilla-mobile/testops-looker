connection: "mobile_testops"

# include all the views
include: "/views/**/*.view"
include: "/test_feature_usage.view.lkml"

datagroup: mobile_testops_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: mobile_testops_default_datagroup

explore: report_test_coverage {}

explore: report_test_coverage_show_status {}

explore: report_test_coverage_last {}

explore: report_test_run_counts {}

explore: report_test_case_coverage {}

explore: report_test_coverage_by_project {}

explore: report_test_run_counts_proyect_and_sub_suites {}

explore: report_test_case_coverage_weekly_saturday {}

explore: report_test_case_coverage_prod {}

explore: report_test_coverage_by_project_prod {}

explore: irios_test_jira {}

explore: katmerinotestresults {}

explore: report_jira_qa_needed {}

explore: report_jira_qa_requests {}

explore: irios_test_jira_desktop {}

explore: report_bugzilla_qe_needed {}

explore: report_bugzilla_qe_needed_count_staging {}

explore: report_bugzilla_qe_needed_count {}

explore: report_jira_qa_requests_new_issue_types {}

explore: report_milestones {}

explore: dummy_daily {}

explore: report_testrail_milestones {}

explore: iosinsightsdummy {}

explore: iriostestreleasestestedview {}

explore: fenix_daily_android {}

explore: focus_daily_android {}

explore: android_job_performance_view {}
