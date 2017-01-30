class PushToAlgoliaJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Do something later
    PushToAlgolia.new().run

  end
end
