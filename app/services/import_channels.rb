class ImportChannels
  attr_reader :params
  def initialize(url='https://www.youtube.com/channel/UCAuUUnT6oDeKwE6v1NGQxug')
    Yt.configuration.api_key = Rails.application.secrets.yt_api_key ## replace with your API key
		Yt.configure do |config|
		  config.client_id = Rails.application.secrets.yt_client_id
		  config.client_secret = Rails.application.secrets.yt_client_secret
		 	config.log_level = :debug
		end
    @channel = Yt::Channel.new url: url
  end

  def run
    write_channel(@channel)
    @channel.subscribed_channels.each do |channel|
      write_channel(channel)
    end
  end

  private

  def write_channel(channel)
    # user = User.create(name: "David", occupation: "Code Artist")
    channel = Channel.create(name: channel.title, slug: channel.id, url: "https://www.youtube.com/channel/#{channel.id}").save()
  end

end
