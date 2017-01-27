require 'whatlanguage'

class Talk < ApplicationRecord
  # attr_accessor :name, :description, :date, :duration_range, :viewed_count, :like_count, :dislike_count, :event_name, :languages, :popularity_score, :unpopular_score, :facebook_share_count, :facebook_comment_count, :is_english, :google_share_count, :reddit_share_count, :linkedin_share_count, :pinterest_share_count, :total_share_count, :has_description, :has_tags, :created_at, :updated_at, :tags, :speakers, :image_url, :hd_image, :url

  def create_from_youtube(talk)
    id = talk.id
    title_and_speakers = get_title_and_speakers(talk)
    image = get_image(talk)
    language = get_language(talk)
    tags = get_tags(talk, language)
    self.update_attributes!(
      object_id:      id,
      name:           title_and_speakers[:name],
      speakers:       title_and_speakers[:speakers],
      description:    talk.description,
      date:           talk.published_at,
      duration_range: get_duration_range(talk),
      tags:           tags,
      viewed_count:   talk.view_count,
      like_count:     talk.like_count,
      dislike_count:  talk.dislike_count,
      image_url:      image,
      event_name:     "#{Date::MONTHNAMES[talk.published_at.month]} #{talk.published_at.year}",
      url:            "https://www.youtube.com/watch?v=#{id}",
      is_english:     language.downcase == "english",
      has_tags:       tags.length > 1
    )
    # self.object_id =      id,
    # self.name =           title_and_speakers[:name],
    # self.speakers =       title_and_speakers[:speakers],
    # self.description =    talk.description,
    # self.date =           talk.published_at,
    # self.duration_range = duration_range(talk),
    # self.tags =           tags,
    # self.viewed_count =   talk.view_count,
    # self.like_count =     talk.like_count,
    # self.dislike_count =  talk.dislike_count,
    # self.image_url =      image,
    # self.event_name =     "#{Date::MONTHNAMES[talk.published_at.month]} #{talk.published_at.year}",
    # self.url =            "https://www.youtube.com/watch?v=#{id}",
    # self.is_english =     language.downcase == "english",
    # self.has_tags =       tags.length > 1
    byebug
    self.save
    return self
  end

  def get_title_and_speakers(talk)
    if talk.title.split("|").length > 1
      name = talk.title.split("|")[0].strip! ? talk.title.split("|")[0].strip! : talk.title.split("|")[0]
      speakers = talk.title.split("|")[1].strip! ? talk.title.split("|")[1].strip! : talk.title.split("|")[1]
    elsif talk.title.split(":").length > 1
      speakers = talk.title.split(":")[0].strip! ? talk.title.split(":")[0].strip! : talk.title.split(":")[0]
      name = talk.title.split(":")[1].strip! ? talk.title.split(":")[1].strip! : talk.title.split(":")[1].strip!
    elsif talk.title.split(" - ").length > 1
      talk_name = talk.title.split(" - ")
      speakers = talk_name.delete_at(1)
      name = talk_name.join(" ")
    else
      name = talk.title
      speakers = "TED"
    end
    if speakers.split("&").length > 1
      speakers = speakers.split("&r")
    else
      speakers = [speakers]
    end

    return {
      speakers: speakers,
      name: name
    }
  end

  def get_tags(talk, language)
    begin
      talk.tags.reject { |tag| tag.downcase.include? "ted" }
    rescue
      return []
    end
  end

  def get_image(talk)
    return talk.thumbnail_url("maxres")
  end

  def get_language(talk)
    @wl = WhatLanguage.new(:all)
    talk.description == "" ? @wl.language(talk.title) : @wl.language(talk.description)
  end

  def get_duration_range(talk)
    if talk.duration < 6
      return 0
    elsif talk.duration < 12
      return 1
    elsif talk.duration < 18
      return 2
    elsif talk.duration < 24
      return 3
    else
      return 4
    end
  end


end
