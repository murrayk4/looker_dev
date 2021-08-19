  ## OPTION 1
  
measure: total_settlement_value  {
    type: sum
    sql: ${reconciliation_value_signed} ;;
    required_fields: [dim_currency.isocode]
    html: {{dim_currency.symbol._value}}{{rendered_value}} ;;
    value_format: "#,##0;(#,##0)"
  }
  
  
  ## OPTION 2
  
    # FIXME - how should we refer to a single version of this selector?
  parameter: KPI_selector {
    label: "KPI Selector"
    group_label: "FMS"
    type: unquoted
  }

  measure: cdda_KPI {
    type:  number
    value_format_name: decimal_2
    label: "KPI"
    group_label: "Conversion Date DDA"
    label_from_parameter: KPI_selector
    sql:  {% if KPI_selector._parameter_value == 'CAC' %}
          ${cdda_cac}
          {% elsif KPI_selector._parameter_value == 'CPP' %}
          ${cdda_cpp}
          {% elsif KPI_selector._parameter_value == 'ROAS' %}
          ${cdda_roas}
          {% elsif KPI_selector._parameter_value == 'ROI' %}
          ${cdda_roi}
          {% else %}
          {% endif %};;
    html:
    <a href="#drillmenu" target="_self">
    {% if KPI_selector._parameter_value == "CAC" %}
    £{{ rendered_value }}
    {% elsif KPI_selector._parameter_value == "CPP" %}
    £{{ rendered_value }}
    {% elsif KPI_selector._parameter_value == "ROAS" %}
    {{ rendered_value }}
    {% else %}
    {{ rendered_value }}
    {% endif %}
    </a>;;
    }
}

