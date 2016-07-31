class BuildOperationsTree < ActiveRecord::Migration
  def up
    if OperationCategory.respond_to?(:rebuild_tree!)
      OperationCategory.rebuild_tree!
    elsif OperationCategory.respond_to?(:rebuild!)
      OperationCategory.rebuild!
    end
  end

  def down
  end
end
