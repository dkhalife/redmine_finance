class OperationObject < ActiveRecord::Base
  unloadable
  attr_accessible :operationable, :operation_id, :operationable_id, :operationable_type

  belongs_to :operation
  belongs_to :operationable, :polymorphic => true  

  validates_presence_of :operationable, :operation
  validates_uniqueness_of :operation_id, :scope => [:operationable_id, :operationable_type]
end
