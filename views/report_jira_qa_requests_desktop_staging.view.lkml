view: report_jira_qa_requests_desktop_staging {

  # Change from sql_table_name to derived_table
  derived_table: {
    sql:
      WITH split_trains AS (
        SELECT
          *,
          CAST(REGEXP_EXTRACT(TRIM(part), r'\d+') AS INT64) AS train_number
        FROM `moz-mobile-tools.testops_dashboard.report_jira_qa_requests_desktop_staging`,
        UNNEST(SPLIT(COALESCE(jira_tested_trains, ''), ',')) AS part
      )
      SELECT *
      FROM split_trains
      WHERE train_number IS NOT NULL
    ;;
  }

  drill_fields: [id]

  dimension: id {
    # you *can* keep primary_key: yes, but note:
    # id will now repeat when a Jira has multiple trains.
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

  # 🚨 NEW: numeric train for your graphs (e.g. 143)
  dimension: train_number {
    type: number
    sql: ${TABLE}.train_number ;;
  }

  # Use this when you want "how many Jira requests per train"
  measure: count {
    type: count
    drill_fields: [id, jira_reporter_username, jira_assignee_username]
  }

  # Optional but useful: distinct Jiras per train
  measure: jira_count {
    type: count_distinct
    sql: ${jira_key} ;;
  }
}
