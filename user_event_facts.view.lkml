view: user_event_facts {
  derived_table: {
    sql: SELECT
          userid,
          min(eventtimestamp) as user_first_seen,
          max(eventtimestamp) as latest_session
         FROM event_table
        GROUP BY 1 ;;
  }
  
  
  measure: count {
    type: count_distinct
    sql: ${userid} ;;
    hidden: yes
  }
  
  dimension: userid {
    primary_key: yes
    type: string
    sql: ${TABLE}.userid ;;
  }
  
  dimension_group: user_first_seen {
    type: time
    sql: ${TABLE}.user_first_seen ;;
  }
  
  dimension_group: latest_session {
    type: time
    sql: ${TABLE}.latest_session ;;
  }
  
  
  ### CHURN METRICS ####
  
  dimension: days_since_active {
    type: number
    description: "Days since last activity"
    sql: DATEDIFF(day, ${latest_session_date}, CURRENT_DATE) ;;
  }
  
  dimension: is_churned {
    type: yesno
    sql: ${days_since_active} > 30 ;; ## can be anything
  }
  
  measure: churned_users {
    type: count_distinct
    sql: ${userid} ;;
    filters: [is_churned: "yes"]
  }
  
  measure: churn_rate {
    type: number
    sql: 1.0 * ${churned_users} / NULLIF(${count},0) ;;
    value_format_name: percent_2
  }
  
  measure: active_users {
    type: count_distinct
    sql: ${userid} ;;
    filters: [is_churned: "no"]
  }
  
  measure: active_rate {
    type: number
    sql: 1.0 * ${active_users} / NULLIF(${count},0) ;;
    value_format_name: percent_2
  }
  
  
  ### RETENTION METRICS ###
  
  dimension: days_since_user_signup {
    type: number
    description: "Days since first seen (from today)"
    sql:  DATEDIFF(day, ${user_first_seen_date}, CURRENT_DATE) ;;
  }
  
  dimension: retention_day {
    group_label: "Retention"
    description: "Days since first seen (from event date)"
    type:  number
    sql:  DATEDIFF(day, ${user_first_seen_date}, ${event_table.eventtimestamp_date}) ;;
  }
  
  
  # D1
  measure: d1_retained_users {
    group_label: "Retention"
    description: "Number of players that came back to play on day 1"
    type: count_distinct
    sql: ${userid} ;;
    filters: {
      field: retention_day
      value: "1"
    }
  }
  
  measure: d1_eligible_users {
    hidden: yes
    group_label: "Retention"
    description: "Number of players older than 0 days"
    type: count_distinct
    sql: ${userid} ;;
    filters: {
      field: days_since_user_signup
      value: ">0"
    }
  }
  
  measure: d1_retention_rate {
    group_label: "Retention"
    description: "% of players (that are older than 0 days) that came back to play on day 1"
    value_format_name: percent_2
    type: number
    sql: 1.0 * ${d1_retained_users}/ NULLIF(${d1_eligible_users},0);;
  }
  
  #D7
  measure: d7_retained_users {
    group_label: "Retention"
    description: "Number of players that came back to play on day 7"
    type: count_distinct
    sql: ${userid} ;;
    filters: {
      field: retention_day
      value: "7"
    }
  }
  
  measure: d7_eligible_users {
    hidden: yes
    group_label: "Retention"
    description: "Number of players older than 7 days"
    type: count_distinct
    sql: ${userid} ;;
    filters: {
      field: days_since_user_signup
      value: ">7"
    }
  }
  
  measure: d7_retention_rate {
    group_label: "Retention"
    description: "% of players (that are older than 7 days) that came back to play on day 7"
    value_format_name: percent_2
    type: number
    sql: 1.0 * ${d7_retained_users}/ NULLIF(${d7_eligible_users},0);;
  }
  
  # D14
  measure: d14_retained_users {
    group_label: "Retention"
    description: "Number of players that came back to play on day 14"
    type: count_distinct
    sql: ${userid} ;;
    filters: {
      field: retention_day
      value: "14"
    }
  }
  
  measure: d14_eligible_users {
    hidden: yes
    group_label: "Retention"
    description: "Number of players older than 14 days"
    type: count_distinct
    sql: ${userid} ;;
    filters: {
      field: days_since_user_signup
      value: ">14"
    }
  }
  
  measure: d14_retention_rate {
    group_label: "Retention"
    description: "% of players (that are older than 14 days) that came back to play on day 14"
    value_format_name: percent_2
    type: number
    sql: 1.0 * ${d14_retained_users}/ NULLIF(${d14_eligible_users},0);;
  }
  
  # D30
  measure: d30_retained_users {
    group_label: "Retention"
    description: "Number of players that came back to play on day 30"
    type: count_distinct
    sql: ${userid} ;;
    filters: {
      field: retention_day
      value: "30"
    }
  }
  
  measure: d30_eligible_users {
    hidden: yes
    group_label: "Retention"
    description: "Number of players older than 30 days"
    type: count_distinct
    sql: ${userid} ;;
    filters: {
      field: days_since_user_signup
      value: ">30"
    }
  }
  
  measure: d30_retention_rate {
    group_label: "Retention"
    description: "% of players (that are older than 30 days) that came back to play on day 30"
    value_format_name: percent_2
    type: number
    sql: 1.0 * ${d30_retained_users}/ NULLIF(${d30_eligible_users},0);;
  }
  
  
  set: detail {
    fields: [userid, latest_session_date, is_churned]
  }
}
