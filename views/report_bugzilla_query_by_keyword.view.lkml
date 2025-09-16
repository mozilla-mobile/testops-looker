view: report_bugzilla_query_by_keyword {
  sql_table_name: `moz-mobile-tools.staging.report_bugzilla_query_by_keyword` ;;

  dimension: id {
    type: number
    sql: ${TABLE}.id ;;
    primary_key: yes
  }

  dimension: bugzilla_key {
    type: number
    sql: ${TABLE}.bugzilla_key ;;
  }

  dimension: bugzilla_summary {
    type: string
    sql: ${TABLE}.bugzilla_summary ;;
  }

  dimension: bugzilla_product {
    type: string
    sql: ${TABLE}.bugzilla_product ;;
  }

  dimension: bugzilla_qa_whiteboard {
    type: string
    sql: ${TABLE}.bugzilla_qa_whiteboard ;;
  }

  dimension: bugzilla_bug_severity {
    type: string
    sql: ${TABLE}.bugzilla_bug_severity ;;
  }

  dimension: bugzilla_bug_priority {
    type: string
    sql: ${TABLE}.bugzilla_bug_priority ;;
  }

  dimension: bugzilla_bug_status {
    type: string
    sql: ${TABLE}.bugzilla_bug_status ;;
  }

  dimension: bugzilla_bug_resolution {
    type: string
    sql: ${TABLE}.bugzilla_bug_resolution ;;
  }

  dimension_group: bugzilla_bug_created_at {
    type: time
    timeframes: [raw, date, week, month, year]
    sql: ${TABLE}.bugzilla_bug_created_at ;;
  }

  dimension_group: bugzilla_bug_last_change_time {
    type: time
    timeframes: [raw, date, week, month, year]
    sql: ${TABLE}.bugzilla_bug_last_change_time ;;
  }

  dimension: bugzilla_bug_whiteboard {
    type: string
    sql: ${TABLE}.bugzilla_bug_whiteboard ;;
  }

  dimension: bugzilla_bug_keyword {
    type: string
    sql: ${TABLE}.bugzilla_bug_keyword ;;
  }

  dimension_group: bugzilla_bug_resolved_at {
    type: time
    timeframes: [raw, date, week, month, year]
    sql: ${TABLE}.bugzilla_bug_resolved_at ;;
  }

  dimension_group: created_at {
    type: time
    timeframes: [raw, date, week, month, year]
    sql: ${TABLE}.created_at ;;
  }

  measure: count {
    type: count
    drill_fields: [id, bugzilla_summary, bugzilla_product]
  }
}
