class AddAssignedToIdToOperations < ActiveRecord::Migration
  def change
    add_column :operations, :assigned_to_id, :integer
  end
end
