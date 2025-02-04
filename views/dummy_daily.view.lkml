view: dummy_daily {
  sql_table_name: `moz-mobile-tools.testops_stats.dummy_daily` ;;

  dimension_group: date {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.Date ;;
  }
  dimension: failed_runs {
    type: number
    sql: ${TABLE}.`Failed Runs` ;;
  }
  dimension: failure_rate {
    type: number
    sql: ${TABLE}.`Failure Rate` ;;
  }
  dimension: flaky_rate {
    type: number
    sql: ${TABLE}.`Flaky Rate` ;;
  }
  dimension: flaky_runs {
    type: number
    sql: ${TABLE}.`Flaky Runs` ;;
  }
  dimension: total_runs {
    type: number
    sql: ${TABLE}.`Total Runs` ;;
  }
  measure: count {
    type: count
  }
}
