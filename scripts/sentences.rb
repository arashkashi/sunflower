$LOAD_PATH << '.'
require 'json'
require 'words'
require 'minitest/autorun'


module Sentence
  include Words
  def Sentence.sentences(filename)
    result = []
    file = File.open(filename, 'rb')

    file.each_line do |raw_sentence|
      result << raw_sentence.gsub("\n", '')
    end
    result
  end

  def Sentence.sentenceForWord(word, knownWords, sentences)
    result = Hash.new()
    knownWords << word
    for sentence in sentences
      words_in_sentence = Words.wordsFromString(sentence)
      known_words_in_sentence = words_in_sentence.select {|w| knownWords.include?(w)}
      result[sentence] = known_words_in_sentence.length.to_f / words_in_sentence.length
    end
    result = result.sort_by {|key, value| -value}
    result.first.first
  end
end

#puts Sentence.sentences(ARGV[0])

#File.open('sentences.json', 'w') do |f|
#  f.write(hash_of_sentences.to_json)
#end


words = ['arash', 'kiarash', 'is', 'good', 'boy']
sentences = []
sentences << 'arash is good'
sentences << 'arash is good boy'
sentences << 'arash and kiarash is good boy'

result = Sentence.sentenceForWord('arash', ['arash'], sentences)

