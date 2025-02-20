require File.expand_path('../../test_helper', __FILE__)

class AccountsControllerTest < ActionController::TestCase
  include RedmineFinance::TestCase::TestHelper

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
  end

  def test_should_get_index
    @request.session[:user_id] = 1
    get :index
    assert_response :success
    assert_template :index
    assert_not_nil assigns(:accounts)
    assert_nil assigns(:project)
  end

  def test_should_get_show
    @request.session[:user_id] = 1
    get :show, :id => 1
    assert_response :success
    assert_template :show
    assert_not_nil assigns(:account)
    assert_not_nil assigns(:project)
  end

  def test_should_get_new
    @request.session[:user_id] = 1
    get :new, :project_id => 1
    assert_response :success
    assert_template :new
    assert_not_nil assigns(:account)
    assert_not_nil assigns(:project)
  end

  def test_should_get_edit
    @request.session[:user_id] = 1
    get :edit, :id => 1
    assert_response :success
    assert_template :edit
    assert_not_nil assigns(:account)
    assert_not_nil assigns(:project)
  end

  def test_should_put_update
    @request.session[:user_id] = 1
    put :update, :id => 1, :account => {:name => "Changed account name"}
    assert_response :redirect
    assert_equal "Changed account name", Account.find(1).name
  end

  def test_should_post_create
    @request.session[:user_id] = 1
    post :create, :project_id => 1, :account => {:name => "New account name", :currency => 'USD'}
    assert_response :redirect
    assert_equal "New account name", Account.last.name
  end

   def test_should_not_change_amount
    with_finance_settings 'finance_operations_approval' => 0 do
      @request.session[:user_id] = 1
      put :update, :id => 1, :account => {:name => "Changed account name", :amount => 10}
      assert_response :redirect
      assert_equal "Changed account name", Account.find(1).name
      assert_equal 30.0, Account.find(1).amount.to_f
    end
  end

  def test_destroy
    @request.session[:user_id] = 1
    account = Account.create!(:name => 'Destroyable', :currency => 'USD', :project_id => 1)
    assert_difference 'Account.count', -1 do
      delete :destroy, :id => account.id
    end
    assert_redirected_to :action => 'index', :project_id => 'ecookbook'
    assert_nil flash[:error]
  end

  def test_destroy_tracker_in_use
    @request.session[:user_id] = 1
    assert_no_difference 'Account.count' do
      delete :destroy, :id => 1
    end
    assert_redirected_to :action => 'index', :project_id => 'ecookbook'
    assert_not_nil flash[:error]
  end

end
