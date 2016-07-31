class AddIncomeToOperation < ActiveRecord::Migration
  def change
    add_column :operations, :income, :boolean, :default => true
  end
end