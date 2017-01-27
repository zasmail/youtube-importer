class CreateChannels < ActiveRecord::Migration[5.0]
  def change
    change_table :channels do |t|
      t.string :name
      t.string :url
      t.datetime :last_updated
    end
  end
end
