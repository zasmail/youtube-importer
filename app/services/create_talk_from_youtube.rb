require 'whatlanguage'
require 'progress_bar'

class CreateTalkFromYoutube
  attr_reader :params
  def initialize(talk_params)
    @wl = WhatLanguage.new(:all)
    @talk = talk_params[:talk]
  end

  def run
    return write_talk(@talk)
  end

  private

  def talk_params
    params.require(:talk)
  end

  def write_talk(talk)
    id = talk.id
    title_and_speakers = get_title_and_speakers(talk)
    image = get_image(talk)
    language = get_language(talk)
    saved_talk = Talk.where(object_id: id)
    tags = get_tags(talk, language)
    if saved_talk.blank?
      talk = Talk.create(
        object_id:        id,
        name:             title_and_speakers[:name],
        speakers:         title_and_speakers[:speakers].join(","),
        description:      talk.description,
        date:             talk.published_at,
        duration_range:   duration_range(talk),
        tags:             tags.join(","),
        viewed_count:     talk.view_count,
        like_count:       talk.like_count,
        dislike_count:    talk.dislike_count,
        image_url:        image[:image_url],
        hd_image:         image[:hd],
        event_name:       "#{Date::MONTHNAMES[talk.published_at.month]} #{talk.published_at.year}",
        languages:        language,
        url:              "https://www.youtube.com/watch?v=#{id}",
        is_english:       language.downcase == "english",
        has_tags:         tags.length > 1,
        has_description:  !talk.description.blank?,
      )
      talk.save
      return talk
    else
      return saved_talk
    end
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
      speakers = speakers.split("&")
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

  def duration_range(talk)
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

  def get_image(talk)
    if talk.thumbnail_url("maxres").blank?
      return {
          image_url: talk.thumbnail_url("high"),
          hd: false
        }
    else
      return {
          image_url: talk.thumbnail_url("maxres"),
          hd: true
        }
    end
  end

  def get_language(talk)
    talk.description == "" ? @wl.language(talk.title) : @wl.language(talk.description)
  end

end
