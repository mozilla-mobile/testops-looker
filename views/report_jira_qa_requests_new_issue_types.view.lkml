view: report_jira_qa_requests_new_issue_types {
  sql_table_name: `moz-mobile-tools.staging.report_jira_qa_requests_new_issue_types` ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }
  dimension: jira_assignee_username {
    type: string
    sql: ${TABLE}.jira_assignee_username ;;
  }
  dimension_group: jira_created {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.jira_created_at ;;
  }
  dimension: jira_engineering_team {
    type: string
    sql: ${TABLE}.jira_engineering_team ;;
  }
  dimension: jira_firefox_release_train {
    type: string
    sql: ${TABLE}.jira_firefox_release_train ;;
  }
  dimension: jira_issue_type {
    type: string
    sql: ${TABLE}.jira_issue_type ;;
  }
  dimension: jira_key {
    type: string
    sql: ${TABLE}.jira_key ;;
  }
  dimension: jira_labels {
    type: string
    sql: ${TABLE}.jira_labels ;;
  }
  dimension: jira_parent_link {
    type: string
    sql: ${TABLE}.jira_parent_link ;;
  }
  dimension: jira_status {
    type: string
    sql: ${TABLE}.jira_status ;;
  }
  dimension: jira_story_points {
    type: number
    sql: ${TABLE}.jira_story_points ;;
  }
  dimension: jira_summary {
    type: string
    sql: ${TABLE}.jira_summary ;;
  }
  dimension: jira_tested_train {
    type: string
    sql: ${TABLE}.jira_tested_train ;;
  }
  measure: count {
    type: count
    drill_fields: [id, jira_assignee_username]
  }
}
