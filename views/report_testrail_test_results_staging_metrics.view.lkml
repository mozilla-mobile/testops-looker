view: report_testrail_test_results_staging_metrics {
  sql_table_name: `moz-mobile-tools.tmp.report_testrail_test_results_staging_metrics` ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }
  dimension: elapsed {
    type: number
    sql: ${TABLE}.elapsed ;;
  }
  dimension: run_id {
    type: number
    sql: ${TABLE}.run_id ;;
  }
  dimension: status_id {
    type: number
    sql: ${TABLE}.status_id ;;
  }
  dimension: test_id {
    type: number
    sql: ${TABLE}.test_id ;;
    link: {
      label: "View Test"
      url: "https://mozilla.testrail.io/index.php?/tests/view/{{ value }}"
    }
  }
  dimension_group: testrail_completed {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.testrail_completed_on ;;
  }
  dimension_group: testrail_created {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.testrail_created_on ;;
  }
  dimension: testrail_result_id {
    type: number
    sql: ${TABLE}.testrail_result_id ;;
  }
  dimension: type {
    type: string
    sql: ${TABLE}.type ;;
  }
  measure: count {
    type: count
    drill_fields: [id]
  }
}
