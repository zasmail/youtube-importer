class CreateFailures < ActiveRecord::Migration[5.0]
  def change
    create_table :failures do |t|
      t.string :model_type
      t.string :model_id
      t.string :error
      t.string :job

      t.timestamps
    end
  end
end
