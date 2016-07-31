require File.expand_path('../../test_helper', __FILE__)

class OperationRelationsControllerTest < ActionController::TestCase
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
    @request.env['HTTP_REFERER'] = 'http://test.host'
  end

  def test_should_post_create
    @request.session[:user_id] = 1
    assert_difference 'OperationRelation.count', 1 do
      post :create, :operation_id => 1, :relation => {:destination_id => 2}
    end
    assert_redirected_to :controller => 'operations', :action => 'show', :id => 1
    assert_equal 2, Operation.find(1).relation_sources.last.operation_destination.id
  end

  def test_should_post_create_xhr
    @request.session[:user_id] = 1
    assert_difference 'OperationRelation.count', 1 do
      xhr :post, :create, :operation_id => 1, :relation => {:destination_id => 2}
    end
    assert_response :success
    assert_equal 2, Operation.find(1).relation_sources.last.operation_destination.id
  end

  def test_should_destroy
    @request.session[:user_id] = 1
    operation_relation = OperationRelation.create(:source_id => 1, :destination_id => 2, :relation_type => "0")
    assert_difference 'OperationRelation.count', -1 do
      delete :destroy, :id => operation_relation.id
    end
    assert_response :redirect
  end

  def test_should_destroy_xhr
    @request.session[:user_id] = 1
    operation_relation = OperationRelation.create(:source_id => 1, :destination_id => 2, :relation_type => "0")
    assert_difference 'OperationRelation.count', -1 do
      xhr :delete, :destroy, :id => operation_relation.id
    end
    assert_response :success
  end

end
