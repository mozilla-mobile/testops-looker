view: iriostestqarequests {
  sql_table_name: `moz-mobile-tools.testops_dashboard.irios-test-qa-requests` ;;

  dimension: assignee {
    type: string
    sql: ${TABLE}.Assignee ;;
  }
  dimension_group: created {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.Created ;;
  }
  dimension: key {
    type: string
    sql: ${TABLE}.Key ;;
  }
  dimension: priority {
    type: string
    sql: ${TABLE}.Priority ;;
  }
  dimension: reporter {
    type: string
    sql: ${TABLE}.Reporter ;;
  }
  dimension: resolution {
    type: string
    sql: ${TABLE}.Resolution ;;
  }
  dimension: status {
    type: string
    sql: ${TABLE}.Status ;;
  }
  dimension: summary {
    type: string
    sql: ${TABLE}.Summary ;;
  }
  measure: count {
    type: count
  }
}
