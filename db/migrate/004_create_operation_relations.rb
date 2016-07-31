class CreateOperationRelations < ActiveRecord::Migration
  def change
    create_table :operation_relations do |t|
      t.integer :source_id
      t.integer :destination_id
      t.string :relation_type
      t.timestamp :created_at
    end
  end
end
