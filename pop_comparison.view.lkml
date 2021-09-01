  ########################
  ## Period Over Period Analysis -- These fields are used for single value period over period comparisons

  filter: this_period_filter {
    type: date
    description: "Use this filter to define the current and previous period for analysis"
    sql: ${period} IS NOT NULL ;;
  }
  
  ### SNOWFLAKE
  
  dimension: period {
    type: string
    description: "The reporting period as selected by the This Period Filter"
    sql:
      CASE
        WHEN {% date_start this_period_filter %} is not null AND {% date_end this_period_filter %} is not null /* date ranges or in the past x days */
          THEN
            CASE
              WHEN ${created_raw} >= {% date_start this_period_filter %}
                AND ${created_raw} <= {% date_end this_period_filter %}
                THEN 'This Period'
              WHEN ${created_raw} >= DATEADD(day,-1*DATEDIFF(day,{% date_start this_period_filter %}, {% date_end this_period_filter %} ) + 1, DATEADD(day,-1,{% date_start this_period_filter %} ) )
                AND ${created_raw} <= DATEADD(day,-1,{% date_start this_period_filter %} ) + 1
                THEN 'Previous Period'
            END
        END ;;
  }
  
  
  ## ATHENA
  
  dimension: this_period_vs_previous_period {
    label: "This Period vs Previous Period"
    hidden:  no
    type: string
    description: "The reporting period as selected by the This Period Filter"
    sql:
      CASE
        WHEN {% date_start this_period_filter %} is not null AND {% date_end this_period_filter %} is not null /* date ranges or in the past x days */
          THEN
            CASE
              WHEN ${date_from_raw} >= {% date_start this_period_filter %}
               AND ${date_from_raw} <= {% date_end this_period_filter %}
              THEN 'This Period'
              WHEN ${date_from_raw} >= DATE_ADD('day',-1*DATE_DIFF('day',{% date_start this_period_filter %}, {% date_end this_period_filter %} ), {% date_start this_period_filter %} )
               AND ${date_from_raw} <= {% date_start this_period_filter %}
              THEN 'Previous Period'
            END
        END ;;
  }


