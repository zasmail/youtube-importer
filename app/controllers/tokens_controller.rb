class TokensController < ApplicationController
  def index
        # render json: @, each_serializer: ::V2::MenuSerializer
    @token = FbToken.last
     render json: {data: [{
        type: "token",
        id: @token.id,
        attributes: { expires: @token.expires }
        }]}, adapter: :json
    #  render json: TokenSerializer.new(id: @token.id, expires: @token.expires ), adapter: :json
    # return FbToken.last
  end

  def create
    if Rails.env.development?
      callback = "http://localhost:3000/callback"
    else
      callback = "https://sheltered-citadel-56202.herokuapp.com/callback"
    end
    @oauth = Koala::Facebook::OAuth.new(Rails.application.secrets.fb_app_id, Rails.application.secrets.fb_secret, callback)
    # redirect_to @oauth.url_for_oauth_code
    render json: {data: {
       type: "token",
       id: 999999999,
       attributes: { url: @oauth.url_for_oauth_code }
       }}, adapter: :json
  end

end
