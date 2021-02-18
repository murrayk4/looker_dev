  ## check for rebookings
  dimension: appointment_exists {
    type: yesno
    sql: EXISTS
          (
          SELECT appointment.id
            FROM mem_appointment appointment
            WHERE appointment.client_card_id = mem_purchase.client_card_id
            AND appointment.deleted = FALSE
            AND appointment.activationState = 'ACTIVE'
            AND DATE(appointment.created) <= DATE(mem_purchase.purchase_date)
            AND appointment.appointment_date > mem_purchase.purchase_date
            AND appointment.business_id = mem_purchase.business_id
          );;
  }

  measure: rebooking_count {
    type: count_distinct
    filters: [appointment_exists: "yes", deleted: "0", archived: "0", supervisor_deleted: "NULL", voiding: "NULL", voided: "NULL"]
    sql: CASE
          WHEN (${mem_purchase_item.client_course_item_id} IS NOT NULL
                  OR ${mem_purchase_item.branch_service_id} IS NOT NULL
                  OR ${mem_purchase_item.branch_product_id} IS NOT NULL
                  OR ${mem_purchase_item.branch_service_reward_id} IS NOT NULL
                  OR ${mem_purchase_item.branch_product_reward_id} IS NOT NULL
                  OR ${mem_purchase_item.is_open_sale} = 1)
          THEN CONCAT(${client_card_id},${purchase_date})
          ELSE NULL
         END ;;
    drill_fields: [mem_user.user_name, rebooking_count, mem_purchase_item.total_sales,]
  }
