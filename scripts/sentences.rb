require 'json'

module Sentence
  def Sentence.sentences(filename)
    hash_of_sentences = Hash.new(0)
    file = File.open(filename, 'rb')

    file.each_line do |raw_sentence|
      words = raw_sentence.split(' ')
      key = []
      words.each do |word|
        if word
          word = word.downcase
          key << word
        end
      end
  
      if key.length > 0
        key = key.sort
       hash_of_sentences[key] = raw_sentence
      end
      break if hash_of_sentences.length > 10
    end
    hash_of_sentences
  end
end

puts Sentence.sentences(ARGV[0])

#File.open('sentences.json', 'w') do |f|
#  f.write(hash_of_sentences.to_json)
#end
