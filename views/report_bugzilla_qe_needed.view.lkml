# The name of this view in Looker is "Report Bugzilla Qe Needed"
view: report_bugzilla_qe_needed {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: `moz-mobile-tools.staging.report_bugzilla_qe_needed` ;;
  drill_fields: [id]

  # This primary key is the unique key for this table in the underlying database.
  # You need to define a primary key in a view in order to join to other views.

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }
    # Here's what a typical dimension looks like in LookML.
    # A dimension is a groupable field that can be used to filter query results.
    # This dimension will be called "Bugzilla Bug Priority" in Explore.

  dimension: bugzilla_bug_priority {
    type: string
    sql: ${TABLE}.bugzilla_bug_priority ;;
  }

  dimension: bugzilla_bug_resolution {
    type: string
    sql: ${TABLE}.bugzilla_bug_resolution ;;
  }

  dimension: bugzilla_bug_severity {
    type: string
    sql: ${TABLE}.bugzilla_bug_severity ;;
  }

  dimension: bugzilla_bug_status {
    type: string
    sql: ${TABLE}.bugzilla_bug_status ;;
  }
  # Dates and timestamps can be represented in Looker using a dimension group of type: time.
  # Looker converts dates and timestamps to the specified timeframes within the dimension group.

  dimension_group: bugzilla_created {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.bugzilla_created_at ;;
  }

  dimension: bugzilla_key {
    type: string
    sql: ${TABLE}.bugzilla_key ;;
  }

  dimension: bugzilla_summary {
    type: string
    sql: ${TABLE}.bugzilla_summary ;;
  }

  dimension: bugzilla_tag_name {
    type: string
    sql: ${TABLE}.bugzilla_tag_name ;;
  }

  dimension: bugzilla_tag_setter {
    type: string
    sql: ${TABLE}.bugzilla_tag_setter ;;
  }

  dimension: bugzilla_tag_status {
    type: string
    sql: ${TABLE}.bugzilla_tag_status ;;
  }

  dimension_group: buzilla_modified {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.buzilla_modified_at ;;
  }
  measure: count {
    type: count
    drill_fields: [id, bugzilla_tag_name]
  }
}
