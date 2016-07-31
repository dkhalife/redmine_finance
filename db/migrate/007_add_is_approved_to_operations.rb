class AddIsApprovedToOperations < ActiveRecord::Migration
  def change
    add_column :operations, :is_approved, :boolean, :null => false, :default => false
  end
end
