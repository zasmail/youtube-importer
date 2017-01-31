class AlgoliaController < ApplicationController
  def create(param='false')
    PushToAlgoliaJob.perform_later()
    render json: {data: {
       type: "algolia",
       id: 999999999,
       attributes: {
         name: "name"
       }
       }}, adapter: :json
  end
end
