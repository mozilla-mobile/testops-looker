view: katmerinotestresults {
  sql_table_name: `moz-mobile-tools.testops_dashboard.kat-merino-test-results` ;;

  dimension_group: date_field_0 {
    type: time
    description: "%E4Y-%m-%d"
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.date_field_0 ;;
  }
  dimension: double_field_13 {
    type: number
    sql: ${TABLE}.double_field_13 ;;
  }
  dimension: double_field_14 {
    type: number
    sql: ${TABLE}.double_field_14 ;;
  }
  dimension: int64_field_1 {
    type: number
    sql: ${TABLE}.int64_field_1 ;;
  }
  dimension: int64_field_10 {
    type: number
    sql: ${TABLE}.int64_field_10 ;;
  }
  dimension: int64_field_11 {
    type: number
    sql: ${TABLE}.int64_field_11 ;;
  }
  dimension: int64_field_12 {
    type: number
    sql: ${TABLE}.int64_field_12 ;;
  }
  dimension: int64_field_5 {
    type: number
    sql: ${TABLE}.int64_field_5 ;;
  }
  dimension: int64_field_6 {
    type: number
    sql: ${TABLE}.int64_field_6 ;;
  }
  dimension: int64_field_7 {
    type: number
    sql: ${TABLE}.int64_field_7 ;;
  }
  dimension: int64_field_8 {
    type: number
    sql: ${TABLE}.int64_field_8 ;;
  }
  dimension: int64_field_9 {
    type: number
    sql: ${TABLE}.int64_field_9 ;;
  }
  dimension: string_field_2 {
    type: string
    sql: ${TABLE}.string_field_2 ;;
  }
  dimension: string_field_3 {
    type: string
    sql: ${TABLE}.string_field_3 ;;
  }
  dimension: string_field_4 {
    type: string
    sql: ${TABLE}.string_field_4 ;;
  }
  measure: count {
    type: count
  }
}
