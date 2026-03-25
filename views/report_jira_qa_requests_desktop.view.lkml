view: report_jira_qa_requests_desktop {

  # Change from sql_table_name to derived_table
  derived_table: {
    sql:

    -- Base table
    WITH base AS (
      SELECT *
      FROM `moz-mobile-tools.testops_dashboard.report_jira_qa_requests_desktop`
    ),

      -- Train explosion
      split_trains AS (
      SELECT
      base.*,
      CAST(REGEXP_EXTRACT(TRIM(part), r'\d+') AS INT64) AS train_number
      FROM base,
      UNNEST(SPLIT(COALESCE(jira_tested_trains, ''), ',')) AS part
      WHERE REGEXP_EXTRACT(TRIM(part), r'\d+') IS NOT NULL
      ),

      -- Deferral extraction (from base, NOT split_trains)
      deferral_events AS (
      SELECT DISTINCT
      jira_key,
      CAST(from_version AS INT64) AS deferred_from_version,
      CAST(to_version   AS INT64) AS deferred_to_version
      FROM base,
      UNNEST(REGEXP_EXTRACT_ALL(jira_timeline, r'Moved from Fx(\d+)\s+to Fx\d+')) AS from_version
      WITH OFFSET pos
      JOIN UNNEST(REGEXP_EXTRACT_ALL(jira_timeline, r'Moved from Fx\d+\s+to Fx(\d+)')) AS to_version
      WITH OFFSET pos2
      ON pos = pos2
      ),

      -- Late label extraction
      split_late_labels AS (
      SELECT
      base.jira_key,
      TRIM(label) AS single_label,
      CASE
      WHEN REGEXP_CONTAINS(TRIM(label), r'^late-c\d+$') THEN 'late-c'
      WHEN REGEXP_CONTAINS(TRIM(label), r'^late-b\d+$') THEN 'late-b'
      WHEN REGEXP_CONTAINS(TRIM(label), r'^late-doc\d+$') THEN 'late-doc'
      WHEN REGEXP_CONTAINS(TRIM(label), r'^late-rdns\d+$') THEN 'late-rdns'
      ELSE NULL
      END AS late_label_type,
      CAST(REGEXP_EXTRACT(TRIM(label), r'(\d+)$') AS INT64) AS late_label_version
      FROM base,
      UNNEST(SPLIT(COALESCE(jira_labels, ''), ',')) AS label
      WHERE REGEXP_CONTAINS(TRIM(label), r'^late-(c|b|doc|rdns)\d+$')
      )

      -- Final table
      SELECT
      st.*,
      d.deferred_from_version,
      d.deferred_to_version,
      l.single_label,
      l.late_label_type,
      l.late_label_version,
      CONCAT(
      st.jira_key, '|',
      COALESCE(l.late_label_type, ''), '|',
      COALESCE(CAST(l.late_label_version AS STRING), '')
      ) AS late_label_event_key
      FROM split_trains st
      LEFT JOIN deferral_events d
      USING (jira_key)
      LEFT JOIN split_late_labels l
      USING (jira_key)

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

  dimension: deferred_from_version {
    type: number
    sql: ${TABLE}.deferred_from_version ;;
  }

  dimension: deferred_to_version {
    type: number
    sql: ${TABLE}.deferred_to_version ;;
  }

  dimension: single_label {
    type: string
    sql: ${TABLE}.single_label ;;
  }

  dimension: late_label_type {
    type: string
    sql: ${TABLE}.late_label_type ;;
  }

  dimension: late_label_version {
    type: number
    sql: ${TABLE}.late_label_version ;;
  }

  dimension: late_label_event_key {
    hidden: yes
    type: string
    sql: ${TABLE}.late_label_event_key ;;
  }

  measure: deferred_features {
    type: count_distinct
    sql: ${jira_key} ;;
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

  measure: late_cb_count {
    type: count_distinct
    filters: [late_label_type: "late-c,late-b"]
    sql: ${late_label_event_key} ;;
  }

  measure: late_doc_count {
    type: count_distinct
    filters: [late_label_type: "late-doc"]
    sql: ${late_label_event_key} ;;
  }

  measure: late_rdns_count {
    type: count_distinct
    filters: [late_label_type: "late-rdns"]
    sql: ${late_label_event_key} ;;
  }
}
