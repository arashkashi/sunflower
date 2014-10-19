require 'net/http'
require 'json'

module Translate

  def Translate.do(phrases)
  	uri = Translate.baseURI

  	# Make the query
  	phrases.each do |phrase|
  		uri.query = uri.query << "&" << URI.encode_www_form({:q => "#{phrase}"})
  	end

  	# Translated results in a list
  	resultList = JSON.parse(Net::HTTP.get_response(uri).body)["data"]["translations"]
  	
  	# Translated results in a hash {phrase => translation}
  	resultHash = Hash.new("")
  	resultList.each_with_index do |translation, index|
  		resultHash[phrases[index]] = translation["translatedText"]
  	end

  	resultHash
  end

  def Translate.baseURI
  	uri = URI('https://www.googleapis.com/language/translate/v2')
  	params = { :key => "AIzaSyAI21c0KYKv4dMZPQeVy3R9ZA17AfOQNy8", :source => "en",:target=>"de" }
  	uri.query = URI.encode_www_form(params)
  	uri
  end
end