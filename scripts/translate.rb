require 'net/http'
require 'json'

module Translate

  # Sample json output
  # {
  #   "data": {
  #     "translations": [
  #       {
  #         "translatedText": "I"
  #       },
  #       {
  #         "translatedText": ""
  #       }
  #     ]
  #   }
  # }
  def Translate.do(phrases)
  	uri = Translate.baseURI

  	# Make the query
  	phrases.each do |phrase|
  		uri.query = uri.query << "&" << URI.encode_www_form({:q => "#{phrase}"})
  	end

  	# Translated results in a list
    JSON.parse(Net::HTTP.get_response(uri).body)
  end

  def Translate.listFromStandardOutput(output)
    output["data"]["translations"].map { |hash| hash["translatedText"]}
  end

  def Translate.baseURI
  	uri = URI('https://www.googleapis.com/language/translate/v2')
  	params = { :key => "AIzaSyAI21c0KYKv4dMZPQeVy3R9ZA17AfOQNy8", :source => "de",:target=>"en" }
  	uri.query = URI.encode_www_form(params)
  	uri
  end
end