connection: "mobile_testops"

# include all the views
include: "/views/**/*.view"

datagroup: mobile_testops_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: mobile_testops_default_datagroup

explore: songs {}

explore: report_test_coverage {}

explore: report_test_coverage_last {}

explore: songs2 {
  join: songs {
    type: left_outer
    sql_on: ${songs2.song_id} = ${songs.song_id} ;;
    relationship: many_to_one
  }
}
