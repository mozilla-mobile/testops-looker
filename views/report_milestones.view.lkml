view: report_milestones {
  sql_table_name: `moz-mobile-tools.staging.report_testrail_milestones` ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }
  dimension: build_name {
    type: string
    sql: ${TABLE}.build_name ;;
  }
  dimension: build_version {
    type: string
    sql: ${TABLE}.build_version ;;
  }
  dimension_group: completed {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.completed_on ;;
  }
  dimension: description {
    type: string
    sql: ${TABLE}.description ;;
  }
  dimension: is_completed {
    type: string
    sql: ${TABLE}.is_completed ;;
  }
  dimension: testrail_milestone_id {
    type: number
    sql: ${TABLE}.testrail_milestone_id ;;
  }
  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
  }
  dimension: projects_id {
    type: number
    sql: ${TABLE}.projects_id ;;
  }
  dimension_group: started {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.started_on ;;
  }
  dimension: testing_recommendation {
    type: string
    sql: ${TABLE}.testing_recommendation ;;
  }
  dimension: testing_status {
    type: string
    sql: ${TABLE}.testing_status ;;
  }
  dimension: url {
    type: string
    sql: ${TABLE}.url ;;
  }
  measure: count {
    type: count
    drill_fields: [id, build_name, name]
  }
}
