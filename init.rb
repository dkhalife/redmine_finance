FINANCE_VERSION_NUMBER = '2.1.0'
# <PRO>
FINANCE_VERSION_TYPE = "PRO version"
# </PRO>
# <LIGHT/> FINANCE_VERSION_TYPE = "Light version"

Redmine::Plugin.register :redmine_finance do
  name "Redmine Finance plugin (#{FINANCE_VERSION_TYPE})"
  author 'RedmineCRM'
  description 'This is a accounting plugin for Redmine'
  version FINANCE_VERSION_NUMBER
  url 'http://redminecrm.com/projects/finance'
  author_url 'mailto:support@redminecrm.com'

  requires_redmine :version_or_higher => '2.3'
  begin
    requires_redmine_plugin :redmine_contacts, :version_or_higher => '4.0.4'
  rescue Redmine::PluginNotFound  => e
    raise "Please install redmine_contacts plugin"
  end

  settings :default => {
    :show_in_top_menu => "1"
  }, :partial => 'settings/finance'

  project_module :finance do
    permission :view_finances, :operations => [:index, :show, :context_menu], :accounts => [:index, :show, :context_menu]

    permission :add_operations, :operations => [:new, :create]
    permission :edit_operations, :operations => [:edit, :update, :bulk_update]
    permission :edit_own_operations, :operations => [:new, :create, :edit, :update, :delete]
    permission :delete_operations, :operations => [:destroy, :bulk_destroy]
    permission :comment_operations, {:operation_comments => :create}
    permission :delete_operation_comments, {:operation_comments => :destroy}
    # <PRO>
    permission :manage_operation_invoices, :operation_invoices => [:create, :destroy]
    permission :manage_operation_relations, :operation_relations => [:create, :destroy]
    permission :import_operations, {:operation_imports => [:new, :create]}
    permission :approve_operations, {}
    permission :manage_public_operations_queries, {}, :require => :member
    permission :save_operations_queries, {}, :require => :loggedin
    # </PRO>
    permission :edit_accounts, :accounts => [:new, :create, :edit, :update, :bulk_update]
    permission :delete_accounts, :accounts => [:destroy, :bulk_destroy]

  end

  menu :admin_menu, :finance, {:controller => 'settings', :action => 'plugin', :id => "redmine_finance"}, :caption => :label_finance
  menu :top_menu, :finance, {:controller => 'operations', :action => 'index', :project_id => nil}, :caption => :label_finance, :if => Proc.new {
    User.current.allowed_to?({:controller => 'operations', :action => 'index'}, nil, {:global => true}) && RedmineFinance.settings[:show_in_top_menu].to_i > 0
  }
  menu :application_menu, :finance,
                          {:controller => 'operations', :action => 'index'},
                          :caption => :label_finance_plural,
                          :param => :project_id,
                          :if => Proc.new{User.current.allowed_to?({:controller => 'operations', :action => 'index'},
                                          nil, {:global => true}) && RedmineFinance.settings[:show_in_app_menu].to_i > 0}

  menu :project_menu, :operations, {:controller => 'operations', :action => 'index'}, :caption => :label_finance_plural, :param => :project_id

  activity_provider :finances, :default => false, :class_name => ['Operation']

  # <PRO>
  Redmine::Search.map do |search|
    search.register :operations
  end
  # </PRO>

end

require 'redmine_finance'
