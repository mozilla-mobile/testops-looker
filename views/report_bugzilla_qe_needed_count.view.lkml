# The name of this view in Looker is "Report Bugzilla Qe Needed Count"
view: report_bugzilla_qe_needed_count {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: `moz-mobile-tools.testops_dashboard.report_bugzilla_qe_needed_count` ;;
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
    # This dimension will be called "Bugzilla Total Qa Needed" in Explore.

  dimension: bugzilla_total_qa_needed {
    type: number
    sql: ${TABLE}.bugzilla_total_qa_needed ;;
  }

  # A measure is a field that uses a SQL aggregate function. Here are defined sum and average
  # measures for this dimension, but you can also add measures of many different aggregates.
  # Click on the type parameter to see all the options in the Quick Help panel on the right.

  measure: total_bugzilla_total_qa_needed {
    type: sum
    sql: ${bugzilla_total_qa_needed} ;;  }
  measure: average_bugzilla_total_qa_needed {
    type: average
    sql: ${bugzilla_total_qa_needed} ;;  }
  # Dates and timestamps can be represented in Looker using a dimension group of type: time.
  # Looker converts dates and timestamps to the specified timeframes within the dimension group.

  dimension_group: created {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.created_at ;;
  }
  measure: count {
    type: count
    drill_fields: [id]
  }
}
