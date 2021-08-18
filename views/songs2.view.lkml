view: songs2 {
  sql_table_name: `testops_dashboard.songs2`
    ;;

  dimension: artist {
    type: string
    sql: ${TABLE}.artist ;;
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

  dimension: genre {
    type: string
    sql: ${TABLE}.genre ;;
  }

  dimension: song_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.song_id ;;
  }

  dimension: title {
    type: string
    sql: ${TABLE}.title ;;
  }

  measure: count {
    type: count
    drill_fields: [songs.song_id]
  }
}
