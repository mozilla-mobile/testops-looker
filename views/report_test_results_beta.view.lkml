view: report_test_results_beta {
  sql_table_name: `moz-mobile-tools.tmp.report_test_results_beta` ;;
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
  measure: count {
    type: count
    drill_fields: [id]
  }
}
