class Channel < ApplicationRecord
  has_many :talks
  has_many :playlists
end
