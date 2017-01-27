class ChangeObjectId < ActiveRecord::Migration[5.0]
  def change
    rename_column :talks, :objectID, :object_id
  end
end
