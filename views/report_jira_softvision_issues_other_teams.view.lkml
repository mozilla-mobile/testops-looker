view: report_jira_softvision_issues_other_teams {
  sql_table_name: `moz-mobile-tools.testops_dashboard.report_jira_softvision_issues_other_teams` ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }
  dimension_group: created_at {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.created_at ;;
  }
  dimension_group: jira_created {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    datatype: datetime
    sql: ${TABLE}.jira_created_at ;;
  }
  dimension: jira_key {
    type: string
    sql: ${TABLE}.jira_key ;;
  }
  dimension: jira_label_duplicate {
    type: number
    sql: ${TABLE}.jira_label_duplicate ;;
  }
  dimension: jira_label_invalid {
    type: number
    value_format_name: id
    sql: ${TABLE}.jira_label_invalid ;;
  }
  dimension: jira_label_qa_not_actionable {
    type: number
    sql: ${TABLE}.jira_label_qa_not_actionable ;;
  }
  dimension: jira_label_verified {
    type: number
    sql: ${TABLE}.jira_label_verified ;;
  }
  dimension: jira_label_wontfix {
    type: number
    sql: ${TABLE}.jira_label_wontfix ;;
  }
  dimension: jira_labels {
    type: string
    sql: ${TABLE}.jira_labels ;;
  }
  dimension: jira_priority {
    type: string
    sql: ${TABLE}.jira_priority ;;
  }
  dimension: jira_project_key {
    type: string
    sql: ${TABLE}.jira_project_key ;;
  }
  dimension: jira_project_name {
    type: string
    sql: ${TABLE}.jira_project_name ;;
  }
  dimension: jira_reporter_name {
    type: string
    sql: ${TABLE}.jira_reporter_name ;;
  }
  dimension: jira_reporter_username {
    type: string
    sql: ${TABLE}.jira_reporter_username ;;
  }
  dimension: jira_status {
    type: string
    sql: ${TABLE}.jira_status ;;
  }
  dimension_group: jira_status_changed {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    datatype: datetime
    sql: ${TABLE}.jira_status_changed_at ;;
  }
  dimension: jira_summary {
    type: string
    sql: ${TABLE}.jira_summary ;;
  }
  dimension_group: jira_updated {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    datatype: datetime
    sql: ${TABLE}.jira_updated_at ;;
  }
  dimension: jira_issue_type {
    type: string
    sql: ${TABLE}.jira_issue_type ;;
  }
  measure: count {
    type: count
    drill_fields: [id, jira_reporter_name, jira_project_name, jira_reporter_username]
  }
}
