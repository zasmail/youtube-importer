require 'social_shares'
require 'koala'

class PushToAlgolia
  def initialize
    Algolia.init :application_id => Rails.application.secrets.algolia_app_id, :api_key => Rails.application.secrets.algolia_api_key
    @talks_index = Algolia::Index.new("talks")
    @talks_index.set_settings({
    	attributesToIndex: ['unordered(name)', 'speakers'],
    	customRanking: ['desc(hd_image)', 'desc(date)'],
    	attributesForFaceting: ['duration_range', 'searchable(event_name)', 'searchable(speakers)', 'searchable(tags)', 'searchable(languages)'],
    	replicas: ['talks_date_asc', 'talks_viewed_count_desc', 'talks_liked_score_desc', 'talks_disliked_score_desc', 'talks_fb_shared_desc', 'talks_google_shared_desc', 'talks_reddit_shared_desc', 'talks_linkedin_shared_desc', 'talks_pinterest_shared_desc', 'talks_total_shared_desc', 'talks_popularity_score_desc']
    	}, {forwardToReplicas: true})

    Algolia::Index.new("talks_date_asc"               ).set_settings({ customRanking: ['desc(hd_image)', 'asc(date)'] })
    Algolia::Index.new("talks_viewed_count_desc"      ).set_settings({ customRanking: ['desc(hd_image)', 'desc(viewed_count)'] })
    Algolia::Index.new("talks_liked_score_desc"       ).set_settings({ customRanking: ['desc(hd_image)', 'desc(like_count)'] })
    Algolia::Index.new("talks_disliked_score_desc"    ).set_settings({ customRanking: ['desc(hd_image)', 'desc(dislike_count)'] })
    Algolia::Index.new("talks_fb_shared_desc"         ).set_settings({ customRanking: ['desc(hd_image)', 'desc(facebook_share_count)'] })
    Algolia::Index.new("talks_google_shared_desc"     ).set_settings({ customRanking: ['desc(hd_image)', 'desc(google_share_count)'] })
    Algolia::Index.new("talks_reddit_shared_desc"     ).set_settings({ customRanking: ['desc(hd_image)', 'desc(reddit_share_count)'] })
    Algolia::Index.new("talks_linkedin_shared_desc"   ).set_settings({ customRanking: ['desc(hd_image)', 'desc(linkedin_share_count)'] })
    Algolia::Index.new("talks_pinterest_shared_desc"  ).set_settings({ customRanking: ['desc(hd_image)', 'desc(pinterest_share_count)'] })
    Algolia::Index.new("talks_total_shared_desc"      ).set_settings({ customRanking: ['desc(hd_image)', 'desc(total_share_count)'] })
    Algolia::Index.new("talks_popularity_score_desc"  ).set_settings({ customRanking: ['desc(hd_image)', 'asc(date_buckets)', 'desc(views_buckets)'] })

    @speakers_index = Algolia::Index.new("speakers")
    @speakers_index.set_settings({ attributesToIndex: ['name', 'description'], attributesToRetrieve: ['name', 'image_url', 'description', 'slug', 'nbTalks'], customRanking: ['desc(score)'] })
    @playlists_index = Algolia::Index.new("playlists")
    @playlists_index.set_settings({ attributesToIndex: ['title', 'description', 'tags', 'talk_tags'], attributesToRetrieve: ['title', 'description', 'slug', 'total_share_count', 'image_url'], customRanking: ['desc(has_description)', 'desc(total_share_count)'] })
    @talks = Talk.all
    @talks_formatted = {}
    @playlists = Playlist.all
    @speakers = {}
    @playlists_formatted = {}
  end

  def run
    setup_data

    @talks_index.clear_index
    @talks_index.add_objects(@talks_formatted.values)

    @speakers_index.clear_index
    @speakers_index.add_objects(@speakers.values)

    @playlists_index.clear_index
    @playlists_index.add_objects(@playlists_formatted.values)
  end

  private

  def setup_data
    @talks.each do |talk|
      @talks_formatted[talk[:id]] = handle_talk(talk)
      handle_speaker(talk)
    end
    @speakers.each do |key, speaker|
      speaker[:talks].sort{ |a , b| a['viewed_count'] <=> b['viewed_count']}
      speaker[:image_url] = speaker[:talks].first['image_url']
      speaker[:nbTalks] = speaker[:talks].length
      speaker[:description] = speaker[:talks].map{ |talk| talk['tags'] }.flatten.uniq!
      speaker[:score] = speaker[:talks].inject(0){ |sum, talk| sum + talk['viewed_count'] }
    end
    @playlists.each do |playlist|
      @playlists_formatted[playlist[:id]] = handle_playlist(playlist)
    end
  end

  def handle_speaker(talk)
    if talk['speakers'].nil?
      return
    end
    if talk['speakers'].downcase.include? 'ted'
      return
    end
    if !@speakers[talk['speakers']].nil?
      @speakers[talk['speakers']][:talks] << talk
    else
      talks_array = []
      talks_array << talk
      @speakers[talk['speakers']] = {
        talks: talks_array,
        name: talk['speakers'],
       }
    end
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

  def handle_playlist(playlist)
    if playlist.talks.blank?
      playlist.talks= []
    end
    talks_sorted = playlist.talks.sort{ |a , b| a['viewed_count'] <=> b['viewed_count']}
    talk_tags =[]
    playlist.talks.each do |talk|
      talk_tags << talk[:tags].split(',')
    end
    talk_tags = talk_tags.flatten.uniq
    image = talks_sorted.detect{ |talk| talk[:hd_image] }[:image_url]
    if image.blank?
      image = talks_sorted.first[:image_url]
    end
    playlist[:facebook_share_count] = 0 if playlist[:facebook_share_count].blank?
    playlist[:google_share_count] = 0 if playlist[:google_share_count].blank?
    playlist[:reddit_share_count] = 0 if playlist[:reddit_share_count].blank?
    playlist[:linkedin_share_count] = 0 if playlist[:linkedin_share_count].blank?
    playlist[:pinterest_share_count] = 0 if playlist[:pinterest_share_count].blank?
    total_share_count = playlist[:facebook_share_count] + playlist[:google_share_count] + playlist[:reddit_share_count] + playlist[:linkedin_share_count] + playlist[:pinterest_share_count]
    return {
        objectID: playlist[:slug],
        slug: playlist[:slug],
        title: playlist[:name],
        description: playlist[:description],
        image_url: image,
        tags: playlist[:tags].split(','),
        talk_tags: talk_tags,
        facebook_share_count: playlist[:facebook_share_count],
        google_share_count: playlist[:google_share_count],
        reddit_share_count: playlist[:reddit_share_count],
        linkedin_share_count: playlist[:linkedin_share_count],
        pinterest_share_count: playlist[:pinterest_share_count],
        total_share_count: total_share_count,
        has_description: !playlist[:description].blank?,
        has_tags: !playlist[:tags].blank?
    }
  end

end
