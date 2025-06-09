view: report_testrail_user_csv {
  sql_table_name: `moz-mobile-tools.staging.report_testrail_user_csv` ;;

  dimension_group: created {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.Created_at ;;
  }
  dimension: email {
    type: string
    sql: ${TABLE}.Email ;;
  }
  dimension: name {
    type: string
    sql: ${TABLE}.Name ;;
  }
  dimension: role {
    type: string
    sql: ${TABLE}.Role ;;
  }
  dimension: status {
    type: string
    sql: ${TABLE}.Status ;;
  }
  measure: count {
    type: count
    drill_fields: [name]
  }
}
