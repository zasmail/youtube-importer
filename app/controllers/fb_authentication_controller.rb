class FbAuthenticationController < ApplicationController
  def index
  end
  def create
    if Rails.env.development?
      callback = "http://localhost:3000/callback"
    else
      callback = "https://sheltered-citadel-56202.herokuapp.com/callback"
    end
    @oauth = Koala::Facebook::OAuth.new(Rails.application.secrets.fb_app_id, Rails.application.secrets.fb_secret, callback)
    redirect_to @oauth.url_for_oauth_code
  end
end
