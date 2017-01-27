class AddImageToTalk < ActiveRecord::Migration[5.0]
  def change
    add_column :talks, :image_url, :string
    add_column :talks, :hd_image, :string
    add_index  :talks, :object_id
  end
end
