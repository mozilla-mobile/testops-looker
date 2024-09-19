view: irios_test_jira_desktop {
  sql_table_name: `moz-mobile-tools.testops_dashboard.irios_test_jira_desktop` ;;

  dimension_group: date_field_9 {
    type: time
    description: "%m/%d/%E4Y"
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.date_field_9 ;;
  }
  dimension: string_field_0 {
    type: string
    sql: ${TABLE}.string_field_0 ;;
  }
  dimension: string_field_1 {
    type: string
    sql: ${TABLE}.string_field_1 ;;
  }
  dimension: string_field_10 {
    type: string
    sql: ${TABLE}.string_field_10 ;;
  }
  dimension: string_field_11 {
    type: string
    sql: ${TABLE}.string_field_11 ;;
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
  dimension: string_field_5 {
    type: string
    sql: ${TABLE}.string_field_5 ;;
  }
  dimension: string_field_6 {
    type: string
    sql: ${TABLE}.string_field_6 ;;
  }
  dimension_group: timestamp_field_7 {
    type: time
    description: "%m/%d/%Y %H:%M:%E*S"
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.timestamp_field_7 ;;
  }
  dimension_group: timestamp_field_8 {
    type: time
    description: "%m/%d/%Y %H:%M:%E*S"
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.timestamp_field_8 ;;
  }
  dimension: IssueType {
    type: string
    sql: ${TABLE}.IssueType ;;
  }
  measure: count {
    type: count
  }
}
