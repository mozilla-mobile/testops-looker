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

explore: report_jira_qa_needed {}

explore: report_jira_qa_requests {}

explore: report_bugzilla_qe_needed {}

explore: report_bugzilla_qe_needed_count {}

explore: report_bugzilla_query_by_keyword {}

explore: report_jira_qa_requests_new_issue_types {}

explore: report_testrail_milestones {}

explore: fennec_test_results_ios {}

explore: ios_longest_test_executions {}

explore: iriostestreleasestestedview {}

explore: report_jira_softvision_worklogs_staging {}

explore: fenix_daily_android {}

explore: focus_daily_android {}

explore: ios_flaky_tests_daily {}

explore: ios_flaky_tests_daily_row_per_flay_test_name {}

explore: ios_test_health_summary {}

explore: report_incidents_view {}

explore: report_bitrise_builds_staging {}

explore: report_jira_softvision_worklogs {}

explore: report_jira_softvision_worklogs_total_per_month {}

explore: report_sentry_crash_free_rate_session_staging {}

explore: report_testrail_user_csv {}

explore: report_sentry_crash_free_rate {}

explore: report_testrail_users {}

explore: report_bugzilla_softvision_bugs_staging {}

explore: report_test_plans_tmp {}

explore: report_test_runs_tmp {}

explore: report_bugzilla_meta_bugs {}

explore: report_testrail_test_results_staging_metrics {}

explore: report_testrail_test_runs_staging {}

explore: report_jira_qa_requests_new_issue_types_prod {}
