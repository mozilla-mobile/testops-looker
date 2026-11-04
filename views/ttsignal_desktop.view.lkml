view: ttsignal_desktop {
  sql_table_name: `moz-mobile-tools.testops_stats.ttsignal_desktop` ;;

  # One row per gated desktop build (Beta 1, major RC, dot release, ESR), from the
  # DTE Jira sign-off epics + archive.mozilla.org candidates. Loaded weekly by
  # src/desktop_signoff.py (keyed on release_type + version).

  # ── Dimensions ──

  dimension: release_key {
    type: string
    sql: CONCAT(${TABLE}.release_type, '|', ${TABLE}.version) ;;
    primary_key: yes
    hidden: yes
  }

  dimension: release_type {
    type: string
    sql: ${TABLE}.release_type ;;
    description: "beta1 | major | dot | esr"
  }

  dimension: release_type_label {
    type: string
    sql: CASE ${release_type}
           WHEN 'beta1' THEN 'Beta 1'
           WHEN 'major' THEN 'Major RC'
           WHEN 'dot'   THEN 'Dot release'
           WHEN 'esr'   THEN IF(${is_scheduled}, 'ESR (scheduled RC)', 'ESR (unscheduled)')
         END ;;
    description: "Release type, with ESRs split into scheduled RCs and unscheduled dot releases"
  }

  dimension: version {
    type: string
    sql: ${TABLE}.version ;;
    description: "Archive version, e.g. 158.0, 158.0.1, 153.5.0esr, 158.0b1"
  }

  dimension: major_version {
    type: number
    sql: CAST(REGEXP_EXTRACT(${version}, r'^(\d+)') AS INT64) ;;
  }

  dimension: release_label {
    type: string
    sql: CONCAT(${version}, ' - ', ${release_type}, ' - ', CAST(DATE(${TABLE}.testing_started) AS STRING)) ;;
    description: "Chart label: version - type - testing date (unique per bar)"
  }

  dimension: epic {
    type: string
    sql: ${TABLE}.epic ;;
    description: "DTE epic key(s); a release can span two sprint epics"
    link: {
      label: "Open in Jira"
      url: "https://mozilla-hub.atlassian.net/browse/{{ value | split: ', ' | first }}"
    }
  }

  dimension: summary {
    type: string
    sql: ${TABLE}.summary ;;
  }

  dimension: build_used {
    type: number
    sql: ${TABLE}.build_used ;;
    description: "Candidate build tested (respins: the build ready when testing started)"
  }

  dimension_group: planned_start {
    type: time
    datatype: date
    timeframes: [date, week, month]
    sql: ${TABLE}.planned_start ;;
    description: "Epic Start date: the day testing was planned for"
  }

  dimension_group: build_ready {
    type: time
    timeframes: [raw, time, date, week, month, day_of_week]
    sql: ${TABLE}.build_ready ;;
    description: "When the candidate build (win64 installer) landed on archive.mozilla.org"
  }

  dimension_group: testing_started {
    type: time
    timeframes: [raw, time, date, week, month]
    sql: ${TABLE}.testing_started ;;
    description: "First DTE task moved to In Progress"
  }

  dimension_group: validation_done {
    type: time
    timeframes: [raw, time, date]
    sql: ${TABLE}.validation_done ;;
    description: "Last validation task Completed (fixes, prefs, localtest, DLL, packages)"
  }

  dimension_group: cdntest_started {
    type: time
    timeframes: [raw, time, date]
    sql: ${TABLE}.cdntest_started ;;
  }

  dimension_group: release_checks_done {
    type: time
    timeframes: [raw, time, date]
    sql: ${TABLE}.release_checks_done ;;
    description: "Last task Completed (release / esr channel checks, after shipping)"
  }

  dimension: schedule_wait_h {
    type: number
    sql: ${TABLE}.schedule_wait_h ;;
    description: "Schedule wait: hours a build sat ready before its planned start day (ESR RCs, by agreement with Relman). The plan, not QA."
    value_format_name: decimal_1
  }

  dimension: pickup_h {
    type: number
    sql: ${TABLE}.pickup_h ;;
    description: "Pickup: build ready (or planned day, if held for schedule) -> testing started. Mostly the overnight handoff to SoftVision's workday."
    value_format_name: decimal_1
  }

  dimension: validation_h {
    type: number
    sql: ${TABLE}.validation_h ;;
    description: "Validation: testing started -> validation tasks done. The QA work itself. Blank when tasks were batch-closed on cdntest day."
    value_format_name: decimal_1
  }

  dimension: cycle_h {
    type: number
    sql: ${pickup_h} + ${validation_h} ;;
    description: "QA cycle time: pickup + validation (excludes schedule and release-calendar waits)"
    value_format_name: decimal_1
  }

  dimension: wait_for_cdntest_h {
    type: number
    sql: ${TABLE}.wait_for_cdntest_h ;;
    description: "Validation done -> cdntest started (release management). Scheduled releases only."
    value_format_name: decimal_1
  }

  dimension: total_h {
    type: number
    sql: ${TABLE}.total_h ;;
    description: "Build ready -> release checks done. Mostly the release calendar for major/ESR RCs."
    value_format_name: decimal_1
  }

  dimension: is_scheduled {
    type: yesno
    sql: ${TABLE}.wait_for_cdntest_h IS NOT NULL ;;
    description: "Scheduled release: cdntest is a separate step days after validation (major/ESR RCs)"
  }

  dimension: held_for_schedule {
    type: yesno
    sql: COALESCE(${TABLE}.schedule_wait_h, 0) > 0 ;;
  }

  dimension: tasks {
    type: number
    sql: ${TABLE}.tasks ;;
  }

  dimension: flags {
    type: string
    sql: ${TABLE}.flags ;;
    description: "Data-quality notes: bookkeeping updates, tasks left open, batch closes, split epics"
  }

  dimension: has_flags {
    type: yesno
    sql: COALESCE(${TABLE}.flags, '') != '' ;;
  }

  dimension_group: ingested_at {
    type: time
    timeframes: [raw, time, date]
    sql: ${TABLE}.ingested_at ;;
    hidden: yes
  }

  # ── Measures ──
  # Looker `median`/`percentile` use APPROX_QUANTILES on BigQuery; effectively exact
  # at this volume (a handful of gated builds per cycle).

  measure: release_count {
    type: count
    description: "Gated builds"
  }

  measure: median_pickup_h {
    type: median
    sql: ${pickup_h} ;;
    value_format_name: decimal_1
  }

  measure: median_validation_h {
    type: median
    sql: ${validation_h} ;;
    value_format_name: decimal_1
  }

  measure: median_cycle_h {
    type: median
    sql: ${cycle_h} ;;
    description: "Median QA cycle time (pickup + validation)"
    value_format_name: decimal_1
  }

  measure: p90_cycle_h {
    type: percentile
    percentile: 90
    sql: ${cycle_h} ;;
    value_format_name: decimal_1
  }

  measure: median_total_h {
    type: median
    sql: ${total_h} ;;
    value_format_name: decimal_1
  }

  measure: median_schedule_wait_h {
    type: median
    sql: ${schedule_wait_h} ;;
    filters: [held_for_schedule: "Yes"]
    description: "Median schedule wait, among builds held for their planned start"
    value_format_name: decimal_1
  }

  measure: count_flagged {
    type: count
    filters: [has_flags: "Yes"]
  }
}
