class AddParentIdToOperationCategories < ActiveRecord::Migration
  def change
    add_column :operation_categories, :parent_id, :integer
    add_column :operation_categories, :lft, :integer
    add_column :operation_categories, :rgt, :integer
    add_column :operation_categories, :code, :string

    add_index :operation_categories, [:lft]
    add_index :operation_categories, [:rgt]

  end
end