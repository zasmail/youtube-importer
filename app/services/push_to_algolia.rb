require 'social_shares'
require 'koala'

class PushToAlgolia
  def initialize
    Algolia.init :application_id => "8ERZV9OS4S", :api_key => Rails.application.secrets.algolia_api_key
    @talks_index = Algolia::Index.new("talks")
    @talks_index.set_settings({
    	attributesToIndex: ['unordered(name)', 'speakers'],
    	customRanking: ['desc(hd_image)', 'desc(date)'],
    	minWordSizefor1Typo: 3,
    	minWordSizefor2Typos: 7,
    	attributesForFaceting: ['date', 'duration_range', 'searchable(event_name)', 'searchable(speakers)', 'searchable(tags)', 'searchable(languages)'],
    	slaves: ['talks_date_asc', 'talks_viewed_count_desc', 'talks_liked_score_desc', 'talks_disliked_score_desc', 'talks_fb_shared_desc', 'talks_fb_commented_desc', 'talks_popularity_score_desc', 'talks_unpopular_score_desc']
    	})
    Algolia::Index.new("talks_date_asc"               ).set_settings({ attributesToIndex: ['unordered(name)', 'speakers'], minWordSizefor1Typo: 3, minWordSizefor2Typos: 7,  attributesForFaceting: ['date', 'duration_range', 'searchable(event_name)', 'searchable(speakers)', 'searchable(tags)', 'searchable(languages)'], customRanking: ['desc(hd_image)', 'asc(date)'] })
    Algolia::Index.new("talks_viewed_count_desc"      ).set_settings({ attributesToIndex: ['unordered(name)', 'speakers'], minWordSizefor1Typo: 3, minWordSizefor2Typos: 7,  attributesForFaceting: ['date', 'duration_range', 'searchable(event_name)', 'searchable(speakers)', 'searchable(tags)', 'searchable(languages)'], customRanking: ['desc(hd_image)', 'desc(viewed_count)'] })
    Algolia::Index.new("talks_liked_score_desc"       ).set_settings({ attributesToIndex: ['unordered(name)', 'speakers'], minWordSizefor1Typo: 3, minWordSizefor2Typos: 7,  attributesForFaceting: ['date', 'duration_range', 'searchable(event_name)', 'searchable(speakers)', 'searchable(tags)', 'searchable(languages)'], customRanking: ['desc(hd_image)', 'desc(like_count)'] })
    Algolia::Index.new("talks_disliked_score_desc"    ).set_settings({ attributesToIndex: ['unordered(name)', 'speakers'], minWordSizefor1Typo: 3, minWordSizefor2Typos: 7,  attributesForFaceting: ['date', 'duration_range', 'searchable(event_name)', 'searchable(speakers)', 'searchable(tags)', 'searchable(languages)'], customRanking: ['desc(hd_image)', 'desc(dislike_count)'] })
    Algolia::Index.new("talks_fb_shared_desc"         ).set_settings({ attributesToIndex: ['unordered(name)', 'speakers'], minWordSizefor1Typo: 3, minWordSizefor2Typos: 7,  attributesForFaceting: ['date', 'duration_range', 'searchable(event_name)', 'searchable(speakers)', 'searchable(tags)', 'searchable(languages)'], customRanking: ['desc(hd_image)', 'desc(facebook_share_count)'] })
    Algolia::Index.new("talks_fb_commented_desc"      ).set_settings({ attributesToIndex: ['unordered(name)', 'speakers'], minWordSizefor1Typo: 3, minWordSizefor2Typos: 7,  attributesForFaceting: ['date', 'duration_range', 'searchable(event_name)', 'searchable(speakers)', 'searchable(tags)', 'searchable(languages)'], customRanking: ['desc(hd_image)', 'desc(facebook_comment_count)'] })
    Algolia::Index.new("talks_popularity_score_desc"  ).set_settings({ attributesToIndex: ['unordered(name)', 'speakers'], minWordSizefor1Typo: 3, minWordSizefor2Typos: 7,  attributesForFaceting: ['date', 'duration_range', 'searchable(event_name)', 'searchable(speakers)', 'searchable(tags)', 'searchable(languages)'], customRanking: ['desc(hd_image)', 'desc(popularity_score)'] })
    Algolia::Index.new("talks_unpopular_score_desc"   ).set_settings({ attributesToIndex: ['unordered(name)', 'speakers'], minWordSizefor1Typo: 3, minWordSizefor2Typos: 7,  attributesForFaceting: ['date', 'duration_range', 'searchable(event_name)', 'searchable(speakers)', 'searchable(tags)', 'searchable(languages)'], customRanking: ['desc(hd_image)', 'desc(unpopular_score)'] })

    @speakers_index = Algolia::Index.new("speakers")
    @speakers_index.set_settings({ attributesToIndex: ['name', 'description'], attributesToRetrieve: ['name', 'image_url', 'description', 'slug', 'nbTalks'], customRanking: ['desc(score)'] })
    @playlists_index = Algolia::Index.new("playlists")
    @playlists_index.set_settings({ attributesToIndex: ['title', 'description', 'tags', 'talk_title'], attributesToRetrieve: ['title', 'description', 'slug', 'total_share_count', 'image_url'], customRanking: ['desc(has_description)', 'desc(has_tags)', 'desc(total_share_count)'] })

  end

  def run

  end

  private

  def get_facebook_data(url)

  end

end
