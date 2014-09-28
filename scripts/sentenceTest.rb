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

    def prettyPrint(word, knownWords, sentences)
      puts "Word => \t\t#{word}"
      # puts "KnownWords \t\t\t:#{knownWords}"
      puts "Sentences =>"
      for sentence in sentences
        puts "\t\t #{sentence}"
      end
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

    def test_5
      raw_sentences = Words.sentences('wordsTest.txt')
      words = Words.words('wordsTest.txt')
      word = words[50]
      knownWords = Words.knownWords(words, word)
      result_sentences = Sentence.sentenceForWord(word, knownWords, raw_sentences, 5)
      prettyPrint(word, knownWords, result_sentences)
    end

    def test_6
      result = Hash.new { |hash, key| hash[key] = Hash.new({}) }
      raw_sentences = Words.sentences('wordsTest.txt')
      words = Words.words('wordsTest.txt')
      word = words[50]

      knownWords = Words.knownWords(words, word)
      sample_sentences = Sentence.sentenceForWord(word, knownWords, raw_sentences, 10)
      result[word]['sample_sentences'] = sample_sentences

      File.open("xxx.json","w") do |f|
        f.write(result.to_json)
        f.close
      end
      
    end
end
