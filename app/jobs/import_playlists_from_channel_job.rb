class ImportPlaylistsFromChannelJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Do something later
    ImportPlaylistsFromChannel.new({ channel_id: args[0].id }).run
  end
end
