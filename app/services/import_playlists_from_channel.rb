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
    @channel.playlists.each do |playlist|
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

  def get_videos_in_playlist(playlist)
    talks = []
    playlist.playlist_items.each do |playlist_item|
      talk = Talk.where(object_id: playlist_item.video.id)
      if(talk.blank?)
        talk = CreateTalkFromYoutube.new({ talk: playlist_item.video }).run
        talks << talk
      else
        talks << talk
      end
    end
    return talks
  end


  # def write_talk(talk)
  #   id = talk.id
  #   title_and_speakers = get_title_and_speakers(talk)
  #   image = get_image(talk)
  #   language = get_language(talk)
  #   saved_talk = Talk.where(object_id: id)
  #   tags = get_tags(talk, language)
  #   if saved_talk.blank?
  #     talk = Talk.create(
  #       object_id:      id,
  #       name:           title_and_speakers[:name],
  #       speakers:       title_and_speakers[:speakers],
  #       description:    talk.description,
  #       date:           talk.published_at,
  #       duration_range: duration_range(talk),
  #       tags:           tags,
  #       viewed_count:   talk.view_count,
  #       like_count:     talk.like_count,
  #       dislike_count:  talk.dislike_count,
  #       image_url:      image,
  #       event_name:     "#{Date::MONTHNAMES[talk.published_at.month]} #{talk.published_at.year}",
  #       url:            "https://www.youtube.com/watch?v=#{id}",
  #       is_english:     language.downcase == "english",
  #       has_tags:       tags.length > 1
  #     ).save
  #     return talk
  #   else
  #     return saved_talk
  #   end
  # end
  #
  # def get_title_and_speakers(talk)
  #   if talk.title.split("|").length > 1
  #     name = talk.title.split("|")[0].strip! ? talk.title.split("|")[0].strip! : talk.title.split("|")[0]
  #     speakers = talk.title.split("|")[1].strip! ? talk.title.split("|")[1].strip! : talk.title.split("|")[1]
  #   elsif talk.title.split(":").length > 1
  #     speakers = talk.title.split(":")[0].strip! ? talk.title.split(":")[0].strip! : talk.title.split(":")[0]
  #     name = talk.title.split(":")[1].strip! ? talk.title.split(":")[1].strip! : talk.title.split(":")[1].strip!
  #   elsif talk.title.split(" - ").length > 1
  #     talk_name = talk.title.split(" - ")
  #     speakers = talk_name.delete_at(1)
  #     name = talk_name.join(" ")
  #   else
  #     name = talk.title
  #     speakers = "TED"
  #   end
  #   if speakers.split("&").length > 1
  #     speakers = speakers.split("&r")
  #   else
  #     speakers = [speakers]
  #   end
  #
  #   return {
  #     speakers: speakers,
  #     name: name
  #   }
  # end
  #
  # def get_tags(talk, language)
  #   begin
  #     talk.tags.reject { |tag| tag.downcase.include? "ted" }
  #   rescue
  #     return []
  #   end
  # end
  #
  # def duration_range(talk)
  #   if talk.duration < 6
  #     return 0
  #   elsif talk.duration < 12
  #     return 1
  #   elsif talk.duration < 18
  #     return 2
  #   elsif talk.duration < 24
  #     return 3
  #   else
  #     return 4
  #   end
  # end
  #
  # def get_image(talk)
  #   return talk.thumbnail_url("maxres")
  #   # test_url = "https://i.ytimg.com/vi/#{talk.id}/maxresdefault.jpg"
  #   # url = URI.parse(test_url)
  #   # req = Net::HTTP.new(url.host, url.port)
  #   # req.use_ssl = true
  #   # res = req.request_head(url.path)
  #   # if res.code == "200"
  #   #   return {
  #   #     image_url: test_url,
  #   #     hd: true
  #   #   }
  #   # else
  #   #   return {
  #   #     image_url: talk.thumbnail_url("high"),
  #   #     hd: false
  #   #   }
  #   # end
  # end


  def get_language(playlist)
    playlist.description == "" ? @wl.language(playlist.title) : @wl.language(playlist.description)
  end

end
