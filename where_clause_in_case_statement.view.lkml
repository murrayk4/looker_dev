## 1) Filter for selecting the date range clients return to branch/business
  filter: clients_returned_date {
    type: date
  }
  ## 2) This dimension takes in the filter parameters applied by the user for the clients_returned_date
  ##    We will hide this from the explore, but use it as a filter for the "clients_returned" KPI
  dimension: clients_returned_period {
    hidden: yes
    type: string
    sql: CASE
          WHEN (${retained_purchase.created_raw} >= {% date_start clients_returned_date %}
                AND ${retained_purchase.created_raw} <= {% date_end clients_returned_date %})
            OR ({% date_start clients_returned_date %} is null
                AND {% date_end clients_returned_date %} is null)
          THEN 'returned_period'
         END ;;
  }
  ## 3) We apply the dimension above as a filter. The reason for this is to embed the filter is the
  ##.   CASE WHEN statement rather than the WHERE clause in the SQL query
  measure: clients_returned {
    type: count_distinct
    filters: [clients_returned_period: "returned_period", deleted: "0", archived: "0", supervisor_deleted: "NULL", voiding: "NULL", voided: "NULL", mem_purchase_item.deleted: "0"]
    sql: CASE WHEN (${mem_purchase_item.client_course_item_id} IS NOT NULL
                OR ${mem_purchase_item.branch_service_id} IS NOT NULL
                OR ${mem_purchase_item.branch_product_id} IS NOT NULL
                OR ${mem_purchase_item.branch_service_reward_id} IS NOT NULL
                OR ${mem_purchase_item.branch_product_reward_id} IS NOT NULL
                OR ${mem_purchase_item.is_open_sale} = 1
                )
                AND ${days_between_visits} IS NOT NULL
          THEN CONCAT(${client_card_id},${purchase_date})
          ELSE NULL
         END ;;
  }
