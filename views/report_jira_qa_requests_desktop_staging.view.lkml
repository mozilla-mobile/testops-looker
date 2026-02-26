view: report_jira_qa_requests_desktop_staging {
  sql_table_name: `moz-mobile-tools.testops_dashboard.report_jira_qa_requests_desktop_staging` ;;
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
  dimension: jira_priority {
    type: string
    sql: ${TABLE}.jira_priority ;;
  }
  dimension: jira_product {
    type: string
    sql: ${TABLE}.jira_product ;;
  }
  dimension: jira_reporter_username {
    type: string
    sql: ${TABLE}.jira_reporter_username ;;
  }
  dimension: jira_status {
    type: string
    sql: ${TABLE}.jira_status ;;
  }
  dimension: jira_story_points {
    type: number
    sql: ${TABLE}.jira_story_points ;;
  }
  dimension: jira_subtasks {
    type: string
    sql: ${TABLE}.jira_subtasks ;;
  }
  dimension: jira_summary {
    type: string
    sql: ${TABLE}.jira_summary ;;
  }
  dimension: jira_target_release {
    type: string
    sql: ${TABLE}.jira_target_release ;;
  }
  dimension: jira_tested_trains {
    type: string
    sql: ${TABLE}.jira_tested_trains ;;
  }
  dimension: jira_timeline {
    type: string
    sql: ${TABLE}.jira_timeline ;;
  }
  dimension_group: jira_updated {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.jira_updated_at ;;
  }
  measure: count {
    type: count
    drill_fields: [id, jira_reporter_username, jira_assignee_username]
  }
}
