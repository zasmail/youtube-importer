class BaseSerializer < ActiveModel::Serializer
  # def api_link(path)
  #   return path if api_version.nil?
  #   "/api/#{api_version}/#{path}"
  # end
  #
  # def api_version
  #   'v1'
  #   # prefixes = serialization_options[:prefixes]
  #   # prefixes.each do |prefix|
  #   #   api_version = prefix.scan(/api\/(v\d+)\//).first
  #   #   return api_version.first if api_version
  #   # end
  #   # return nil
  # end
end
