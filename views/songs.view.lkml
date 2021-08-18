view: songs {
  sql_table_name: `testops_dashboard.songs`
    ;;
  drill_fields: [song_id]

  dimension: song_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.song_id ;;
  }

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

  dimension: title {
    type: string
    sql: ${TABLE}.title ;;
  }

  measure: count {
    type: count
    drill_fields: [song_id, songs2.count]
  }
}
