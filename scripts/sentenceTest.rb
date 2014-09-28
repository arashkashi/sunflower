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
      result = Sentence.rankForSentence('arash is very good', ['arash'], 'arash')
      assert_equal 0.25, result
    end

    def test_2
      result = Sentence.rankForSentence('arash is very good', ['arash', 'is'], 'arash')
      assert_equal 0.5, result
    end

    def test_3
      hash_rank = Sentence.rankHash('arash', sentences, ['arash'])
      assert_equal hash_rank[sentences[1]], 0.25 
    end

    def test_4
      hash_rank = Sentence.rankHash('ahmad', sentences, ['arash', 'is'])
      for sentence in sentences
        assert_equal hash_rank[sentence], 0
      end
    end
end
