require_dependency 'custom_fields_helper'

module RedmineFinance
  module Patches

    module CustomFieldsHelperPatch
      def self.included(base) # :nodoc:
        base.send(:include, InstanceMethods)

        base.class_eval do
          alias_method_chain :custom_fields_tabs, :finance_tab
        end
      end

      module InstanceMethods
        # Adds a rates tab to the user administration page
        def custom_fields_tabs_with_finance_tab
          tabs = custom_fields_tabs_without_finance_tab
          tabs << {:name => 'OperationCustomField', :partial => 'custom_fields/index', :label => :label_operation_plural}
          tabs << {:name => 'AccountCustomField', :partial => 'custom_fields/index', :label => :label_account_plural}
          return tabs
        end
      end

    end

  end
end

if Redmine::VERSION.to_s > '2.5'
  CustomFieldsHelper::CUSTOM_FIELDS_TABS << {:name => 'OperationCustomField', :partial => 'custom_fields/index', :label => :label_operation_plural}
  CustomFieldsHelper::CUSTOM_FIELDS_TABS << {:name => 'AccountCustomField', :partial => 'custom_fields/index', :label => :label_account_plural}
else
  unless CustomFieldsHelper.included_modules.include?(RedmineFinance::Patches::CustomFieldsHelperPatch)
    CustomFieldsHelper.send(:include, RedmineFinance::Patches::CustomFieldsHelperPatch)
  end
end