  dimension_group: created {
    type: time
    timeframes: [time, hour, date, week, month, year, hour_of_day, day_of_week, month_num, raw, week_of_year,month_name,day_of_month]
    sql: ${TABLE}.created_at ;;
  }
  
  #########################################
  ## Option 1 -- CASE WHEN Statement
  dimension: reporting_period {
    group_label: "Order Date"
    sql: CASE
        WHEN EXTRACT(YEAR from ${created_raw}) = EXTRACT(YEAR from CURRENT_TIMESTAMP())
        AND ${created_raw} < CURRENT_TIMESTAMP()
        THEN 'This Year to Date'

        WHEN EXTRACT(YEAR from ${created_raw}) + 1 = EXTRACT(YEAR from CURRENT_TIMESTAMP())
        AND CAST(FORMAT_TIMESTAMP('%j', ${created_raw}) AS INT64) <= CAST(FORMAT_TIMESTAMP('%j', CURRENT_TIMESTAMP()) AS INT64)
        THEN 'Last Year to Date'

      END
       ;;
  }
  
  #########################################
  ## Option 2 -- Day of Month Check
  dimension_group: hidden_today {
    type: time
    timeframes: [day_of_month]
    hidden: yes
    # sql: getdate() ;;
    sql: current_timestamp() ;;
  }
  
  dimension: is_before_day_of_month {
    type: yesno
    sql: ${created_day_of_month} < ${hidden_today_day_of_month} ;;
  }
  
  
  #########################################
  ## Metrics
  measure: orders_current_mtd {
    type: count
    filters: [is_before_day_of_month: "yes", created_date: "this month"]
  }
  
  measure: orders_previous_mtd {
    type: count
    filters: [is_before_day_of_month: "yes", created_date: "last month"]
  }
  
  measure: orders_year_to_date {
    type: count
    filters: [reporting_period: "This Year to Date"]
  }
