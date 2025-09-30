view: report_bugzilla_softvision_bugs_staging {
  sql_table_name: `moz-mobile-tools.staging.report_bugzilla_softvision_bugs_staging` ;;
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
  dimension_group: bugzilla_bug_resolved_at {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    datatype: datetime
    sql: ${TABLE}.bugzilla_bug_resolved_at ;;
  }
  dimension: release_version {
    type: string
    sql: REGEXP_EXTRACT(${TABLE}.bugzilla_qa_whiteboard, r"qa-found-in-[cb](\d{3})") ;;
  }
  dimension: release_version_nightly {
    type: string
    sql: REGEXP_EXTRACT(${TABLE}.bugzilla_qa_whiteboard, r"qa-found-in-c(\d{3})") ;;
  }

  dimension: release_version_beta {
    type: string
    sql: REGEXP_EXTRACT(${TABLE}.bugzilla_qa_whiteboard, r"qa-found-in-b(\d{3})") ;;
  }
  dimension: release_channel {
    type: string
    sql: CASE
          WHEN REGEXP_CONTAINS(${TABLE}.bugzilla_qa_whiteboard, r"qa-found-in-c\d{3}") THEN 'Nightly'
          WHEN REGEXP_CONTAINS(${TABLE}.bugzilla_qa_whiteboard, r"qa-found-in-b\d{3}") THEN 'Beta'
          ELSE 'Other'
        END ;;
  }
  dimension: days_to_fix_workdays_excl_start {
    type: number
    sql:
      CASE
        WHEN ${bugzilla_bug_resolved_at_date} IS NULL OR ${bugzilla_bug_created_date} IS NULL
          THEN NULL
        WHEN ${bugzilla_bug_resolved_at_date} < ${bugzilla_bug_created_date}
          THEN NULL
        ELSE (
          SELECT COUNTIF(EXTRACT(DAYOFWEEK FROM d) NOT IN (1,7))
          FROM UNNEST(
            GENERATE_DATE_ARRAY(
              ${bugzilla_bug_created_date}, -- exclude start day
              ${bugzilla_bug_resolved_at_date}                        -- include end day
            )
          ) AS d
        )
      END ;;
  }
  measure: count {
    type: count
  }
}
