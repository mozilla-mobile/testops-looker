view: report_bugzilla_overall_bugs_staging {
  sql_table_name: `moz-mobile-tools.testops_dashboard.report_bugzilla_overall_bugs_staging` ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }
  dimension_group: bugzilla_bug_created {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    datatype: datetime
    sql: ${TABLE}.bugzilla_bug_created_at ;;
  }
  dimension: bugzilla_bug_keyword {
    type: string
    sql: ${TABLE}.bugzilla_bug_keyword ;;
  }
  dimension_group: bugzilla_bug_last_change {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    datatype: datetime
    sql: ${TABLE}.bugzilla_bug_last_change_time ;;
  }
  dimension: bugzilla_bug_priority {
    type: string
    sql: ${TABLE}.bugzilla_bug_priority ;;
  }
  dimension: bugzilla_bug_resolution {
    type: string
    sql: ${TABLE}.bugzilla_bug_resolution ;;
  }
  dimension_group: bugzilla_bug_resolved {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    datatype: datetime
    sql: ${TABLE}.bugzilla_bug_resolved_at ;;
  }
  dimension: bugzilla_bug_severity {
    type: string
    sql: ${TABLE}.bugzilla_bug_severity ;;
  }
  dimension: bugzilla_bug_status {
    type: string
    sql: ${TABLE}.bugzilla_bug_status ;;
  }
  dimension: bugzilla_bug_whiteboard {
    type: string
    sql: ${TABLE}.bugzilla_bug_whiteboard ;;
  }
  dimension: bugzilla_key {
    type: number
    sql: ${TABLE}.bugzilla_key ;;
  }
  dimension: bugzilla_product {
    type: string
    sql: ${TABLE}.bugzilla_product ;;
  }
  dimension: bugzilla_qa_whiteboard {
    type: string
    sql: ${TABLE}.bugzilla_qa_whiteboard ;;
  }
  dimension: bugzilla_summary {
    type: string
    sql: ${TABLE}.bugzilla_summary ;;
  }
  dimension_group: created_at {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.created_at ;;
  }

  # Extract the token and state (done/blocked) tied to a nightly cycle c###
  dimension: qa_ver_token {
    type: string
    sql: REGEXP_EXTRACT(${TABLE}.bugzilla_qa_whiteboard, r"(qa-ver-(?:done|blocked)-c\d{3})") ;;
  }

  dimension: qa_ver_state {
    type: string
    sql: LOWER(REGEXP_EXTRACT(${TABLE}.bugzilla_qa_whiteboard, r"qa-ver-(done|blocked)-c\d{3}")) ;;
  }
  dimension: qa_investig_state {
    type: string
    sql: LOWER(REGEXP_EXTRACT(${TABLE}.bugzilla_qa_whiteboard, r"qa-investig-(done|blocked)-c\d{3}")) ;;
  }

  # Nightly cycle number (e.g., 141 from qa-ver-done-c141)
  dimension: qa_ver_c_nightly_num {
    type: number
    sql: SAFE_CAST(REGEXP_EXTRACT(${TABLE}.bugzilla_qa_whiteboard, r"qa-ver-(?:done|blocked)-c(\d{3})") AS INT64) ;;
  }
  dimension: qa_investig_c_nightly_num {
    type: number
    sql: SAFE_CAST(REGEXP_EXTRACT(${TABLE}.bugzilla_qa_whiteboard, r"qa-investig-(?:done|blocked)-c(\d{3})") AS INT64) ;;
  }
  # Derived Beta = Nightly - 1
  dimension: qa_ver_b_beta_num {
    type: number
    sql: CASE WHEN ${qa_ver_c_nightly_num} IS NOT NULL THEN ${qa_ver_c_nightly_num} - 1 END ;;
  }
  dimension: qa_investig_b_beta_num {
    type: number
    sql: CASE WHEN ${qa_investig_c_nightly_num} IS NOT NULL THEN ${qa_investig_c_nightly_num} - 1 END ;;
  }

  # Pretty cycle label: c141/b140
  dimension: qa_ver_cycle {
    type: string
    sql:
    CASE
      WHEN ${qa_ver_c_nightly_num} IS NOT NULL
      THEN CONCAT('c', CAST(${qa_ver_c_nightly_num} AS STRING), '/b', CAST(${qa_ver_b_beta_num} AS STRING))
    END ;;
  }
  dimension: qa_investig_cycle {
    type: string
    sql:
    CASE
      WHEN ${qa_investig_c_nightly_num} IS NOT NULL
      THEN CONCAT('c', CAST(${qa_investig_c_nightly_num} AS STRING), '/b', CAST(${qa_investig_b_beta_num} AS STRING))
    END ;;
  }
  measure: bugs_verified_total {
    type: count
    filters: [qa_ver_state: "done,blocked"]
    description: "qa-ver done OR blocked"
  }

  measure: bugs_investigated_total {
    type: count
    filters: [qa_investig_state: "done,blocked"]
    description: "qa-ver done OR blocked"
  }

  measure: count {
    type: count
    drill_fields: [id]
  }
}
