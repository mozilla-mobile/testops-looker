view: android_fenix_conversion_tracking {
  sql_table_name: `moz-mobile-tools.testops_results.conversion_tracking` ;;

  dimension: date {
    type: date
    datatype: date
    sql: ${TABLE}.date ;;
    primary_key: yes
  }

  dimension: converted_count {
    type: number
    sql: ${TABLE}.converted_count ;;
    description: "Number of legacy tests annotated with @Converted"
  }

  dimension: smoke_test_count {
    type: number
    sql: ${TABLE}.smoke_test_count ;;
    description: "Number of tests annotated with @SmokeTest"
  }

  measure: latest_converted_count {
    type: max
    sql: ${converted_count} ;;
    description: "Most recent converted test count"
  }

  measure: latest_smoke_test_count {
    type: max
    sql: ${smoke_test_count} ;;
    description: "Most recent smoke test count"
  }
}
