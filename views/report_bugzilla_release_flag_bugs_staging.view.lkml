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
  dimension: release_version {
    type: string
    sql: REGEXP_EXTRACT(${TABLE}.bugzilla_bug_qa_found_in, r"qa-found-in-[cb](\d{3})") ;;
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
  dimension: release_version_int {
    type: number
    sql: SAFE_CAST(${release_version} AS INT64) ;;
  }
  dimension: versions_match {
    type: yesno
    sql: ${bugzilla_release_version} = ${release_version_int} ;;
  }
  dimension: bugzilla_bug_type {
    type: string
    sql: ${TABLE}.bugzilla_bug_type ;;
  }
  dimension: release_date {
    type: date
    sql:
    CASE ${release_version_int}
      WHEN 140 THEN DATE '2025-06-24'
      WHEN 141 THEN DATE '2025-07-22'
      WHEN 142 THEN DATE '2025-08-19'
      WHEN 143 THEN DATE '2025-09-16'
      WHEN 144 THEN DATE '2025-10-14'
      WHEN 145 THEN DATE '2025-11-11'
      WHEN 146 THEN DATE '2025-12-09'
    END ;;
  }
  dimension: versions_match_flag {
    type: yesno
    sql:
    SAFE_CAST(REGEXP_EXTRACT(${bugzilla_bug_qa_found_in}, r'qa-found-in-[cb](\\d{3})') AS INT64)
    = ${release_version_int} ;;
  }
  dimension: open_at_release_debug {
    type: string
    sql:
    CASE
      WHEN SAFE_CAST(REGEXP_EXTRACT(${bugzilla_bug_qa_found_in}, r'qa-found-in-[cb](\\d{3})') AS INT64) != ${release_version_int}
        THEN 'version_mismatch'
      WHEN ${release_date} IS NULL THEN 'no_release_date'
      WHEN ${bugzilla_bug_flag_fixed_date} IS NULL THEN 'never_fixed'
      WHEN ${bugzilla_bug_flag_fixed_date} > ${release_date} THEN 'fixed_after_release'
      ELSE 'fixed_by_release_date'
    END ;;
  }
  measure: count {
    type: count
    drill_fields: [id]
  }
}
