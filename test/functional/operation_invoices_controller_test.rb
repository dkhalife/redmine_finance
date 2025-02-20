require File.expand_path('../../test_helper', __FILE__)

class OperationInvoicesControllerTest < ActionController::TestCase
  fixtures :projects,
           :users,
           :roles,
           :members,
           :member_roles,
           :issues,
           :issue_statuses,
           :versions,
           :trackers,
           :projects_trackers,
           :issue_categories,
           :enabled_modules,
           :enumerations,
           :attachments,
           :workflows,
           :custom_fields,
           :custom_values,
           :custom_fields_projects,
           :custom_fields_trackers,
           :time_entries,
           :journals,
           :journal_details,
           :queries

  RedmineFinance::TestCase.create_fixtures(Redmine::Plugin.find(:redmine_contacts).directory + '/test/fixtures/', [:contacts,
                                                                                                                   :contacts_projects,
                                                                                                                   :contacts_issues,
                                                                                                                   :deals,
                                                                                                                   :notes,
                                                                                                                   :tags,
                                                                                                                   :taggings,
                                                                                                                   :queries])
  if RedmineFinance.invoices_plugin_installed?
    RedmineFinance::TestCase.create_fixtures(Redmine::Plugin.find(:redmine_contacts_invoices).directory + '/test/fixtures/', [:invoices,
                                                                                                                              :invoice_lines])
  end

  RedmineFinance::TestCase.create_fixtures(Redmine::Plugin.find(:redmine_finance).directory + '/test/fixtures/', [:accounts,
                                                                                                                  :operations,
                                                                                                                  :operation_categories])

  def setup
    Project.find(1).enable_module!(:finance)
    Project.find(1).enable_module!(:contacts_invoices) if RedmineFinance.invoices_plugin_installed?
    @request.env['HTTP_REFERER'] = 'http://test.host'
  end

  def test_should_post_create
    @request.session[:user_id] = 1
    assert_difference 'OperationObject.count', 1 do
      post :create, :operation_id => 1, :operation_object => {:operationable_id => 1}
    end
    assert_redirected_to :controller => 'operations', :action => 'show', :id => 1
    assert_equal 1, Operation.find(1).invoices.last.id
  end

  def test_should_post_create_xhr
    @request.session[:user_id] = 1
    assert_difference 'OperationObject.count', 1 do
      xhr :post, :create, :operation_id => 1, :operation_object => {:operationable_id => 1}
    end
    assert_response :success
    assert_equal 1, Operation.find(1).invoices.last.id
  end

  def test_should_destroy
    @request.session[:user_id] = 1
    operation_invoice = OperationObject.create(:operation_id => 1, :operationable_id => 1, :operationable_type => "Invoice")
    assert_difference 'OperationObject.count', -1 do
      delete :destroy, :operation_id => 1, :object_id => 1, :id => operation_invoice.id
    end
    assert_response :redirect
  end

  def test_should_destroy_xhr
    @request.session[:user_id] = 1
    operation_invoice = OperationObject.create(:operation_id => 1, :operationable_id => 1, :operationable_type => "Invoice")
    assert_difference 'OperationObject.count', -1 do
      xhr :delete, :destroy, :operation_id => 1, :object_id => 1, :id => operation_invoice.id
    end
    assert_response :success
  end
end if RedmineFinance.invoices_plugin_installed?
