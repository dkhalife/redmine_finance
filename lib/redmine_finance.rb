Rails.configuration.to_prepare do
  require 'redmine_finance/patches/project_patch'
  require 'redmine_finance/patches/contact_patch'
  require 'redmine_finance/patches/projects_helper_patch'
  require 'redmine_finance/patches/notifiable_patch'
  require 'redmine_finance/patches/queries_helper_patch'
  # <PRO>
  require 'redmine_finance/patches/custom_fields_helper_patch'
  require 'redmine_finance/hooks/view_invoices_hook'
  require 'redmine_finance/hooks/views_custom_fields_hook'
  # </PRO>
  require 'redmine_finance/hooks/view_layouts_hook'
  require 'redmine_finance/hooks/controller_contacts_duplicates_hook'
end


module RedmineFinance

  def self.settings() Setting[:plugin_redmine_finance].blank? ? {} : Setting[:plugin_redmine_finance]  end


  def self.available_locales
    Dir.glob(File.join(Redmine::Plugin.find(:redmine_finance).directory, 'config', 'locales', '*.yml')).collect {|f| File.basename(f).split('.').first}.collect(&:to_sym)
    # [:en, :de, :fr, :ru]
  end

  def self.invoices_plugin_installed?
    @@invoices_plugin_installed ||= (Redmine::Plugin.installed?(:redmine_contacts_invoices) && Redmine::Plugin.find(:redmine_contacts_invoices).version > "2.1" )
  end

  def self.operations_approval?
    # <PRO>
    Setting.plugin_redmine_finance["finance_operations_approval"].to_i > 0
    # </PRO>
    # <LIGHT/>false
  end


  module Hooks
    class ViewLayoutsBaseHook < Redmine::Hook::ViewListener
      render_on :view_layouts_base_html_head, :inline => "<%= stylesheet_link_tag :finance, :plugin => 'redmine_finance' %>"
    end
  end

end