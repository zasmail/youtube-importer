class GetDataController < ApplicationController
  def index
    Channel.all.each do |channel|
      ImportPlaylistsFromChannelJob.perform_later(channel)
      ImportTalksFromChannelJob.perform_later(channel)
      UpdateSocialMediaNumbersJob.set(wait: 5.hours).perform_later()
    end
    redirect_to admin_dashboard_path
  end
end
