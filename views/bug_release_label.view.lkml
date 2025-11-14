view: bug_release_label {
  derived_table: {
    sql:
      WITH src AS (
        SELECT
          id AS bug_id,
          LOWER(CAST(bugzilla_qa_whiteboard AS STRING)) AS qb
        FROM `moz-mobile-tools.testops_dashboard.report_bugzilla_overall_bugs_staging`
      ),
      matches AS (
        -- todas las C### de tags qa-ver-(done|blocked)
        SELECT
          bug_id,
          SAFE_CAST(cn AS INT64) AS c_num
        FROM src,
        UNNEST(
          REGEXP_EXTRACT_ALL(qb, r'qa-ver-(?:done|blocked)?-?c(\d{3})')
        ) AS cn
      )
      SELECT DISTINCT
        bug_id,
        CONCAT('c', CAST(c_num AS STRING), '/b', CAST(c_num - 1 AS STRING)) AS qa_ver_cycle_label
      FROM matches
      ;;
    persist_for: "24 hours"
    #-- mientras pruebas, puedes forzar rebuild:
    #-- sql_trigger_value: SELECT CURRENT_TIMESTAMP() ;;
  }

  dimension: bug_id { primary_key: yes type: number sql: ${TABLE}.bug_id ;; }
  dimension: qa_ver_cycle_label { type: string sql: ${TABLE}.qa_ver_cycle_label ;; }
  measure: bugs { type: count_distinct sql: ${bug_id} ;; }
}
