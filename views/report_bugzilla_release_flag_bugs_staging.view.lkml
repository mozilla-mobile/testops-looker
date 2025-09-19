view: report_bugzilla_release_flag_bugs_staging {
  sql_table_name: `moz-mobile-tools.testops_dashboard.report_bugzilla_release_flag_bugs_staging` ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }
  dimension_group: bugzilla_bug_flag_fixed {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    datatype: datetime
    sql: ${TABLE}.bugzilla_bug_flag_fixed_at ;;
  }
  dimension: bugzilla_bug_keywords {
    type: string
    sql: ${TABLE}.bugzilla_bug_keywords ;;
  }
  dimension: bugzilla_bug_qa_found_in {
    type: string
    sql: ${TABLE}.bugzilla_bug_qa_found_in ;;
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
  dimension: bugzilla_key {
    type: number
    sql: ${TABLE}.bugzilla_key ;;
  }
  dimension: bugzilla_release_version {
    type: number
    sql: ${TABLE}.bugzilla_release_version ;;
  }
  measure: count {
    type: count
    drill_fields: [id]
  }
}
