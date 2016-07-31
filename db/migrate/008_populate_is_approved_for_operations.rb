class PopulateIsApprovedForOperations < ActiveRecord::Migration
  def up
    Operation.update_all(:is_approved => true)
  end

  def down
  end
end
