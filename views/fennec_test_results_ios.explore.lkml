include: "fennec_test_results_ios.view"
include: "ios_flaky_tests_daily.view"
include: "ios_test_health_summary.view"

explore: ios_test_results {
  from: fennec_test_results_ios
  label: "iOS Test Results"

  join: ios_flaky_tests_daily {
    type: left_outer
    sql_on: ${branch} = ${ios_flaky_tests_daily.branch}
    AND ${device} = ${ios_flaky_tests_daily.device}
    AND ${report_date} = ${ios_flaky_tests_daily.report_date};;
    relationship: many_to_one
  }

  join: ios_test_health_summary {
    type: left_outer
    sql_on: ${branch} = ${ios_test_health_summary.branch}
            AND ${device} = ${ios_test_health_summary.device}
            AND ${report_date} = ${ios_test_health_summary.report_date} ;;
    relationship: one_to_one
  }
}
