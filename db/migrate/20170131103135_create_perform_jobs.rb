class CreatePerformJobs < ActiveRecord::Migration[5.0]
  def change
    create_table :perform_jobs do |t|
      t.boolean :completed
      t.integer :channel
      t.integer :job_id
      t.string :type

      t.timestamps
    end
  end
end
