require File.expand_path('../../test_helper', __FILE__)

class OperationCategoriesControllerTest < ActionController::TestCase
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
    @request.session[:user_id] = 1
    Project.find(1).enable_module!(:finance)
  end

  def test_should_get_new
    get :new
    assert_response :success
    assert_template :new
    assert_not_nil assigns(:category)
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
    assert_template :edit
    assert_not_nil assigns(:category)
  end

  def test_should_put_update
    put :update, :id => 1, :operation_category => {:name => "Changed category name"}
    assert_response :redirect
    assert_equal "Changed category name", OperationCategory.find(1).name
  end

  def test_should_post_create
    post :create, :operation_category => { :name => "New category name", :code => 'test_code', :parent_id => nil }
    assert_response :redirect
    assert_equal "New category name", OperationCategory.last.name
    assert_equal 'test_code', OperationCategory.last.code
  end

  def test_destroy_category_not_in_use
    new_category = OperationCategory.create(:name => "Destroyable", :is_income => false)
    assert_difference 'OperationCategory.count', -1 do
      delete :destroy, :id => new_category.id
    end
    assert_redirected_to '/settings/plugin/redmine_finance?tab=operation_categories'
  end

  def test_destroy_category_in_use
    assert_not_nil Operation.where(:category_id => 1)
    assert_nil Operation.where(:category_id => 3).first

    delete :destroy, :id => '1', :todo => 'reassign', :reassign_to_id => 3

    assert_nil OperationCategory.where(:id => 1).first
    assert_not_nil Operation.where(:category_id => 3)
    assert_nil Operation.where(:category_id => 1).first
    assert_redirected_to '/settings/plugin/redmine_finance?tab=operation_categories'
  end

end
