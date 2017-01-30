class TagsFix < ActiveRecord::Migration
  def up
    change_column :talks, :tags, :string
    change_column :talks, :speakers, :string
    change_column :playlists, :tags, :string
    change_column :talks, :hd_image, :boolean
  end

  def down
    change_column :talks, :tags, :text, default: [].to_yaml
    change_column :talks, :speakers, :text, default: [].to_yaml
    change_column :playlists, :tags, :text, default: [].to_yaml
    change_column :talks, :hd_image, :string
  end
end
