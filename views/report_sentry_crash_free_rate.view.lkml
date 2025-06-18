view: report_sentry_crash_free_rate {
  sql_table_name: `moz-mobile-tools.testops_dashboard.report_sentry_crash_free_rate` ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }
  dimension: crash_free_rate_session {
    type: number
    sql: ${TABLE}.crash_free_rate_session ;;
  }
  dimension: crash_free_rate_user {
    type: number
    sql: ${TABLE}.crash_free_rate_user ;;
  }
  dimension: adoption_rate_user {
    type: number
    sql: ${TABLE}.adoption_rate_user ;;
  }
  dimension_group: created {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.created_at ;;
  }
  dimension: release_version {
    type: string
    sql: ${TABLE}.release_version ;;
  }
  measure: count {
    type: count
    drill_fields: [id]
  }
}
