class SocialsController < ApplicationController
  def create
    UpdateSocialMediaNumbersJob.perform_later

    render json: {data: {
       type: "youtubes",
       id: 999999999,
       attributes: {
        talks: Talk.where.not(facebook_share_count: nil).length,
        playlists: Playlist.where.not(facebook_share_count: nil).length,
        talks_updated: Talk.where.not(facebook_share_count: nil).length,
        playlists_updated: Playlist.where.not(facebook_share_count: nil).length,
       }
       }}, adapter: :json
  end
end
