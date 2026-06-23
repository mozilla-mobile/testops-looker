view: android_fenix_efficiency_test_authors {
  sql_table_name: `moz-mobile-tools.testops_results.test_authors` ;;

  dimension_group: date {
    type: time
    timeframes: [date, week, month]
    datatype: date
    sql: ${TABLE}.date ;;
  }

  dimension: author {
    type: string
    sql: ${TABLE}.author ;;
  }

  dimension: test_count {
    type: number
    sql: ${TABLE}.test_count ;;
    description: "Number of commits to the TAE efficiency directory by this author"
  }

  measure: total_commits {
    type: sum
    sql: ${test_count} ;;
    label: "Total Commits"
    description: "Total commits to TAE efficiency directory"
  }

  measure: author_count {
    type: count_distinct
    sql: ${author} ;;
    description: "Number of unique contributors"
  }
}
