class PushTalksAlgoliaJob < ApplicationJob
  queue_as :default

  def perform(*args)
    ImportRecentVideosFromChannelToAlgolia.new(channel_id: Channel.where(name: "TED").first.id).run
  end
end
