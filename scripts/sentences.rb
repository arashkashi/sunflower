$LOAD_PATH << '.'
require 'json'
require 'words'
require 'test'

module Sentence
  def Sentence.sentenceForWord(word, knownWords, sentences, n)
    result = Hash.new()
    sentences.each do |sentence|
      words_in_sentence = Words.wordsFromString(sentence)
      if words_in_sentence.length > 0
        known_words_in_sentence = words_in_sentence.select {|w| knownWords.include?(w)}
        result[sentence] = known_words_in_sentence.length.to_f / words_in_sentence.length
      end
    end
    final_result = []
    result.sort_by {|key, value| -value}.map do |pair|
      final_result << pair[0]
    end
    return final_result.take(n)
  end
end
