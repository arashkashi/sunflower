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
    
    def test_1
      result = Sentence.rankForSentence('arash is very good', ['arash'])
      assert_equal 0.25, result
    end

    def test_2
      result = Sentence.rankForSentence('arash is very good', ['arash', 'is'])
      assert_equal 0.5, result
    end

end
