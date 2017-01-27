class AddTagsAndSpeakersToTalks < ActiveRecord::Migration
  def change
    add_column :talks, :tags, :text, default: [].to_yaml
    add_column :talks, :speakers, :text, default: [].to_yaml
  end
end
