class CreatePlaylists < ActiveRecord::Migration[5.0]
  def change
    create_table :playlists do |t|
      t.string :objectID
      t.string :slug
      t.string :name
      t.string :description
      t.datetime :published_at
      t.integer :popularity_score
      t.integer :unpopular_score
      t.integer :facebook_share_count
      t.integer :facebook_comment_count
      t.boolean :is_english
      t.integer :google_share_count
      t.integer :reddit_share_count
      t.integer :linkedin_share_count
      t.integer :pinterest_share_count
      t.integer :total_share_count
      t.boolean :has_description
      t.boolean :has_tags
      t.integer :like_count
      t.integer :dislike_count
      t.string :image_url

      t.timestamps
    end
  end
end
