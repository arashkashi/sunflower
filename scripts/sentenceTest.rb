$LOAD_PATH << '.'
require 'sentences'
require "minitest/autorun"
require 'words'

class TestSentence < Minitest::Test
    def sentences
      sentences = []
      sentences << 'arash is good'
      sentences << 'arash is good boy'
      sentences << 'arash and kiarash is good boy' 
      sentences
    end 
    
    def words
      words_hash = Hash.new(0)
      for sentence in sentences
        words = Words.wordsForString(sentence)
        for word in words
          words_hash[word] = words_Hash[word] + 1
        end
      end
      words_hash
      ['arash', 'kiarash', 'is', 'good', 'boy']
    end

    def test_1
      words = words 
      result = Sentence.sentenceForWord('arash', ['arash'], sentences, 1)
      assert_equal "arash is good", result[0]
    end

    def test_2
      result = Sentence.sentenceForWord('arash', ['kiarash', 'boy'], sentences, 1)
      assert_equal "arash and kiarash is good boy", result[0]
    end

    def test_3
      result = Sentence.sentenceForWord('kiarash', ['boy'], sentences, 1)
      assert_equal "arash and kiarash is good boy", result[0]
    end

end
