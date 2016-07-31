module RedmineFinance
  module Hooks
    class ViewsInvoicesHook < Redmine::Hook::ViewListener
      render_on :view_invoices_show_lines_bottom, :partial => "operation_invoices/operations"
    end
  end
end