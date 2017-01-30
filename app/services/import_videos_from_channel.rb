require 'whatlanguage'
require 'progress_bar'

class ImportVideosFromChannel
  attr_reader :params
  def initialize(channel_params)
    Yt.configuration.api_key = Rails.application.secrets.yt_api_key ## replace with your API key
		Yt.configure do |config|
		  config.client_id = Rails.application.secrets.yt_client_id
		  config.client_secret = Rails.application.secrets.yt_client_secret
		 	config.log_level = :debug
		end
    @channel = Yt::Channel.new url: Channel.find(channel_params[:channel_id])[:url]
    @wl = WhatLanguage.new(:all)
  end

  def run
    @channel.videos.each do |talk|
      write_talk(talk)
    end
  end

  private

  def channel_params
    params.require(:channel_id)
  end

  def write_talk(talk)
    talk = CreateTalkFromYoutube.new({ talk: talk }).run
  end

end
