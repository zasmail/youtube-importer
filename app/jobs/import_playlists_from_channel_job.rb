class ImportPlaylistsFromChannelJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Do something later
    ImportPlaylistsFromChannel.new({ channel_id: channel.id }).run
  end
end
