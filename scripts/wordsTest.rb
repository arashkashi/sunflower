$LOAD_PATH << '.'

require 'words'
require "minitest/autorun"

class TestWord < Minitest::Test
    
	def test_1
		words = Words.wordsFromString('? ! .. siabash  Großzügigkeit .??#!@1')
		assert_equal 3, words.length
		assert_equal 'siabash', words[0]
		assert_equal 'großzügigkeit', words[1]
		assert_equal '1', words[2]
	end

	def test_2
		sentences = Words.sentences('wordsTest.txt')
		print sentences
		assert_equal true, sentences.length > 0
	end

	# def test_2
	# 	words = Words.words('wordsTest.txt')
	# 	assert_equal true, words.length > 0
	# end

  # def test_1
  #   words = Words.words('wordsTest.txt')
  #   assert_equal words.length > 0, true
  # end

  # def test_2
  #   knownWords = Words.knownWords(['ich', 'dish', 'mich'], 'dish')
  #   assert_equal knownWords, ['ich', 'dish']
  # end


end

