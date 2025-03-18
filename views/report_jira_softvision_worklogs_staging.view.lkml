view: report_jira_softvision_worklogs_staging {
  sql_table_name: `moz-mobile-tools.staging.report_jira_softvision_worklogs_staging` ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }
  dimension: author {
    type: string
    sql: ${TABLE}.author ;;
  }
  dimension: child_key {
    type: string
    sql: ${TABLE}.child_key ;;
  }
  dimension: comment {
    type: string
    sql: ${TABLE}.comment ;;
  }
  dimension: parent_key {
    type: string
    sql: ${TABLE}.parent_key ;;
  }
  dimension_group: started {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.started_date ;;
  }
  dimension: time_spent {
    type: string
    sql: ${TABLE}.time_spent ;;
  }
  dimension: time_spent_seconds {
    type: number
    sql: ${TABLE}.time_spent_seconds ;;
  }
  measure: count {
    type: count
    drill_fields: [id]
  }
}
