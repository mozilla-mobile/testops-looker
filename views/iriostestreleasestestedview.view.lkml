view: iriostestreleasestestedview {
  sql_table_name: `moz-mobile-tools.dummy.irios-test-releases-tested-view` ;;

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
  dimension: string_field_5 {
    type: string
    sql: ${TABLE}.string_field_5 ;;
  }
  dimension: string_field_6 {
    type: string
    sql: ${TABLE}.string_field_6 ;;
  }
  measure: count {
    type: count
  }
}
