class AddAttributesToPlaylists < ActiveRecord::Migration
  def change
    add_column :playlists, :channel_name, :string
    add_column :playlists, :hd_image, :boolean
    add_column :playlists, :url, :string
    add_column :playlists, :object_id, :string
    add_column :playlists, :date, :datetime
    add_column :playlists, :languages, :text, array: true
    add_reference :talks, :playlist, index: true
  end
end
