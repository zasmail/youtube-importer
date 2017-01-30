class StatusesController < ApplicationController
  def create
    render json: {data: {
       type: "status_update",
       id: 999999999,
       attributes: {
        talks: Talk.all.length,
        playlists: Playlist.all.length,
        socialt: Talk.where.not(facebook_share_count: nil).length,
        socialp: Playlist.where.not(facebook_share_count: nil).length,
       }
       }}, adapter: :json
  end

end
