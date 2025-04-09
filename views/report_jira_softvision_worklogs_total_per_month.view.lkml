view: report_jira_softvision_worklogs_total_per_month {
  sql_table_name: `moz-mobile-tools.testops_dashboard.report_jira_softvision_worklogs_total_per_month` ;;

  dimension: apr {
    type: number
    sql: ${TABLE}.Apr ;;
  }
  dimension: aug {
    type: number
    sql: ${TABLE}.Aug ;;
  }
  dimension: dec {
    type: number
    sql: ${TABLE}.Dec ;;
  }
  dimension: feb {
    type: number
    sql: ${TABLE}.Feb ;;
  }
  dimension: jan {
    type: number
    sql: ${TABLE}.Jan ;;
  }
  dimension: jul {
    type: number
    sql: ${TABLE}.Jul ;;
  }
  dimension: jun {
    type: number
    sql: ${TABLE}.Jun ;;
  }
  dimension: mar {
    type: number
    sql: ${TABLE}.Mar ;;
  }
  dimension: may {
    type: number
    sql: ${TABLE}.May ;;
  }
  dimension: nov {
    type: number
    sql: ${TABLE}.Nov ;;
  }
  dimension: oct {
    type: number
    sql: ${TABLE}.Oct ;;
  }
  dimension: sep {
    type: number
    sql: ${TABLE}.Sep ;;
  }
  dimension: user {
    type: string
    sql: ${TABLE}.user ;;
  }
  measure: count {
    type: count
  }
}
