view: report_bugzilla_meta_bugs {
  sql_table_name: `moz-mobile-tools.testops_dashboard.report_bugzilla_meta_bugs` ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }
  dimension: bugzilla_bug_assigned_to {
    type: string
    sql: ${TABLE}.bugzilla_bug_assigned_to ;;
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
  dimension: bugzilla_bug_parent {
    type: string
    sql: ${TABLE}.bugzilla_bug_parent ;;
  }
  dimension: bugzilla_bug_priority {
    type: string
    sql: ${TABLE}.bugzilla_bug_priority ;;
  }
  dimension: bugzilla_bug_product {
    type: string
    sql: ${TABLE}.bugzilla_bug_product ;;
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
  dimension: bugzilla_key {
    type: number
    sql: ${TABLE}.bugzilla_key ;;
  }
  dimension: bugzilla_summary {
    type: string
    sql: ${TABLE}.bugzilla_summary ;;
  }
  measure: count {
    type: count
    drill_fields: [id]
  }
}
