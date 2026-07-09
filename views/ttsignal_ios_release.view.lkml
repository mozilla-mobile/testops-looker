view: ttsignal_ios_release {
  sql_table_name: `moz-mobile-tools.testops_stats.ttsignal_ios_release` ;;

  # ── Dimensions ──

  dimension: version {
    type: string
    sql: ${TABLE}.version ;;
    primary_key: yes
    description: "iOS release version (RCs collapsed)"
  }

  dimension: project {
    type: string
    sql: ${TABLE}.project ;;
  }

  dimension: rc_milestones {
    type: number
    sql: ${TABLE}.rc_milestones ;;
    description: "RC milestones in this release (the main driver of total time)"
  }

  dimension_group: rc1_build_produced {
    type: time
    timeframes: [raw, date, week, month]
    sql: ${TABLE}.rc1_build_produced ;;
    description: "When RC1 became available (Ship-It created)"
  }

  dimension_group: signoff {
    type: time
    timeframes: [raw, date, week, month]
    sql: ${TABLE}.signoff ;;
    description: "Final green sign-off (latest RC milestone close)"
  }

  dimension: total_h {
    type: number
    sql: ${TABLE}.total_h ;;
    value_format_name: decimal_1
    description: "Elapsed hours RC1-available -> sign-off (driven by RC count)"
  }

  dimension: total_days {
    type: number
    sql: ${TABLE}.total_h / 24.0 ;;
    value_format_name: decimal_1
  }

  dimension: wait_h {
    type: number
    sql: ${TABLE}.wait_h ;;
    value_format_name: decimal_1
    description: "RC1 available -> testing start (largely weekend/cadence; not QA effort)"
  }

  dimension: active_h {
    type: number
    sql: ${TABLE}.active_h ;;
    value_format_name: decimal_1
    description: "Testing start -> sign-off (spans the whole multi-RC regression)"
  }

  # ── Measures ──
  # Medians are approximate on BigQuery (APPROX_QUANTILES); fine at this volume.

  measure: release_count {
    type: count
    description: "Number of releases"
  }

  measure: median_total_h {
    type: median
    sql: ${total_h} ;;
    value_format_name: decimal_1
    description: "Median elapsed time-to-signal (build -> sign-off)"
  }

  measure: p90_total_h {
    type: percentile
    percentile: 90
    sql: ${total_h} ;;
    value_format_name: decimal_1
    description: "90th-percentile elapsed time-to-signal (the multi-RC tail)"
  }

  measure: avg_rc_milestones {
    type: average
    sql: ${rc_milestones} ;;
    value_format_name: decimal_1
    description: "Average RCs per release -- the explanatory variable for total time"
  }

  measure: multi_rc_releases {
    type: count
    filters: [rc_milestones: ">1"]
    description: "Releases that needed more than one RC"
  }
}
