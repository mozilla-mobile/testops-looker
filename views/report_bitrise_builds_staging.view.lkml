view: report_bitrise_builds_staging {
  sql_table_name: `moz-mobile-tools.staging.report_bitrise_builds_staging` ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }
  dimension: branch {
    type: string
    sql: ${TABLE}.branch ;;
  }
  dimension: build_number {
    type: number
    sql: ${TABLE}.build_number ;;
  }
  dimension: status {
    type: number
    sql: ${TABLE}.status ;;
  }
  dimension: status_text {
    type: string
    sql: ${TABLE}.status_text ;;
  }
  dimension_group: triggered {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.triggered_at ;;
  }
  dimension: triggered_by {
    type: string
    sql: ${TABLE}.triggered_by ;;
  }
  dimension: triggered_workflow {
    type: string
    sql: ${TABLE}.triggered_workflow ;;
  }
  measure: count {
    type: count
    drill_fields: [id]
  }
}
