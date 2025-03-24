view: report_incidents_view {
  sql_table_name: `moz-mobile-tools.testops_dashboard.report_incidents_view` ;;

  dimension: comment {
    type: string
    sql: ${TABLE}.comment ;;
  }
  dimension: incident_link {
    type: string
    sql: ${TABLE}.incident_link ;;
  }
  dimension: platform {
    type: string
    sql: ${TABLE}.platform ;;
  }
  dimension_group: reported {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.reported_date ;;
  }
  dimension: severity {
    type: string
    sql: ${TABLE}.severity ;;
  }
  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }
  dimension: submitted {
    type: string
    sql: ${TABLE}.submitted ;;
  }
  dimension: summary {
    type: string
    sql: ${TABLE}.summary ;;
  }
  dimension: updated_date {
    type: string
    sql: ${TABLE}.updated_date ;;
  }
  measure: count {
    type: count
  }
}
