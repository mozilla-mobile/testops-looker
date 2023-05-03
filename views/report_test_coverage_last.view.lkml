view: report_test_coverage_last {
  sql_table_name: `moz-mobile-tools.staging.report_test_coverage`
    ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.created_at ;;
  }

  dimension: projects_id {
    type: number
    sql: ${TABLE}.projects_id ;;
  }

  dimension: test_automation_coverage_id {
    type: number
    sql: ${TABLE}.test_automation_coverage_id ;;
  }

  dimension: test_automation_status_id {
    type: number
    sql: ${TABLE}.test_automation_status_id ;;
  }

  dimension: test_count {
    type: number
    sql: ${TABLE}.test_count ;;
  }

  dimension: test_sub_suites_id {
    type: number
    sql: ${TABLE}.test_sub_suites_id ;;
  }

  dimension: test_suites_id {
    type: number
    sql: ${TABLE}.test_suites_id ;;
  }

  measure: count {
    type: count
    drill_fields: [id]
  }
}
