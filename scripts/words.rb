# encoding: utf-8
$LOAD_PATH << '.'

require 'json'
require 'error'

module Words

  # TODO: Make sure everything is stripped off properly
  def Words.wordsFromString(input_string)
    result = []
    input_string.force_encoding('UTF-8').encoding
    words = input_string.gsub("\n", '').split(' ')
    words.each do |word|
      word.gsub!(/[^\p{Alnum}\p{Space}-]/, '')
      if word && word.length > 0
        word = word.downcase
        result << word
      end 
    end
    Error.error("Words.wordsFromString > #{input_string}") if result.length == 0
    result
  end

  def Words.cleanupString(input)
    input.gsub(/[^\p{Alnum}\p{Space}-]/, '')
  end

  def Words.words(filename)
    sentences = Words.sentences(filename)
    Words.freqSortedWordsFromSentences(sentences)
  end

  def Words.sentences(filename)
    result = []
    File.open(filename, 'rb') do |f|
      f.each_line do |raw_sentence|
          raw_sentence = raw_sentence.strip
          result << raw_sentence.gsub("\n", '').downcase if raw_sentence.length > 0
      end
      f.close
    end
    result
  end

  def Words.freqSortedWordsFromSentences(sentences)
    hash_of_words = Words.hashOfWordsFromSentences(sentences)
    Words.sortedKeysByValue(hash_of_words)
  end

  def Words.knownWords(words, word)
    index = words.index(word) - 1
    index = 0 if index < 0 || index > words.length - 1
    return words[0..index]
  end

  def Words.hashOfWordsFromSentences(sentences)
    hash_of_words = Hash.new(0)
    for sentence in sentences
      words = Words.wordsFromString(sentence)
      for word in words
        hash_of_words[word] = hash_of_words[word] + 1
      end
    end
    hash_of_words
  end

  def Words.sortedKeysByValue(hash)
    final_result = []
    keys_values = hash.sort_by { |key, value| - value }
    keys_values.each do |key_value|
      final_result << key_value[0]
    end
    final_result
  end

  def Words.validateHashHasValue(hash)
    hash.each do |key, value|
      Error.error("Words.validateHashHasValue>" + key) if value.nan? || value.nil?
    end
  end
  
end
