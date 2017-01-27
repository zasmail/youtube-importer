class ImportTalksFromChannelJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Do something later
    ImportVideosFromChannel.new({ channel_id: args[0].id }).run
  end

end
