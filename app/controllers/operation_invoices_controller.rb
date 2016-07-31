class OperationInvoicesController < ApplicationController
  unloadable

  before_filter :find_operation, :authorize
  before_filter :find_operation_object

  def create
    @operation_object = OperationObject.new(:operationable => @operationable)
    @operation_object.operation = @operation
    saved = @operation_object.save

    respond_to do |format|
      format.html { redirect_to :controller => 'operations', :action => 'show', :id => @operation }
      format.js {
        @invoices = find_operation_invoices
        render :template => "operation_objects/create"
      }
    end
  end

  def destroy
    @operation.invoices.destroy(@operationable)
    @operation_object = OperationObject.new if RedmineFinance.invoices_plugin_installed?
    respond_to do |format|
      format.html { redirect_to :back }
      format.js {
        @invoices = find_operation_invoices
        render :template => "operation_objects/destroy"
      }
    end
  end

private
  def find_operation
    @operation = Operation.find(params[:operation_id])
    @project = @operation.project
  rescue
    render_404
  end

  def find_operation_object
    if object_id = params[:object_id] || (params[:operation_object] && params[:operation_object][:operationable_id])
      @operationable = Invoice.visible.find(object_id)
    end
  rescue
    render_404
  end

  def find_operation_invoices
    @operation.invoices.visible
  end

end
