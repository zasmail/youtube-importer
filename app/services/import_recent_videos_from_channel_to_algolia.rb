require 'whatlanguage'
require 'progress_bar'

class ImportRecentVideosFromChannelToAlgolia
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
    Algolia.init :application_id =>  Rails.application.secrets.algolia_app_id, :api_key => Rails.application.secrets.algolia_api_key
    @recent_talks_index = Algolia::Index.new("recent_talks")
    @recent_talks_index.set_settings({
      attributesToIndex: ['unordered(name)', 'speakers'],
      customRanking: ['desc(hd_image)', 'desc(date)'],
      attributesForFaceting: ['duration_range', 'searchable(event_name)', 'searchable(speakers)', 'searchable(tags)', 'searchable(languages)'],
      })
  end

  def run
    talks = []
    index = 0
    bar = ProgressBar.new(21)
    @channel.videos.each do |talk|
      bar.increment!
      if index > 20
        break
      end
      talks << handle_talk(write_talk(talk).first)
      index = index + 1
    end
    @recent_talks_index.clear_index
    @recent_talks_index.add_objects(talks)
  end

  private

  def channel_params
    params.require(:channel_id)
  end

  def write_talk(talk)
    talk = CreateTalkFromYoutube.new({ talk: talk }).run
  end

  def handle_talk(talk)
    months_between = (Date.today.year * 12 + Date.today.month) - (talk[:date].year * 12 + talk[:date].month)
    talk[:facebook_share_count] = 0 if talk[:facebook_share_count].blank?
    talk[:google_share_count] = 0 if talk[:google_share_count].blank?
    talk[:reddit_share_count] = 0 if talk[:reddit_share_count].blank?
    talk[:linkedin_share_count] = 0 if talk[:linkedin_share_count].blank?
    talk[:pinterest_share_count] = 0 if talk[:pinterest_share_count].blank?
    total_share_count = talk[:facebook_share_count] + talk[:google_share_count] + talk[:reddit_share_count] + talk[:linkedin_share_count] + talk[:pinterest_share_count]
    return {
      date: talk[:date],
      duration_range: talk[:duration_range],
      event_name: talk[:event_name],
      speakers: talk[:speakers].split(','),
      tags: talk[:tags].split(','),
      languages: talk[:languages],
      name: talk[:name],
      viewed_count: talk[:viewed_count],
      like_count: talk[:like_count],
      dislike_count: talk[:dislike_count],
      objectID: talk[:id],
      image_url: talk[:image_url],
      date_buckets: months_between == 0 ? 0 : Math.log(months_between, 6).round,
      views_buckets: talk[:viewed_count] == 0 ? 0 : Math.log(talk[:viewed_count]).round,
      date: talk[:date].to_i,
      facebook_share_count: talk[:facebook_share_count],
      facebook_comment_count: talk[:facebook_comment_count],
      google_share_count: talk[:google_share_count],
      reddit_share_count: talk[:reddit_share_count],
      linkedin_share_count: talk[:linkedin_share_count],
      pinterest_share_count: talk[:pinterest_share_count],
      total_share_count: total_share_count,
      social_score: Math.log(total_share_count).round(1),
    }
  end

end
