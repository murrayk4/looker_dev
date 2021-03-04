  measure: total_settlement_value  {
    type: sum
    sql: ${reconciliation_value_signed} ;;
    required_fields: [dim_currency.isocode]
    html: {{dim_currency.symbol._value}}{{rendered_value}} ;;
    value_format: "#,##0;(#,##0)"
  }
