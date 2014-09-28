$LOAD_PATH << '.'
require 'json'
require 'words'

module Sentence
  def Sentence.sentenceForWord(word, knownWords, sentences, n)
    sentence_rank_hash = Sentence.rankHash(word, sentences, knownWords)
    sorted_sentences_by_ranks = Words.sortedKeysByValue(sentence_rank_hash)
    return sorted_sentences_by_ranks.take(n)
  end

  def Sentence.rankHash(word, sentences, knownWords)
    sentence_rank_hash = Hash.new()
    sentences.each do |sentence|
      sentence_rank_hash[sentence] = Sentence.rankForSentence(sentence, knownWords, word)
    end
    sentence_rank_hash
  end

  def Sentence.rankForSentence(sentence, knownWords, word)
    words_in_sentence = Words.wordsFromString(sentence)
    return 0.0 unless words_in_sentence.include?(word)
    known_words_in_sentence = words_in_sentence.select {|w| knownWords.include?(w)}
    known_words_in_sentence.length.to_f / words_in_sentence.length.to_f
  end
end
