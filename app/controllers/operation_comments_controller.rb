class OperationCommentsController < ApplicationController
  unloadable
  default_search_scope :operations
  model_object Operation
  before_filter :find_model_object
  before_filter :find_project_from_association
  before_filter :authorize
  after_filter :send_notification, :only => :create

  def create
    raise Unauthorized unless @operation.commentable?

    @comment = Comment.new
    @comment.safe_attributes = params[:comment]
    @comment.author = User.current
    if @operation.comments << @comment
      flash[:notice] = l(:label_comment_added)
    end

    redirect_to :controller => 'operations', :action => 'show', :id => @operation
  end

  def destroy
    @operation.comments.find(params[:comment_id]).destroy
    redirect_to :controller => 'operations', :action => 'show', :id => @operation
  end

  private

  # ApplicationController's find_model_object sets it based on the controller
  # name so it needs to be overriden and set to @operation instead
  def find_model_object
    super
    @operation = @object
    @comment = nil
    @operation
  end

  def send_notification
    if Setting.notified_events.include?('finance_operation_comment_added')
      FinanceMailer.operation_comment_added(@comment).deliver
    end
  end

end
