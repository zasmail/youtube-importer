class UpdateImages
  attr_reader :params
  # PARAMS need to be { id: n, is_talk: true}
  def initialize(params)
    if params[:is_playlist]
      @needs_update = Playlist.find(params[:id])
    elsif
      @needs_update = Talk.find(params[:id])
    else
      raise "Improper Params"
    end
  end

  def run
    image = get_image(@needs_update)
    @needs_update.update_attributes(
      image_url:  image[:image_url],
      hd_image:   image[:hd]
    )
    @needs_update.save
  end

  private

  def get_image(needs_update)
    test_url = "https://i.ytimg.com/vi/#{needs_update[:id]}/maxresdefault.jpg"
    url = URI.parse(test_url)
    req = Net::HTTP.new(url.host, url.port)
    req.use_ssl = true
    res = req.request_head(url.path)
    if res.code == "200"
      return {
        image_url: test_url,
        hd: true
      }
    else
      return {
        image_url: needs_update[:image_url],
        hd: false
      }
    end
  end

end
