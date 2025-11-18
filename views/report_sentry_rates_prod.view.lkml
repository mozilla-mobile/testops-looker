view: report_sentry_rates_prod {
  sql_table_name: `moz-mobile-tools.testops_dashboard.report_sentry_rates_prod` ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }
  dimension: adoption_rate_user {
    type: number
    sql: ${TABLE}.adoption_rate_user ;;
  }
  dimension: crash_free_rate_session {
    type: number
    sql: ${TABLE}.crash_free_rate_session ;;
  }
  dimension: crash_free_rate_user {
    type: number
    sql: ${TABLE}.crash_free_rate_user ;;
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
  dimension: sentry_project_id {
    type: string
    sql: ${TABLE}.sentry_project_id ;;
  }
  measure: count {
    type: count
    drill_fields: [id]
  }
}
