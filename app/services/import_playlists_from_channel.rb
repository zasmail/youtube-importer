require 'whatlanguage'
require 'progress_bar'

class ImportPlaylistsFromChannel
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
    pp "Channel #{@channel.title}"
    bar = ProgressBar.new(@channel.playlists.count)
    @channel.playlists.each do |playlist|
      bar.increment!
      write_playlist(playlist)
    end
  end

  private

  def channel_params
    params.require(:channel_id)
  end

  def write_playlist(playlist)
    id = playlist.id
    talks = get_videos_in_playlist(playlist).map{|talk, key| talk }
    tags = playlist.tags
    tags = tags.uniq
    old_playlist = Playlist.where(object_id: id)
    if old_playlist.blank?
      save_playlist = Playlist.create(
        object_id:        id,
        slug:             id,
        name:             playlist.title,
        description:      playlist.description,
        date:             playlist.published_at,
        tags:             tags.join(","),
        url:              "http://www.youtube.com/playlist?list=#{id}",
        is_english:       get_language(playlist),
        has_description:  !playlist.description.blank?,
        has_tags:         !tags.blank?,
        talks:            talks
      )
      save_playlist.save()
    end
  end

  def get_videos_in_playlist(playlist)
    talks = []
    bar = ProgressBar.new(playlist.playlist_items.count)
    playlist.playlist_items.each do |playlist_item|
      bar.increment!
      talk = CreateTalkFromYoutube.new({ talk: playlist_item.video }).run
      talk = Talk.where(object_id: playlist_item.video.id)
      talks << talk
    end
    return talks
  end

  def get_language(playlist)
    playlist.description == "" ? @wl.language(playlist.title) : @wl.language(playlist.description)
  end

end
