$LOAD_PATH << '.'

require 'json'
require 'error'
# require 'sentence'

module Words
  def Words.words(filename)
    sentences = Words.sentences(filename)
    Words.freqSortedWordsFromSentences(sentences)
  end

  def Words.sentences(filename)
    result = []
    File.open(filename, 'rb') do |f|
      f.each_line do |raw_sentence|
        result << raw_sentence.gsub("\n", '')
      end
      f.close
    end
    result
  end

  def Words.freqSortedWordsFromSentences(sentences)
    hash_of_words = Words.hashOfWordsFromSentences(sentences)
    Words.sortedKeysByValues(hash_of_words)
  end

  def Words.knownWords(words, word)
    index = words.index(word) - 1
    return words[0..index]
  end

  def Words.hashOfWordsFromSentences(sentences)
    hash_of_words = Hash.new(0)
    for sentence in sentences
      words = Word.wordsFromString(sentence)
      for word in words
        hash_of_words[word] = hash_of_words[word] + 1
      end
    end
    hash_of_words
  end

  def Words.sortedKeysByValue(hash)
    final_result
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
  
  def Words.wordsFromString(input_string)
    result = []
    words = input_string.gsub("\n", '').split(' ')
    words.each do |word|
      word = word.gsub(/[;:,\.']/, '')
      if word
        word = word.downcase
        result << word
      end 
    end
    Error.error("Words.wordsFromString > " + input_string) if result.length == 0
    result
  end
end
