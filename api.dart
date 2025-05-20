class CommonApi {
  static const baseUrl = "https://testapi.gain-hub.com";
}

class Api {
  static const login = "${CommonApi.baseUrl}/authentication/users_login";
  static const profile = "${CommonApi.baseUrl}/employee_pro/employee_form";
  static const checkStatus = "${CommonApi.baseUrl}/attendance/get_check_status";
  static const punchIn = "${CommonApi.baseUrl}/attendance/create_check_in";
  static const punchOut = "${CommonApi.baseUrl}/attendance/check_out";
  static const menu = "${CommonApi.baseUrl}/menus/get_app_menus";
  static const subMenus = "${CommonApi.baseUrl}/menus/sub_menus";
}

Map<String, String> getApiUrls(String name) {
  Map<String, String> apiUrls = {
    'createUrl': '',
    'searchUrl': '',
    'deleteUrl': '',
    'LsitUrl': '',
    'typeUrl': '',
    'formUrl': '',
    'dropdownUrl': '',
    'many2manyUrl': '',
    'startURL': '',
    'cancelURL': '',
    'reassignURL': '',
    'rescheduleURL': '',
    'profileURL': '',
    'attributeUrl': '',
    'editAttributeURL': '',
  };

  switch (name) {
    case 'attendance':
      apiUrls['LsitUrl'] =
          '${CommonApi.baseUrl}/attendance/attendance_list_view';

    case 'leads':
      apiUrls['LsitUrl'] = '${CommonApi.baseUrl}/lead_form/lead_form_list_data';
      apiUrls['formUrl'] = '${CommonApi.baseUrl}/lead_form/lead_form_data';
      apiUrls['dropdownUrl'] =
          '${CommonApi.baseUrl}/lead_form/lead_form_dropdown_data';
      apiUrls['typeUrl'] = '${CommonApi.baseUrl}/lead_form/lead_form_type';
      apiUrls['createUrl'] = '${CommonApi.baseUrl}/lead_form/lead_form_create';
      apiUrls['searchUrl'] =
          '${CommonApi.baseUrl}/lead_form/lead_form_search_data';
      apiUrls['deleteUrl'] = '${CommonApi.baseUrl}/lead_form/lead_form_delete';
      apiUrls['displayUrl'] =
          '${CommonApi.baseUrl}/lead_form/lead_form_display_name';
      apiUrls['updateUrl'] = '${CommonApi.baseUrl}/lead_form/lead_form_edit';
      apiUrls['attributeUrl'] =
          '${CommonApi.baseUrl}/lead_form/display_lead_form_attribute';
      apiUrls['editAttributeURL'] =
          '${CommonApi.baseUrl}/lead_form/display_lead_form_editable';
      break;

    case 'order_customers':
      apiUrls['LsitUrl'] = '${CommonApi.baseUrl}/customer/customer_list_data';
      apiUrls['formUrl'] = '${CommonApi.baseUrl}/customer/customer_form_data';
      apiUrls['dropdownUrl'] =
          '${CommonApi.baseUrl}/customer/customer_dropdown_data';
      apiUrls['typeUrl'] = '${CommonApi.baseUrl}/customer/customer_type_data';
      apiUrls['createUrl'] = '${CommonApi.baseUrl}/customer/customer_create';
      apiUrls['searchUrl'] =
          '${CommonApi.baseUrl}/customer/customer_search_data';
      apiUrls['deleteUrl'] = '${CommonApi.baseUrl}/customer/customer_unlink';
      apiUrls['displayUrl'] =
          '${CommonApi.baseUrl}/customer/customer_display_name_records';
      apiUrls['updateUrl'] = '${CommonApi.baseUrl}/customer/customer_write';
      apiUrls['attributeUrl'] =
          '${CommonApi.baseUrl}/customer/display_name_customer_attribute';
      apiUrls['editAttributeURL'] =
          '${CommonApi.baseUrl}/customer/display_name_customer_editable';
      break;

    case 'lead_register':
      apiUrls['LsitUrl'] =
          '${CommonApi.baseUrl}/lead_register/lead_register_list_data';
      apiUrls['formUrl'] =
          '${CommonApi.baseUrl}/lead_register/lead_register_form';
      apiUrls['dropdownUrl'] =
          '${CommonApi.baseUrl}/lead_register/lead_register_dropdown_data';
      apiUrls['typeUrl'] =
          '${CommonApi.baseUrl}/lead_register/lead_register_type_data';
      apiUrls['createUrl'] =
          '${CommonApi.baseUrl}/lead_register/lead_register_create';
      apiUrls['searchUrl'] =
          '${CommonApi.baseUrl}/lead_register/lead_register_search_data';
      apiUrls['deleteUrl'] =
          '${CommonApi.baseUrl}/lead_register/lead_register_delete';
      apiUrls['displayUrl'] =
          '${CommonApi.baseUrl}/lead_register/lead_register_display_name';
      apiUrls['updateUrl'] =
          '${CommonApi.baseUrl}/lead_register/lead_register_edit';
      apiUrls['attributeUrl'] =
          '${CommonApi.baseUrl}/lead_register/display_lead_register_attribute';
      apiUrls['editAttributeURL'] =
          '${CommonApi.baseUrl}/lead_register/display_lead_register_editable';
      break;

    case 'won':
      apiUrls['LsitUrl'] =
          '${CommonApi.baseUrl}/my_pipeline/lead_register_won_list_data';
      apiUrls['formUrl'] =
          '${CommonApi.baseUrl}/lead_register/lead_register_form';
      apiUrls['dropdownUrl'] =
          '${CommonApi.baseUrl}/lead_register/lead_register_dropdown_data';
      apiUrls['typeUrl'] =
          '${CommonApi.baseUrl}/lead_register/lead_register_type_data';
      apiUrls['createUrl'] =
          '${CommonApi.baseUrl}/lead_register/lead_register_create';
      apiUrls['searchUrl'] =
          '${CommonApi.baseUrl}/lead_register/lead_register_search_data';
      apiUrls['deleteUrl'] =
          '${CommonApi.baseUrl}/lead_register/lead_register_delete';
      apiUrls['displayUrl'] =
          '${CommonApi.baseUrl}/lead_register/lead_register_display_name';
      apiUrls['updateUrl'] =
          '${CommonApi.baseUrl}/lead_register/lead_register_edit';
      apiUrls['attributeUrl'] =
          '${CommonApi.baseUrl}/lead_register/display_lead_register_attribute';
      apiUrls['editAttributeURL'] =
          '${CommonApi.baseUrl}/lead_register/display_lead_register_editable';

      break;
    case 'lost':
      apiUrls['LsitUrl'] =
          '${CommonApi.baseUrl}/my_pipeline/lead_register_lost_list_data';
      apiUrls['formUrl'] =
          '${CommonApi.baseUrl}/lead_register/lead_register_form';
      apiUrls['dropdownUrl'] =
          '${CommonApi.baseUrl}/lead_register/lead_register_dropdown_data';
      apiUrls['typeUrl'] =
          '${CommonApi.baseUrl}/lead_register/lead_register_type_data';
      apiUrls['createUrl'] =
          '${CommonApi.baseUrl}/lead_register/lead_register_create';
      apiUrls['searchUrl'] =
          '${CommonApi.baseUrl}/lead_register/lead_register_search_data';
      apiUrls['deleteUrl'] =
          '${CommonApi.baseUrl}/lead_register/lead_register_delete';
      apiUrls['displayUrl'] =
          '${CommonApi.baseUrl}/lead_register/lead_register_display_name';
      apiUrls['updateUrl'] =
          '${CommonApi.baseUrl}/lead_register/lead_register_edit';
      apiUrls['attributeUrl'] =
          '${CommonApi.baseUrl}/lead_register/display_lead_register_attribute';
      apiUrls['editAttributeURL'] =
          '${CommonApi.baseUrl}/lead_register/display_lead_register_editable';

      break;

    case 'hold':
      apiUrls['LsitUrl'] =
          '${CommonApi.baseUrl}/my_pipeline/lead_register_hold_list_data';
      apiUrls['formUrl'] =
          '${CommonApi.baseUrl}/lead_register/lead_register_form';
      apiUrls['dropdownUrl'] =
          '${CommonApi.baseUrl}/lead_register/lead_register_dropdown_data';
      apiUrls['typeUrl'] =
          '${CommonApi.baseUrl}/lead_register/lead_register_type_data';
      apiUrls['createUrl'] =
          '${CommonApi.baseUrl}/lead_register/lead_register_create';
      apiUrls['searchUrl'] =
          '${CommonApi.baseUrl}/lead_register/lead_register_search_data';
      apiUrls['deleteUrl'] =
          '${CommonApi.baseUrl}/lead_register/lead_register_delete';
      apiUrls['displayUrl'] =
          '${CommonApi.baseUrl}/lead_register/lead_register_display_name';
      apiUrls['updateUrl'] =
          '${CommonApi.baseUrl}/lead_register/lead_register_edit';
      apiUrls['attributeUrl'] =
          '${CommonApi.baseUrl}/lead_register/display_lead_register_attribute';
      apiUrls['editAttributeURL'] =
          '${CommonApi.baseUrl}/lead_register/display_lead_register_editable';

      break;

    ///
    case 'drop':
      apiUrls['LsitUrl'] =
          '${CommonApi.baseUrl}/my_pipeline/lead_register_drop_list_data';
      apiUrls['formUrl'] =
          '${CommonApi.baseUrl}/lead_register/lead_register_form';
      apiUrls['dropdownUrl'] =
          '${CommonApi.baseUrl}/lead_register/lead_register_dropdown_data';
      apiUrls['typeUrl'] =
          '${CommonApi.baseUrl}/lead_register/lead_register_type_data';
      apiUrls['createUrl'] =
          '${CommonApi.baseUrl}/lead_register/lead_register_create';
      apiUrls['searchUrl'] =
          '${CommonApi.baseUrl}/lead_register/lead_register_search_data';
      apiUrls['deleteUrl'] =
          '${CommonApi.baseUrl}/lead_register/lead_register_delete';
      apiUrls['displayUrl'] =
          '${CommonApi.baseUrl}/lead_register/lead_register_display_name';
      apiUrls['updateUrl'] =
          '${CommonApi.baseUrl}/lead_register/lead_register_edit';
      apiUrls['attributeUrl'] =
          '${CommonApi.baseUrl}/lead_register/display_lead_register_attribute';
      apiUrls['editAttributeURL'] =
          '${CommonApi.baseUrl}/lead_register/display_lead_register_editable';

      break;

    ///

    case 'oms_submitted':
      apiUrls['LsitUrl'] =
          '${CommonApi.baseUrl}/oms_status/lead_to_be_approve_list_data';
      apiUrls['formUrl'] =
          '${CommonApi.baseUrl}/lead_register/lead_register_form';
      apiUrls['dropdownUrl'] =
          '${CommonApi.baseUrl}/lead_register/lead_register_dropdown_data';
      apiUrls['typeUrl'] =
          '${CommonApi.baseUrl}/lead_register/lead_register_type_data';
      apiUrls['createUrl'] =
          '${CommonApi.baseUrl}/lead_register/lead_register_create';
      apiUrls['searchUrl'] =
          '${CommonApi.baseUrl}/lead_register/lead_register_search_data';
      apiUrls['deleteUrl'] =
          '${CommonApi.baseUrl}/lead_register/lead_register_delete';
      apiUrls['displayUrl'] =
          '${CommonApi.baseUrl}/lead_register/lead_register_display_name';
      apiUrls['updateUrl'] =
          '${CommonApi.baseUrl}/lead_register/lead_register_edit';
      apiUrls['attributeUrl'] =
          '${CommonApi.baseUrl}/lead_register/display_lead_register_attribute';
      apiUrls['editAttributeURL'] =
          '${CommonApi.baseUrl}/lead_register/display_lead_register_editable';

      break;

    case 'oms_approved':
      apiUrls['LsitUrl'] =
          '${CommonApi.baseUrl}/oms_status/lead_approval_list_data';
      apiUrls['formUrl'] =
          '${CommonApi.baseUrl}/lead_register/lead_register_form';
      apiUrls['dropdownUrl'] =
          '${CommonApi.baseUrl}/lead_register/lead_register_dropdown_data';
      apiUrls['typeUrl'] =
          '${CommonApi.baseUrl}/lead_register/lead_register_type_data';
      apiUrls['createUrl'] =
          '${CommonApi.baseUrl}/lead_register/lead_register_create';
      apiUrls['searchUrl'] =
          '${CommonApi.baseUrl}/lead_register/lead_register_search_data';
      apiUrls['deleteUrl'] =
          '${CommonApi.baseUrl}/lead_register/lead_register_delete';
      apiUrls['displayUrl'] =
          '${CommonApi.baseUrl}/lead_register/lead_register_display_name';
      apiUrls['updateUrl'] =
          '${CommonApi.baseUrl}/lead_register/lead_register_edit';
      apiUrls['attributeUrl'] =
          '${CommonApi.baseUrl}/lead_register/display_lead_register_attribute';
      apiUrls['editAttributeURL'] =
          '${CommonApi.baseUrl}/lead_register/display_lead_register_editable';

      break;
    case 'oms_rejected':
      apiUrls['LsitUrl'] =
          '${CommonApi.baseUrl}/oms_status/lead_rejected_list_data';
      apiUrls['formUrl'] =
          '${CommonApi.baseUrl}/lead_register/lead_register_form';
      apiUrls['dropdownUrl'] =
          '${CommonApi.baseUrl}/lead_register/lead_register_dropdown_data';
      apiUrls['typeUrl'] =
          '${CommonApi.baseUrl}/lead_register/lead_register_type_data';
      apiUrls['createUrl'] =
          '${CommonApi.baseUrl}/lead_register/lead_register_create';
      apiUrls['searchUrl'] =
          '${CommonApi.baseUrl}/lead_register/lead_register_search_data';
      apiUrls['deleteUrl'] =
          '${CommonApi.baseUrl}/lead_register/lead_register_delete';
      apiUrls['displayUrl'] =
          '${CommonApi.baseUrl}/lead_register/lead_register_display_name';
      apiUrls['updateUrl'] =
          '${CommonApi.baseUrl}/lead_register/lead_register_edit';
      apiUrls['attributeUrl'] =
          '${CommonApi.baseUrl}/lead_register/display_lead_register_attribute';
      apiUrls['editAttributeURL'] =
          '${CommonApi.baseUrl}/lead_register/display_lead_register_editable';

      break;

    case 'oms_hold':
      apiUrls['LsitUrl'] =
          '${CommonApi.baseUrl}/oms_status/lead_hold_list_data';
      apiUrls['formUrl'] =
          '${CommonApi.baseUrl}/lead_register/lead_register_form';
      apiUrls['dropdownUrl'] =
          '${CommonApi.baseUrl}/lead_register/lead_register_dropdown_data';
      apiUrls['typeUrl'] =
          '${CommonApi.baseUrl}/lead_register/lead_register_type_data';
      apiUrls['createUrl'] =
          '${CommonApi.baseUrl}/lead_register/lead_register_create';
      apiUrls['searchUrl'] =
          '${CommonApi.baseUrl}/lead_register/lead_register_search_data';
      apiUrls['deleteUrl'] =
          '${CommonApi.baseUrl}/lead_register/lead_register_delete';
      apiUrls['displayUrl'] =
          '${CommonApi.baseUrl}/lead_register/lead_register_display_name';
      apiUrls['updateUrl'] =
          '${CommonApi.baseUrl}/lead_register/lead_register_edit';
      apiUrls['attributeUrl'] =
          '${CommonApi.baseUrl}/lead_register/display_lead_register_attribute';
      apiUrls['editAttributeURL'] =
          '${CommonApi.baseUrl}/lead_register/display_lead_register_editable';

      break;
    case 'cpq_quotations':
      apiUrls['LsitUrl'] =
          "${CommonApi.baseUrl}/quotations/sale_order_list_data";
      apiUrls['formUrl'] = '${CommonApi.baseUrl}/quotations/order_form_data';
      apiUrls['dropdownUrl'] =
          '${CommonApi.baseUrl}/quotations/order_dropdown_data';
      apiUrls['typeUrl'] = '${CommonApi.baseUrl}/quotations/order_sales_type';
      apiUrls['createUrl'] =
          '${CommonApi.baseUrl}/quotations/create_sale_order';
      apiUrls['searchUrl'] =
          '${CommonApi.baseUrl}/quotations/order_search_data';
      apiUrls['deleteUrl'] = '${CommonApi.baseUrl}/quotations/order_unlink';
      apiUrls['displayUrl'] =
          '${CommonApi.baseUrl}/quotations/display_name_order';
      apiUrls['updateUrl'] = '${CommonApi.baseUrl}/quotations/order_write';
      apiUrls['attributeUrl'] =
          '${CommonApi.baseUrl}/quotations/display_name_order_attribute';
      apiUrls['editAttributeURL'] =
          '${CommonApi.baseUrl}/quotations/display_name_order_editable';

      break;

    case 'cpq_invoice':
      apiUrls['LsitUrl'] = "${CommonApi.baseUrl}/invoice/invoice_list_data";
      apiUrls['formUrl'] = '${CommonApi.baseUrl}/invoice/invoice_form_data';
      apiUrls['dropdownUrl'] =
          '${CommonApi.baseUrl}/invoice/invoice_dropdown_data';
      apiUrls['typeUrl'] = '${CommonApi.baseUrl}/invoice/invoice_type';
      apiUrls['createUrl'] = '${CommonApi.baseUrl}/invoice/create_invoice';
      apiUrls['searchUrl'] = '${CommonApi.baseUrl}/invoice/invoice_search_data';
      apiUrls['deleteUrl'] = '${CommonApi.baseUrl}/invoice/invoice_unlink';
      apiUrls['displayUrl'] =
          '${CommonApi.baseUrl}/invoice/display_name_invoice';
      apiUrls['updateUrl'] = '${CommonApi.baseUrl}/invoice/order_write';
      apiUrls['attributeUrl'] =
          '${CommonApi.baseUrl}/invoice/display_name_invoice_attribute';
      apiUrls['editAttributeURL'] =
          '${CommonApi.baseUrl}/invoice/display_name_invoice_editable';

      break;

    case 'customer':
      apiUrls['LsitUrl'] = '${CommonApi.baseUrl}/retail/retail_list_data';
      apiUrls['formUrl'] = '${CommonApi.baseUrl}/retail/retail_form';
      apiUrls['dropdownUrl'] =
          '${CommonApi.baseUrl}/retail/retail_get_app_dropdown_data';
      apiUrls['typeUrl'] = '${CommonApi.baseUrl}/retail/retail_type';
      apiUrls['createUrl'] = '${CommonApi.baseUrl}/retail/create_retail';
      apiUrls['searchUrl'] = '${CommonApi.baseUrl}/retail/retail_search_data';
      apiUrls['deleteUrl'] = '${CommonApi.baseUrl}/retail/retail_unlink';
      apiUrls['displayUrl'] =
          '${CommonApi.baseUrl}/retail/display_name_customer';
      apiUrls['updateUrl'] = '${CommonApi.baseUrl}/retail/retail_write';
      apiUrls['attributeUrl'] =
          '${CommonApi.baseUrl}/retail/display_name_customer_attributes';
      apiUrls['editAttributeURL'] =
          '${CommonApi.baseUrl}/retail/display_name_customer_editable';
      break;

    case 'orders':
      apiUrls['LsitUrl'] = '${CommonApi.baseUrl}/order/order_list_data';
      apiUrls['formUrl'] = '${CommonApi.baseUrl}/order/order_form';
      apiUrls['dropdownUrl'] = '${CommonApi.baseUrl}/order/order_dropdown_data';
      apiUrls['typeUrl'] = '${CommonApi.baseUrl}/order/order_type';
      apiUrls['createUrl'] = '${CommonApi.baseUrl}/order/create_sale_order';
      apiUrls['searchUrl'] = '${CommonApi.baseUrl}/order/order_search_data';
      apiUrls['deleteUrl'] = '${CommonApi.baseUrl}/order/order_unlink';
      apiUrls['displayUrl'] = '${CommonApi.baseUrl}/order/display_name_order';
      apiUrls['updateUrl'] = '${CommonApi.baseUrl}/order/order_write';
      break;

    case 'quotations':
      apiUrls['LsitUrl'] = "${CommonApi.baseUrl}/order/quotation_list_data";
      apiUrls['formUrl'] = '${CommonApi.baseUrl}/order/quotation_form';
      apiUrls['dropdownUrl'] =
          '${CommonApi.baseUrl}/order/get_quotation_dropdown_data';
      apiUrls['typeUrl'] = '${CommonApi.baseUrl}/order/order_type';
      apiUrls['createUrl'] = '${CommonApi.baseUrl}/order/create_sale_quotation';
      apiUrls['searchUrl'] = '${CommonApi.baseUrl}/order/quotation_search_data';
      apiUrls['deleteUrl'] = '${CommonApi.baseUrl}/order/quotation_unlink';
      apiUrls['displayUrl'] = '${CommonApi.baseUrl}/order/display_name_order';
      apiUrls['updateUrl'] = '${CommonApi.baseUrl}/retail/retail_write';
      break;

    case 'my_expenses_to_report':
      apiUrls['LsitUrl'] =
          '${CommonApi.baseUrl}/expenses_report/expenses_list_data';
      apiUrls['formUrl'] = '${CommonApi.baseUrl}/expenses_report/expenses_form';
      apiUrls['dropdownUrl'] =
          '${CommonApi.baseUrl}/expenses_report/expenses_dropdown_data';
      apiUrls['typeUrl'] =
          '${CommonApi.baseUrl}/expenses_report/my_expenses_type';
      apiUrls['createUrl'] =
          '${CommonApi.baseUrl}/expenses_report/create_expenses_report';
      apiUrls['searchUrl'] =
          '${CommonApi.baseUrl}/expenses_report/expenses_search_data';
      apiUrls['deleteUrl'] =
          '${CommonApi.baseUrl}/expenses_report/expenses_unlink';
      apiUrls['displayUrl'] =
          '${CommonApi.baseUrl}/expenses_report/my_expenses_type';
      apiUrls['updateUrl'] =
          '${CommonApi.baseUrl}/expenses_report/expenses_write';
      apiUrls['attributeUrl'] =
          '${CommonApi.baseUrl}/expenses_report/display_name_my_expenses_attribute';
      apiUrls['editAttributeURL'] =
          '${CommonApi.baseUrl}/expenses_report/display_name_my_expenses_editable';
      break;

    case 'all_my_team_expenses':
      //for all team members
      apiUrls['LsitUrl'] =
          '${CommonApi.baseUrl}/expenses_report/expenses_list_data';
      apiUrls['formUrl'] = '${CommonApi.baseUrl}/expenses_report/expenses_form';
      apiUrls['dropdownUrl'] =
          '${CommonApi.baseUrl}/expenses_report/expenses_dropdown_data';
      apiUrls['typeUrl'] =
          '${CommonApi.baseUrl}/expenses_report/my_expenses_type';
      apiUrls['createUrl'] =
          '${CommonApi.baseUrl}/expenses_report/create_expenses_report';
      apiUrls['searchUrl'] =
          '${CommonApi.baseUrl}/expenses_report/expenses_search_data';
      apiUrls['deleteUrl'] =
          '${CommonApi.baseUrl}/expenses_report/expenses_unlink';
      apiUrls['displayUrl'] =
          '${CommonApi.baseUrl}/expenses_report/my_expenses_type';
      apiUrls['updateUrl'] =
          '${CommonApi.baseUrl}/expenses_report/expenses_write';
      apiUrls['attributeUrl'] =
          '${CommonApi.baseUrl}/expenses_report/display_name_my_expenses_attribute';
      apiUrls['editAttributeURL'] =
          '${CommonApi.baseUrl}/expenses_report/display_name_my_expenses_editable';
      break;

    case 'all_my_expenses':
      apiUrls['LsitUrl'] =
          '${CommonApi.baseUrl}/expenses_report/expenses_my_list_data';
      apiUrls['formUrl'] = '${CommonApi.baseUrl}/expenses_report/expenses_form';
      apiUrls['dropdownUrl'] =
          '${CommonApi.baseUrl}/expenses_report/expenses_dropdown_data';
      apiUrls['typeUrl'] =
          '${CommonApi.baseUrl}/expenses_report/my_expenses_type';
      apiUrls['createUrl'] =
          '${CommonApi.baseUrl}/expenses_report/create_expenses_report';
      apiUrls['searchUrl'] =
          '${CommonApi.baseUrl}/expenses_report/my_expenses_search_data';
      apiUrls['deleteUrl'] =
          '${CommonApi.baseUrl}/expenses_report/expenses_unlink';
      apiUrls['displayUrl'] =
          '${CommonApi.baseUrl}/expenses_report/my_expenses_type';
      apiUrls['updateUrl'] =
          '${CommonApi.baseUrl}/expenses_report/expenses_write';
      apiUrls['attributeUrl'] =
          '${CommonApi.baseUrl}/expenses_report/display_name_my_expenses_attribute';
      apiUrls['editAttributeURL'] =
          '${CommonApi.baseUrl}/expenses_report/display_name_my_expenses_editable';
      break;

    case 'my_reports':
      apiUrls['LsitUrl'] = '${CommonApi.baseUrl}/my_report/my_report_list_data';
      apiUrls['formUrl'] = '${CommonApi.baseUrl}/my_report/my_report_form';
      apiUrls['dropdownUrl'] =
          '${CommonApi.baseUrl}/my_report/my_report_dropdown_data';
      apiUrls['typeUrl'] = '${CommonApi.baseUrl}/my_report/my_expenses_type';
      apiUrls['createUrl'] = '${CommonApi.baseUrl}/my_report/create_my_report';
      apiUrls['searchUrl'] =
          '${CommonApi.baseUrl}/my_report/my_report_search_data';
      apiUrls['deleteUrl'] = '${CommonApi.baseUrl}/my_report/my_report_unlink';
      apiUrls['displayUrl'] = '${CommonApi.baseUrl}/my_report/my_expenses_type';
      apiUrls['updateUrl'] = '${CommonApi.baseUrl}/my_report/my_report_write';
      apiUrls['attributeUrl'] =
          '${CommonApi.baseUrl}/my_report/display_name_my_report_attribute';
      apiUrls['editAttributeURL'] =
          '${CommonApi.baseUrl}/my_report/display_name_my_report_editable';

      break;

    case 'my_team_reports':
      apiUrls['LsitUrl'] =
          '${CommonApi.baseUrl}/my_report/all_my_report_list_data';
      apiUrls['formUrl'] = '${CommonApi.baseUrl}/my_report/my_report_form';
      apiUrls['dropdownUrl'] =
          '${CommonApi.baseUrl}/my_report/my_report_manager_dropdown_data';
      apiUrls['typeUrl'] = '${CommonApi.baseUrl}/my_report/my_expenses_type';
      apiUrls['createUrl'] = '${CommonApi.baseUrl}/my_report/create_my_report';
      apiUrls['searchUrl'] =
          '${CommonApi.baseUrl}/my_report/all_my_report_search_data';
      apiUrls['deleteUrl'] = '${CommonApi.baseUrl}/my_report/my_report_unlink';
      apiUrls['displayUrl'] = '${CommonApi.baseUrl}/my_report/my_expenses_type';
      apiUrls['updateUrl'] = '${CommonApi.baseUrl}/my_report/my_report_write';
      apiUrls['attributeUrl'] =
          '${CommonApi.baseUrl}/my_report/display_name_my_report_attribute';
      apiUrls['editAttributeURL'] =
          '${CommonApi.baseUrl}/my_report/display_name_my_report_editable';

      break;

    case 'expense_approval':
      apiUrls['LsitUrl'] =
          '${CommonApi.baseUrl}/my_report/report_submit_list_data';
      apiUrls['formUrl'] = '${CommonApi.baseUrl}/my_report/my_report_form';
      apiUrls['dropdownUrl'] =
          '${CommonApi.baseUrl}/my_report/my_report_manager_dropdown_data';
      apiUrls['typeUrl'] = '${CommonApi.baseUrl}/my_report/my_expenses_type';
      apiUrls['createUrl'] =
          '${CommonApi.baseUrl}/my_report/report_submit_to_approved';
      apiUrls['searchUrl'] =
          '${CommonApi.baseUrl}/my_report/all_my_report_search_data';
      apiUrls['deleteUrl'] = '${CommonApi.baseUrl}/my_report/my_report_unlink';
      apiUrls['displayUrl'] = '${CommonApi.baseUrl}/my_report/my_expenses_type';
      apiUrls['updateUrl'] =
          '${CommonApi.baseUrl}/my_report/report_submit_to_approved';
      apiUrls['attributeUrl'] =
          '${CommonApi.baseUrl}/my_report/display_name_my_report_attribute';
      apiUrls['editAttributeURL'] =
          '${CommonApi.baseUrl}/my_report/display_name_my_report_editable';

      break;

    case 'visit_schedule':
      apiUrls['LsitUrl'] =
          '${CommonApi.baseUrl}/visitmanagement/visit_management_my_list_data';
      apiUrls['formUrl'] =
          '${CommonApi.baseUrl}/visitmanagement/visit_management_form';
      apiUrls['dropdownUrl'] =
          '${CommonApi.baseUrl}/visitmanagement/visitmanagement_dropdown_data';
      apiUrls['typeUrl'] =
          '${CommonApi.baseUrl}/visitmanagement/visit_management_type';
      apiUrls['createUrl'] =
          '${CommonApi.baseUrl}/visitmanagement/create_visit_management';
      apiUrls['searchUrl'] =
          '${CommonApi.baseUrl}/visitmanagement/visit_management_my_search_data';
      apiUrls['deleteUrl'] =
          '${CommonApi.baseUrl}/visitmanagement/visit_management_unlink';
      apiUrls['displayUrl'] =
          '${CommonApi.baseUrl}/visitmanagement/display_name_visit_management';
      apiUrls['many2manyUrl'] =
          '${CommonApi.baseUrl}/visitmanagement/visit_schedule_many2many_data';
      apiUrls['updateUrl'] =
          '${CommonApi.baseUrl}/visitmanagement/visit_management_write';
      apiUrls['attributeUrl'] =
          '${CommonApi.baseUrl}/visitmanagement/display_name_visit_management_attribute';
      apiUrls['editAttributeURL'] =
          '${CommonApi.baseUrl}/visitmanagement/display_name_visit_management_editable';
      break;

    case 'team_visit_schedule':
      apiUrls['LsitUrl'] =
          '${CommonApi.baseUrl}/visitmanagement/visit_management_list_data';
      apiUrls['formUrl'] =
          '${CommonApi.baseUrl}/visitmanagement/visit_management_form';
      apiUrls['dropdownUrl'] =
          '${CommonApi.baseUrl}/visitmanagement/visitmanagement_dropdown_data';
      apiUrls['typeUrl'] =
          '${CommonApi.baseUrl}/visitmanagement/visit_management_type';
      apiUrls['createUrl'] =
          '${CommonApi.baseUrl}/visitmanagement/create_visit_management';
      apiUrls['searchUrl'] =
          '${CommonApi.baseUrl}/visitmanagement/visit_management_search_data';
      apiUrls['deleteUrl'] =
          '${CommonApi.baseUrl}/visitmanagement/visit_management_unlink';
      apiUrls['displayUrl'] =
          '${CommonApi.baseUrl}/visitmanagement/display_name_visit_management';
      apiUrls['many2manyUrl'] =
          '${CommonApi.baseUrl}/visitmanagement/visit_schedule_many2many_data';
      apiUrls['updateUrl'] =
          '${CommonApi.baseUrl}/visitmanagement/visit_management_write';
      apiUrls['attributeUrl'] =
          '${CommonApi.baseUrl}/visitmanagement/display_name_visit_management_attribute';
      apiUrls['editAttributeURL'] =
          '${CommonApi.baseUrl}/visitmanagement/display_name_visit_management_editable';
      break;

    case 'target':
      apiUrls['LsitUrl'] = '${CommonApi.baseUrl}/target/target_list_data';
      apiUrls['formUrl'] = '${CommonApi.baseUrl}/target/sales_target_form';
      apiUrls['dropdownUrl'] =
          '${CommonApi.baseUrl}/target/target_dropdown_data';
      apiUrls['typeUrl'] = '${CommonApi.baseUrl}/target/sale_target_type';
      apiUrls['createUrl'] = '${CommonApi.baseUrl}/target/create_sale_target';
      apiUrls['searchUrl'] = '${CommonApi.baseUrl}/target/target_search_data';
      apiUrls['deleteUrl'] = '${CommonApi.baseUrl}/target/sale_target_unlink';
      apiUrls['displayUrl'] = '${CommonApi.baseUrl}/target/display_name_target';
      apiUrls['updateUrl'] = '${CommonApi.baseUrl}/target/sale_target_write';
      break;

    case 'team_tour_plan':
      apiUrls['LsitUrl'] = '${CommonApi.baseUrl}/tourplan/tourplan_list_data';
      apiUrls['formUrl'] = '${CommonApi.baseUrl}/tourplan/tour_plan_form';
      apiUrls['dropdownUrl'] =
          '${CommonApi.baseUrl}/tourplan/tourplan_dropdown_data';
      apiUrls['typeUrl'] = '${CommonApi.baseUrl}/tourplan/tour_plan_type';
      apiUrls['createUrl'] = '${CommonApi.baseUrl}/tourplan/create_tour_plan';
      apiUrls['searchUrl'] =
          '${CommonApi.baseUrl}/tourplan/tour_plan_search_data';
      apiUrls['deleteUrl'] = '${CommonApi.baseUrl}/tourplan/tourplan_unlink';
      apiUrls['displayUrl'] =
          '${CommonApi.baseUrl}/tourplan/display_name_tourplan';
      apiUrls['many2manyUrl'] =
          '${CommonApi.baseUrl}/tourplan/tourplan_many2many_data';
      apiUrls['updateUrl'] = '${CommonApi.baseUrl}/tourplan/tourplan_write';
      apiUrls['attributeUrl'] =
          '${CommonApi.baseUrl}/tourplan/display_name_tourplan_attribute_new';
      apiUrls['editAttributeURL'] =
          '${CommonApi.baseUrl}/tourplan/display_name_tourplan_editable';
      break;

    case 'tour_plan':
      apiUrls['LsitUrl'] =
          '${CommonApi.baseUrl}/tourplan/tourplan_my_list_data';
      apiUrls['formUrl'] = '${CommonApi.baseUrl}/tourplan/tour_plan_form';
      apiUrls['dropdownUrl'] =
          '${CommonApi.baseUrl}/tourplan/tourplan_dropdown_data';
      apiUrls['typeUrl'] = '${CommonApi.baseUrl}/tourplan/tour_plan_type';
      apiUrls['createUrl'] = '${CommonApi.baseUrl}/tourplan/create_tour_plan';
      apiUrls['searchUrl'] =
          '${CommonApi.baseUrl}/tourplan/tour_plan_my_search_data';
      apiUrls['deleteUrl'] = '${CommonApi.baseUrl}/tourplan/tourplan_unlink';
      apiUrls['displayUrl'] =
          '${CommonApi.baseUrl}/tourplan/display_name_tourplan';
      apiUrls['many2manyUrl'] =
          '${CommonApi.baseUrl}/tourplan/tourplan_many2many_data';
      apiUrls['updateUrl'] = '${CommonApi.baseUrl}/tourplan/tourplan_write';
      apiUrls['attributeUrl'] =
          '${CommonApi.baseUrl}/tourplan/display_name_tourplan_attribute_new';
      apiUrls['editAttributeURL'] =
          '${CommonApi.baseUrl}/tourplan/display_name_tourplan_editable';
      break;

    case 'team_visits':
      apiUrls['LsitUrl'] =
          '${CommonApi.baseUrl}/visit/visit_management_list_data';
      apiUrls['formUrl'] = '${CommonApi.baseUrl}/visit/visit_form';
      apiUrls['typeUrl'] = '${CommonApi.baseUrl}/visit/visit_type';
      apiUrls['dropdownUrl'] = '${CommonApi.baseUrl}/visit/visit_dropdown_data';
      apiUrls['createUrl'] = '${CommonApi.baseUrl}/visit/create_visit';
      apiUrls['searchUrl'] = '${CommonApi.baseUrl}/visit/visit_search_data';
      apiUrls['deleteUrl'] = '${CommonApi.baseUrl}/visit/visit_unlink';
      apiUrls['displayUrl'] = '${CommonApi.baseUrl}/visit/display_name_visit';
      apiUrls['updateUrl'] = '${CommonApi.baseUrl}/visit/visit_write';
      apiUrls['attributeUrl'] =
          '${CommonApi.baseUrl}/visit/display_name_visit_attribute';
      apiUrls['editAttributeURL'] =
          '${CommonApi.baseUrl}/visit/display_name_visit_editable';
      break;

    case 'visits':
      apiUrls['LsitUrl'] = '${CommonApi.baseUrl}/visit/visit_my_list_data';
      apiUrls['formUrl'] = '${CommonApi.baseUrl}/visit/visit_form';
      apiUrls['typeUrl'] = '${CommonApi.baseUrl}/visit/visit_type';
      apiUrls['dropdownUrl'] = '${CommonApi.baseUrl}/visit/visit_dropdown_data';
      apiUrls['createUrl'] = '${CommonApi.baseUrl}/visit/create_visit';
      apiUrls['searchUrl'] = '${CommonApi.baseUrl}/visit/visit_my_search_data';
      apiUrls['deleteUrl'] = '${CommonApi.baseUrl}/visit/visit_unlink';
      apiUrls['displayUrl'] = '${CommonApi.baseUrl}/visit/display_name_visit';
      apiUrls['updateUrl'] = '${CommonApi.baseUrl}/visit/visit_write';
      apiUrls['attributeUrl'] =
          '${CommonApi.baseUrl}/visit/display_name_visit_attribute';
      apiUrls['editAttributeURL'] =
          '${CommonApi.baseUrl}/visit/display_name_visit_editable';
      break;

    case 'profile':
      apiUrls['profileURL'] = '${CommonApi.baseUrl}/employee_pro/employee_form';
      break;

    case 'sales_reschedule':
      apiUrls['LsitUrl'] =
          '${CommonApi.baseUrl}/sales_service/reschedule_sales_list_data';
      apiUrls['formUrl'] =
          '${CommonApi.baseUrl}/sales_service/reschedule_reassign_sales_form_view';
      apiUrls['dropdownUrl'] =
          '${CommonApi.baseUrl}/sales_service/sales_service_dropdown_data';
      apiUrls['typeUrl'] = '${CommonApi.baseUrl}/sales_service/sales_type';
      apiUrls['searchUrl'] =
          '${CommonApi.baseUrl}/sales_service/sales_reschedule_search_data';
      apiUrls['displayUrl'] =
          '${CommonApi.baseUrl}/sales_service/display_name_sales';
      apiUrls['updateUrl'] =
          '${CommonApi.baseUrl}/sales_service/sales_reschedule_approve_button';
      apiUrls['attributeUrl'] =
          '${CommonApi.baseUrl}/sales_service/display_name_sales';
      apiUrls['editAttributeURL'] =
          '${CommonApi.baseUrl}/sales_service/display_name_sales';
      break;

    case 'sales_reassign':
      apiUrls['LsitUrl'] =
          '${CommonApi.baseUrl}/sales_service/reassign_sales_list_data';
      apiUrls['formUrl'] =
          '${CommonApi.baseUrl}/sales_service/reschedule_reassign_sales_form_view';
      apiUrls['dropdownUrl'] =
          '${CommonApi.baseUrl}/sales_service/sales_service_dropdown_data';
      apiUrls['typeUrl'] = '${CommonApi.baseUrl}/sales_service/sales_type';
      apiUrls['searchUrl'] =
          '${CommonApi.baseUrl}/sales_service/sales_reassign_search_data';
      apiUrls['displayUrl'] =
          '${CommonApi.baseUrl}/sales_service/display_name_sales';
      apiUrls['updateUrl'] =
          '${CommonApi.baseUrl}/sales_service/sales_reassign_approve_button';
      apiUrls['attributeUrl'] =
          '${CommonApi.baseUrl}/sales_service/display_name_customer_attributes';
      apiUrls['editAttributeURL'] =
          '${CommonApi.baseUrl}/sales_service/display_name_customer_editable';
      break;

    case 'service_reassign':
      apiUrls['LsitUrl'] =
          '${CommonApi.baseUrl}/sales_service/reassign_service_list_data';
      apiUrls['formUrl'] =
          '${CommonApi.baseUrl}/sales_service/reschedule_reassign_service_form_view';
      apiUrls['dropdownUrl'] =
          '${CommonApi.baseUrl}/sales_service/sales_service_dropdown_data';
      apiUrls['typeUrl'] = '${CommonApi.baseUrl}/sales_service/service_type';

      apiUrls['searchUrl'] =
          '${CommonApi.baseUrl}/sales_service/service_reassign_search_data';

      apiUrls['displayUrl'] =
          '${CommonApi.baseUrl}/sales_service/display_name_service';
      apiUrls['updateUrl'] =
          '${CommonApi.baseUrl}/sales_service/service_reassign_approve_button';
      apiUrls['attributeUrl'] =
          '${CommonApi.baseUrl}/sales_service/display_name_service';
      apiUrls['editAttributeURL'] =
          '${CommonApi.baseUrl}/sales_service/display_name_service';
      break;

    case 'service_reschedule':
      apiUrls['LsitUrl'] =
          '${CommonApi.baseUrl}/sales_service/reschedule_service_list_data';
      apiUrls['formUrl'] =
          '${CommonApi.baseUrl}/sales_service/reschedule_reassign_service_form_view';
      apiUrls['dropdownUrl'] =
          '${CommonApi.baseUrl}/sales_service/sales_service_dropdown_data';
      apiUrls['typeUrl'] = '${CommonApi.baseUrl}/sales_service/service_type';

      apiUrls['searchUrl'] =
          '${CommonApi.baseUrl}/sales_service/service_reschedule_search_data';

      apiUrls['displayUrl'] =
          '${CommonApi.baseUrl}/sales_service/display_name_service';
      apiUrls['updateUrl'] =
          '${CommonApi.baseUrl}/sales_service/service_reschedule_approve_button';
      apiUrls['attributeUrl'] =
          '${CommonApi.baseUrl}/sales_service/display_name_service';
      apiUrls['editAttributeURL'] =
          '${CommonApi.baseUrl}/sales_service/display_name_service';
      break;

    default:
      apiUrls['LsitUrl'] =
          '${CommonApi.baseUrl}/visitmanagement/visit_management_list_data';
      apiUrls['formUrl'] =
          '${CommonApi.baseUrl}/visitmanagement/visit_management_form';
      apiUrls['dropdownUrl'] =
          '${CommonApi.baseUrl}/visitmanagement/visitmanagement_dropdown_data';
      apiUrls['typeUrl'] =
          '${CommonApi.baseUrl}/visitmanagement/visit_management_type';
      apiUrls['createUrl'] =
          '${CommonApi.baseUrl}/visitmanagement/create_visit_management';
      apiUrls['searchUrl'] =
          '${CommonApi.baseUrl}/visitmanagement/visit_management_search_data';
      apiUrls['deleteUrl'] =
          '${CommonApi.baseUrl}/visitmanagement/visit_management_unlink';
      apiUrls['displayUrl'] =
          '${CommonApi.baseUrl}/visitmanagement/display_name_visit_management';
      apiUrls['many2manyUrl'] =
          '${CommonApi.baseUrl}/visitmanagement/visit_schedule_many2many_data';
      apiUrls['updateUrl'] =
          '${CommonApi.baseUrl}/visitmanagement/visit_management_write';
      apiUrls['attributeUrl'] =
          '${CommonApi.baseUrl}/visitmanagement/display_name_visit_management_attribute';
      apiUrls['editAttributeURL'] =
          '${CommonApi.baseUrl}/visitmanagement/display_name_visit_management_editable';
      break;
  }
  return apiUrls;
}
