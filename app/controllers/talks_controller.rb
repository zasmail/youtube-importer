class TalksController < ApplicationController
  def create()
    PushTalksAlgoliaJob.perform_now()
    render json: {data: {
       type: "algolia",
       id: 999999999,
       attributes: {
         name: "name"
       }
       }}, adapter: :json
  end
end
