class OperationRelationsController < ApplicationController
  unloadable

  before_filter :find_operation, :find_project_from_association, :authorize, :only => [:index, :create]
  before_filter :find_relation, :except => [:index, :create]

  accept_api_auth :index, :show, :create, :destroy

  def index
    @relations = @operation.relations

    respond_to do |format|
      format.html { render :nothing => true }
      format.api
    end
  end

  def show
    raise Unauthorized unless @relation.visible?

    respond_to do |format|
      format.html { render :nothing => true }
      format.api
    end
  end

  def create
    @relation = OperationRelation.new(params[:relation])
    @relation.operation_source = @operation
    @relation.relation_type = 0
    saved = @relation.save

    respond_to do |format|
      format.html { redirect_to :controller => 'operations', :action => 'show', :id => @operation }
      format.js {
        @relations = @operation.relations.select {|r| r.other_operation(@operation) && r.other_operation(@operation).visible? }
      }
      format.api {
        if saved
          render :action => 'show', :status => :created, :location => relation_url(@relation)
        else
          render_validation_errors(@relation)
        end
      }
    end
  end

  def destroy
    raise Unauthorized unless @relation.deletable?
    @relation.destroy

    respond_to do |format|
      format.html { redirect_to :back } # TODO : does this really work since @operation is always nil? What is it useful to?
      format.js
      format.api  { render_api_ok }
    end
  end

private
  def find_operation
    @operation = @object = Operation.find(params[:operation_id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def find_relation
    @relation = OperationRelation.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end
end
