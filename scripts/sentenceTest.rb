$LOAD_PATH << '.'
require 'sentences'
require "minitest/autorun"

class TestSentence < Minitest::Test
    def sentences
      sentences = []
      sentences << 'arash is good'
      sentences << 'arash is good boy'
      sentences << 'arash and kiarash is good boy' 
      sentences
    end 
    
    def words
      ['arash', 'kiarash', 'is', 'good', 'boy']
    end

    def test_1
      words = words 
      result = Sentence.sentenceForWord('arash', ['arash'], sentences)
      assert_equal "arash is good", result
    end

    def test_2
      result = Sentence.sentenceForWord('arash', ['kiarash', 'boy'], sentences)
      assert_equal "arash and kiarash is good boy", result
    end

    def test_3
      result = Sentence.sentenceForWord('kiarash', ['boy'], sentences)
      assert_equal "arash and kiarash is good boy", result
    end

     
end
