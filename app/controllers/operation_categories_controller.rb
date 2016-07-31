class OperationCategoriesController < ApplicationController
  unloadable

  layout 'admin'

  before_filter :require_admin

  def new
    @category = OperationCategory.new
  end

  def create
    @category = OperationCategory.new(params[:operation_category])
    if @category.save
      flash[:notice] = l(:notice_successful_create)
      redirect_to :action =>"plugin", :id => "redmine_finance", :controller => "settings", :tab => 'operation_categories'
    else
      render :action => 'new'
    end
  end

  def edit
    @category = OperationCategory.find(params[:id])
  end

  def update
    @category = OperationCategory.find(params[:id])
    if @category.update_attributes(params[:operation_category])
      flash[:notice] = l(:notice_successful_update)
      redirect_to :action =>"plugin", :id => "redmine_finance", :controller => "settings", :tab => 'operation_categories'
    else
      render :action => 'edit'
    end
  end

  def destroy
    @category = OperationCategory.find(params[:id])
    @operations_count = @category.operations.count if @category.present?
    if @operations_count == 0 || params[:todo] || api_request?
      reassign_to = nil
      if params[:reassign_to_id] && (params[:todo] == 'reassign' || params[:todo].blank?)
        reassign_to = OperationCategory.find(params[:reassign_to_id])
      end
      @category.destroy(reassign_to)
      respond_to do |format|
        format.html { redirect_to :controller => 'settings', :action => 'plugin', :id => 'redmine_finance', :tab => 'operation_categories' }
        format.api { render_api_ok }
      end
      return
    end
    @categories = OperationCategory.all - [@category]
  end

end
