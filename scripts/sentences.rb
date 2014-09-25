$LOAD_PATH << '.'

require 'json'
require 'words'

module Sentence
  include Words
  def Sentence.sentences(filename)
    hash_of_sentences = Hash.new(0)

    file = File.open(filename, 'rb')

    file.each_line do |raw_sentence|
      raw_sentence = raw_sentence.gsub("\n", '')
      words = Words.wordsFromString(raw_sentence)
      
      hash_of_sentences[words.sort] = raw_sentence if words.length > 0
      break if hash_of_sentences.keys.length > 10
    end
    
    hash_of_sentences
  end

  def sortedSentenceForWord(word, knownWords, sentences)
    result = Hash.new()
    for sentence in sentences
      words_in_sentence = Words.wordsFromString(sentence)
      known_words_in_sentence = words_in_sentence.select {|word| knownWords.include?(word)}
      result[sentence] = known_words_in_sentence.length.to_f / words_in_sentence.length
    end
    result.sort_by {|key, value| -value}
  end
end

puts "Aras"
puts Sentence.sentences(ARGV[0])

#File.open('sentences.json', 'w') do |f|
#  f.write(hash_of_sentences.to_json)
#end
