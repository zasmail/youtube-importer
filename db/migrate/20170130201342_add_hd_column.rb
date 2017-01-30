class AddHdColumn < ActiveRecord::Migration[5.0]
  def change
    add_column :talks, :hd_image, :boolean
  end
end
