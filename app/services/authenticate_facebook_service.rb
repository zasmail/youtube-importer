require 'social_shares'

class AuthenticateFacebookService
  attr_reader :params
  # PARAMS need to be { id: n, is_talk: true}
  def initialize
    if Rails.env.development?
      callback = "http://localhost:3000/callback"
    else
      callback = "http://localhost:3000/callback"
    end


    @oauth = Koala::Facebook::OAuth.new(Rails.application.secrets.fb_app_id, Rails.application.secrets.fb_secret, callback)
    return @oauth
  end

  private


end
