class FbCallbackController < ApplicationController
  def new
    if Rails.env.development?
      callback = "http://localhost:3000/callback"
    else
      callback = "https://sheltered-citadel-56202.herokuapp.com/callback"
    end
    @oauth = Koala::Facebook::OAuth.new(Rails.application.secrets.fb_app_id, Rails.application.secrets.fb_secret, callback)
    token_info = @oauth.get_access_token_info(params[:code])
    token = FbToken.create(
      token: token_info['access_token'],
      expires: Time.now + token_info['expires'].to_i
      )
    token.save
    redirect_to '/'
  end
end
