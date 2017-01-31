class ImportTalksFromChannelJob < ApplicationJob
  queue_as :default

  # after_perform do |job|
  #   byebug
  #   saved_job = PerformJob.where(job_id: job.job_id).first
  #   saved_job[:completed] = true
  # end

  def perform(*args)
    # Do something later
    ImportVideosFromChannel.new({ channel_id: args[0].id }).run
  end



end
