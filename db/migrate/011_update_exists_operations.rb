class UpdateExistsOperations < ActiveRecord::Migration
  def up
    OperationCategory.where(['is_income = ? OR is_income IS NULL', false]).find_all do |category|
      category.operations.update_all(:income => false)
    end
    remove_column :operation_categories, :is_income
  end

  def down
    add_column :operation_categories, :is_income, :boolean
  end
end
