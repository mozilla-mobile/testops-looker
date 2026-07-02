view: ttsignal {
  sql_table_name: `moz-mobile-tools.testops_stats.ttsignal` ;;

  # ── Dimensions ──

  dimension: project {
    type: string
    sql: ${TABLE}.project ;;
  }

  dimension: milestone_id {
    type: number
    sql: ${TABLE}.milestone_id ;;
    primary_key: yes
    hidden: yes
  }

  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
    description: "TestRail milestone name"
  }

  dimension: version {
    type: string
    sql: ${TABLE}.version ;;
  }

  dimension: major_version {
    type: number
    sql: CAST(REGEXP_EXTRACT(${version}, r'^(\d+)') AS INT64) ;;
    description: "Major release version (e.g. 153) — the natural per-cycle grouping"
  }

  dimension: build_used {
    type: number
    sql: ${TABLE}.build_used ;;
  }

  dimension_group: build_produced {
    type: time
    timeframes: [raw, time, date, week, month]
    sql: ${TABLE}.build_produced ;;
    description: "When the candidate APK was produced on archive.mozilla.org"
  }

  dimension_group: first_run_created {
    type: time
    timeframes: [raw, time, date, week, month]
    sql: ${TABLE}.first_run_created ;;
    description: "When SoftVision began testing (earliest TestRail run created)"
  }

  dimension_group: completed_on {
    type: time
    timeframes: [raw, time, date, week, month]
    sql: ${TABLE}.completed_on ;;
    description: "When QA sign-off completed"
  }

  dimension: is_weekend_build {
    type: yesno
    sql: EXTRACT(DAYOFWEEK FROM ${build_produced_raw}) IN (1, 7) ;;
    description: "Build produced on a Sat/Sun — isolates weekend-inflated wait time from process speed"
  }

  dimension: wait_h {
    type: number
    sql: ${TABLE}.wait_h ;;
    description: "Hours from build produced to testing started"
    value_format_name: decimal_1
  }

  dimension: active_h {
    type: number
    sql: ${TABLE}.active_h ;;
    description: "Hours of active testing"
    value_format_name: decimal_1
  }

  dimension: total_h {
    type: number
    sql: ${TABLE}.total_h ;;
    description: "Total hours from build produced to sign-off"
    value_format_name: decimal_1
  }

  dimension: firstrun_valid {
    type: yesno
    sql: ${TABLE}.firstrun_valid ;;
    description: "Whether wait/active decomposition is trustworthy"
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension_group: ingested_at {
    type: time
    timeframes: [raw, time, date]
    sql: ${TABLE}.ingested_at ;;
    hidden: yes
  }

  # ── Measures ──
  # NOTE: Looker `type: median`/`percentile` on BigQuery use APPROX_QUANTILES
  # (approximate). At this volume (dozens of milestones per cycle) it is
  # effectively exact.

  measure: median_total_h {
    type: median
    sql: ${total_h} ;;
    description: "Median total time-to-signal (build produced to sign-off)"
    value_format_name: decimal_1
    filters: [status: "ok%"]
  }

  measure: p90_total_h {
    type: percentile
    percentile: 90
    sql: ${total_h} ;;
    description: "90th-percentile total time-to-signal — exposes the weekend-driven tail the median hides"
    value_format_name: decimal_1
    filters: [status: "ok%"]
  }

  measure: median_wait_h {
    type: median
    sql: ${wait_h} ;;
    description: "Median wait time (build produced to testing started)"
    value_format_name: decimal_1
    filters: [status: "ok", firstrun_valid: "Yes"]
  }

  measure: p90_wait_h {
    type: percentile
    percentile: 90
    sql: ${wait_h} ;;
    description: "90th-percentile wait time — the weekend/scheduling tail"
    value_format_name: decimal_1
    filters: [status: "ok", firstrun_valid: "Yes"]
  }

  measure: median_active_h {
    type: median
    sql: ${active_h} ;;
    description: "Median active testing time"
    value_format_name: decimal_1
    filters: [status: "ok", firstrun_valid: "Yes"]
  }

  # ── Coverage / data-quality measures ──

  measure: milestone_count {
    type: count
    description: "Milestones with a valid total (build resolved, produced before sign-off)"
    filters: [status: "ok%"]
  }

  measure: milestone_count_all {
    type: count
    description: "All milestones evaluated, regardless of resolution status"
  }

  measure: resolution_rate {
    type: number
    sql: SAFE_DIVIDE(${milestone_count}, ${milestone_count_all}) ;;
    description: "Share of milestones that resolved to a build — watch for archive-join breakage"
    value_format_name: percent_1
  }

  measure: count_suspect {
    type: count
    description: "Rows where the build was produced after sign-off (excluded from metrics)"
    filters: [status: "suspect%"]
  }

  measure: count_run_excluded {
    type: count
    description: "Rows where the test run pre-dates the build (excluded from wait/active)"
    filters: [status: "%run<build%"]
  }

  measure: avg_milestones_per_week {
    type: number
    sql: COUNT(DISTINCT ${milestone_id}) / NULLIF(COUNT(DISTINCT ${completed_on_week}), 0) ;;
    value_format_name: decimal_1
  }
}
