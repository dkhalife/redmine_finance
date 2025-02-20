require File.expand_path('../../test_helper', __FILE__)

class OperationCommentsControllerTest < ActionController::TestCase
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
                                                                                                                  :comments,
                                                                                                                  :operation_categories])

  def setup
    Project.find(1).enable_module!(:finance)
  end

  def test_should_destroy
    @request.session[:user_id] = 1
    assert_not_nil Comment.find(3)
    assert_difference 'Comment.count', -1 do
      delete :destroy, :id => 1, :comment_id => 3
    end
    assert_response :redirect
  end

  def test_should_post_create
    @request.session[:user_id] = 1
    post :create, :id => 1, :comment => { :comments => 'This is a test operation comment' }
    assert_redirected_to '/operations/1'

    comment = Operation.find(1).comments.last
    assert_not_nil comment
    assert_equal 'This is a test operation comment', comment.comments
    assert_equal User.find(1), comment.author

  end

end
