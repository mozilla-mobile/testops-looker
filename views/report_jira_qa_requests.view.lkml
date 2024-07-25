view: report_jira_qa_requests {
  sql_table_name: `moz-mobile-tools.testops_dashboard.report_jira_qa_requests` ;;
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
  dimension: jira_key {
    type: string
    sql: ${TABLE}.jira_key ;;
  }
  dimension: jira_labels {
    type: string
    sql: ${TABLE}.jira_labels ;;
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
  measure: count {
    type: count
    drill_fields: [id, jira_assignee_username]
  }
}
