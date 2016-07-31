module RedmineFinance
  module Hooks
    class ViewsCustomFieldsHook < Redmine::Hook::ViewListener
      render_on :view_custom_fields_form_operation_custom_field, :partial => "operations/custom_field_form"
    end
  end
end