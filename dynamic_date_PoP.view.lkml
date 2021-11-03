## DONE IN BIGQUERY DIALECT
#################################

view: date_range_parms {
  view_label: "** GMV Date Range"

  parameter: gmv_date_selector {
    label: "GMV Date Filter"
    type: unquoted
    allowed_value: {
      label: "Order Date"
      value: "order"
    }
    allowed_value: {
      label: "Subscription Date"
      value: "subscription"
    }
  }


  dimension_group: gmv_date {
    label: "GMV"
    description: "Default is Order Date unless you use the 'GMV Date Filter'"
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql:
    {% if gmv_date_selector._parameter_value == 'order' %}
      ${orders.created_raw}
    {% elsif gmv_date_selector._parameter_value == 'subscription' %}
      ${subscriptions.created_raw}
    {% else %}
      ${orders.created_raw}
    {% endif %};;
  }



  ### Period Over Period Analysis

  filter: previous_period_filter {
    label: "Period Comparison Filter"
    type: date
    description: "Use this filter for period analysis"
    sql: ${previous_period} IS NOT NULL ;;
  }

  dimension: previous_period {
    label: "Period Comparison"
    type: string
    description: "The reporting period as selected by the Period Comparison Filter"
    sql:
      CASE
        WHEN {% date_start previous_period_filter %} is not null AND {% date_end previous_period_filter %} is not null /* date ranges or in the past x days */
          THEN
            CASE
              WHEN ${gmv_date_raw} >=  {% date_start previous_period_filter %}
                AND ${gmv_date_raw} <= {% date_end previous_period_filter %}
                THEN 'This Period'
              WHEN ${gmv_date_raw} >=
              TIMESTAMP_ADD(TIMESTAMP_ADD({% date_start previous_period_filter %}, INTERVAL -1 DAY ), INTERVAL
                -1*DATE_DIFF(DATE({% date_end previous_period_filter %}), DATE({% date_start previous_period_filter %}), DAY) + 1 DAY)
                AND ${gmv_date_raw} <=
                TIMESTAMP_ADD({% date_start previous_period_filter %}, INTERVAL -1 DAY )
                THEN 'Previous Period'
            END
          END ;;
  }


}
