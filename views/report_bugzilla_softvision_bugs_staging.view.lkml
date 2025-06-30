view: report_bugzilla_softvision_bugs_staging {
  sql_table_name: `moz-mobile-tools.staging.report_bugzilla_softvision_bugs_staging` ;;

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
  dimension: release_version {
    type: string
    sql: REGEXP_EXTRACT(${TABLE}.bugzilla_qa_whiteboard, r"qa-found-in-[cb](\d{3})") ;;
  }
  measure: count {
    type: count
  }
}
