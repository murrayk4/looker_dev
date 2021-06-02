  parameter: field_selector {
    type: string
    allowed_value: { value: "Date" }
    allowed_value: { value: "Merchant Name" }
    allowed_value: { value: "Page URL" }
  }
  
  dimension: table_selector {
    label_from_parameter: field_selector
    sql:
            CASE
             WHEN {% parameter field_selector %} = 'Date' THEN CAST(${dateday} AS STRING)
             WHEN {% parameter field_selector %} = 'Merchant Name' THEN CAST(${publisher_name} AS STRING)
             WHEN {% parameter field_selector %} = 'Page URL' THEN CAST(${page_url} AS STRING)
             ELSE NULL
            END ;;
  }
