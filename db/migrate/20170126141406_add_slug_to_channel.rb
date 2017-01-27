class AddSlugToChannel < ActiveRecord::Migration[5.0]
  def change
    add_column :channels, :slug, :string
  end
end
