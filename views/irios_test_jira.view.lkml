view: irios_test_jira {
  sql_table_name: `moz-mobile-tools.testops_dashboard.irios_test_jira` ;;

  dimension: int64_field_8 {
    type: number
    sql: ${TABLE}.int64_field_8 ;;
  }
  dimension: string_field_0 {
    type: string
    sql: ${TABLE}.string_field_0 ;;
  }
  dimension: string_field_1 {
    type: string
    sql: ${TABLE}.string_field_1 ;;
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
  dimension: string_field_6 {
    type: string
    sql: ${TABLE}.string_field_6 ;;
  }
  dimension: string_field_7 {
    type: string
    sql: ${TABLE}.string_field_7 ;;
  }
  dimension_group: timestamp_field_5 {
    type: time
    description: "%m/%d/%Y %H:%M:%E*S"
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.timestamp_field_5 ;;
  }
  measure: count {
    type: count
  }
}
