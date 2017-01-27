require 'social_shares'
require 'koala'

class UpdateSocial
  attr_reader :params
  def initialize(params)
    # pass the actual object
    @graph = Koala::Facebook::API.new(FbToken.last[:token])

    @needs_update = params[:needs_update]
  end

  def run
    social = SocialShares.all @needs_update[:url]
    facebook = get_facebook_data(@needs_update[:url])
    @needs_update.update_attributes(
      facebook_share_count: facebook[:facebook_share_count],
      facebook_comment_count: facebook[:facebook_comment_count],
      google_share_count: social['google'],
      reddit_share_count: social['reddit'],
      linkedin_share_count: social['linkedin'],
      pinterest_share_count: social['pinterest'],
    )
    @needs_update.save
  end

  private

  def get_facebook_data(url)
    data = @graph.get_object('', id: url)
    return {
      facebook_share_count: data['share']['share_count'],
      facebook_comment_count: data['share']['comment_count']
    }
  end

end
