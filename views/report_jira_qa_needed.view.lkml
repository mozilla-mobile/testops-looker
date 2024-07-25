view: report_jira_qa_needed {
  sql_table_name: `moz-mobile-tools.testops_dashboard.report_jira_qa_needed` ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }
  dimension_group: created {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.created_at ;;
  }
  dimension: jira_qa_needed_not_verified {
    type: number
    sql: ${TABLE}.jira_qa_needed_not_verified ;;
  }
  dimension: jira_qa_needed_verified_nightly {
    type: number
    sql: ${TABLE}.jira_qa_needed_verified_nightly ;;
  }
  dimension: jira_total_qa_needed {
    type: number
    sql: ${TABLE}.jira_total_qa_needed ;;
  }
  measure: count {
    type: count
    drill_fields: [id]
  }
}
