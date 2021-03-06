class YoutubesController < ApplicationController
  def create
    Channel.all.each do |channel|
      ImportTalksFromChannelJob.perform_later(channel)
    end
    # saved_job = PerformJob.create({
    #   type: "talks",
    #   job_id: job.job_id,
    #   completed: false,
    #   })
    # saved_job.save
    render json: {data: {
       type: "youtubes",
       id: 999999999,
       attributes: {
        talks: Talk.all.length,
        playlists: Playlist.all.length,
        talks_updated: Talk.where.not(facebook_share_count: nil).length,
        playlists_updated: Playlist.where.not(facebook_share_count: nil).length,
       }
       }}, adapter: :json
  end
end
