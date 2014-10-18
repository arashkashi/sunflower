require 'net/http'

uri = URI('www.googleapis.com/language/translate/v2')

params = { :key => "AIzaSyAI21c0KYKv4dMZPQeVy3R9ZA17AfOQNy8", :page => 3 }
uri.query = URI.encode_www_form(params)

Net::HTTP.start(uri.host, uri.port) do |http|
  request = Net::HTTP::Get.new uri

  response = http.request request # Net::HTTPResponse object

  puts response.body if response.is_a?(Net::HTTPSuccess)
end
