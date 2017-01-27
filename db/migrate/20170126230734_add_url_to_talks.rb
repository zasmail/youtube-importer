class AddUrlToTalks < ActiveRecord::Migration[5.0]
  def change
    add_column :talks, :url, :string
  end
end
