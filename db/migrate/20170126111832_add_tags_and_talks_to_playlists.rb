class AddTagsAndTalksToPlaylists < ActiveRecord::Migration
  def change
    add_column :playlists, :tags, :text, default: [].to_yaml
    add_reference :playlists, :talks, index: true
  end
end
