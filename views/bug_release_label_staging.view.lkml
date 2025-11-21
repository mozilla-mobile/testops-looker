view: bug_release_label_staging {
  derived_table: {
    sql:
      WITH src AS (
        SELECT
          id AS bug_id,
          LOWER(CAST(bugzilla_qa_whiteboard AS STRING)) AS qb
        FROM `moz-mobile-tools.testops_dashboard.report_bugzilla_overall_bugs_staging`
      ),
      matches AS (
        SELECT bug_id,
               SAFE_CAST(cn AS INT64) AS c_num
        FROM src
        CROSS JOIN UNNEST(
          REGEXP_EXTRACT_ALL(COALESCE(qb,''), r'qa[-_ ]?ver(?:-(?:done|blocked))?-?c(\d{2,3})')
        ) AS cn
      )
      SELECT DISTINCT
        bug_id,
        CONCAT('c', CAST(c_num AS STRING), '/b', CAST(c_num - 1 AS STRING)) AS qa_ver_cycle_label
      FROM matches
      ;;
    persist_for: "24 hours"
  }

  dimension: bug_id { primary_key: yes type: number sql: ${TABLE}.bug_id ;; }
  dimension: qa_ver_cycle_label { type: string sql: ${TABLE}.qa_ver_cycle_label ;; }
  measure: bugs { type: count_distinct sql: ${bug_id} ;; }
}
