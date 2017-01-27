class UpdateSocialMediaNumbersJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Playlist.all.each do |playlist|
      UpdateSocial.new({needs_update: talk}).run
    end
    Talk.all.each do |talk|
      UpdateSocial.new({needs_update: talk}).run
    end
    # Do something later
  end
end
